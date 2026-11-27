// A private stdio child, not a daemon. No arguments, socket, or exec string.
#ifdef __APPLE__
#include <libproc.h>
#include <sys/proc.h>
#include <util.h>
#else
#include <dirent.h>
#include <pty.h>
#endif
#include <cerrno>
#include <chrono>
#include <csignal>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <set>
#include <sys/ioctl.h>
#include <sys/poll.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

static bool transfer(int fd, void* ptr, size_t n, bool reading) {
  auto* p = static_cast<unsigned char*>(ptr);
  while (n) {
    ssize_t k = reading ? read(fd, p, n) : write(fd, p, n);
    if (k < 0 && errno == EINTR) continue;
    if (k <= 0) return false;
    p += k; n -= k;
  }
  return true;
}

struct Proc {
  pid_t pid;
  pid_t ppid;
  pid_t pgid;
  uint64_t start;
  bool live;
};

#ifdef __APPLE__
static std::vector<pid_t> list_pids() {
  int bytes = proc_listpids(PROC_ALL_PIDS, 0, nullptr, 0);
  if (bytes <= 0) return {};
  std::vector<pid_t> pids(static_cast<size_t>(bytes) / sizeof(pid_t) + 64);
  bytes = proc_listpids(PROC_ALL_PIDS, 0, pids.data(),
                        static_cast<int>(pids.size() * sizeof(pid_t)));
  if (bytes <= 0) return {};
  pids.resize(static_cast<size_t>(bytes) / sizeof(pid_t));
  return pids;
}

static bool describe(pid_t pid, Proc* out) {
  if (pid <= 0) return false;
  proc_bsdinfo info{};
  const int n = proc_pidinfo(pid, PROC_PIDTBSDINFO, 0, &info, sizeof info);
  if (n != static_cast<int>(sizeof info) || info.pbi_pid == 0) return false;
  out->pid = static_cast<pid_t>(info.pbi_pid);
  out->ppid = static_cast<pid_t>(info.pbi_ppid);
  out->pgid = static_cast<pid_t>(info.pbi_pgid);
  out->start = info.pbi_start_tvsec * 1000000ull + info.pbi_start_tvusec;
  out->live = info.pbi_status != SZOMB;
  return true;
}
#else
static std::vector<pid_t> list_pids() {
  std::vector<pid_t> pids;
  DIR* dir = opendir("/proc");
  if (!dir) return pids;
  while (dirent* ent = readdir(dir)) {
    if (ent->d_name[0] < '1' || ent->d_name[0] > '9') continue;
    pids.push_back(static_cast<pid_t>(std::atoi(ent->d_name)));
  }
  closedir(dir);
  return pids;
}

// /proc/pid/stat tokens after the final ')' of comm. starttime is the 20th.
static bool describe(pid_t pid, Proc* out) {
  if (pid <= 0) return false;
  char path[64];
  std::snprintf(path, sizeof path, "/proc/%d/stat", static_cast<int>(pid));
  FILE* file = std::fopen(path, "r");
  if (!file) return false;
  char buf[1024];
  const bool ok = std::fgets(buf, sizeof buf, file) != nullptr;
  std::fclose(file);
  if (!ok) return false;
  char* cursor = std::strrchr(buf, ')');
  if (!cursor) return false;
  ++cursor;
  char* tokens[22] = {};
  int count = 0;
  while (*cursor && count < 22) {
    while (*cursor == ' ') ++cursor;
    if (!*cursor) break;
    tokens[count++] = cursor;
    while (*cursor && *cursor != ' ') ++cursor;
    if (*cursor) {
      *cursor = '\0';
      ++cursor;
    }
  }
  if (count < 20 || !tokens[0] || !tokens[0][0]) return false;
  out->pid = pid;
  out->ppid = static_cast<pid_t>(std::strtol(tokens[1], nullptr, 10));
  out->pgid = static_cast<pid_t>(std::strtol(tokens[2], nullptr, 10));
  out->start = std::strtoull(tokens[19], nullptr, 10);
  out->live = tokens[0][0] != 'Z';
  return true;
}
#endif

static std::vector<Proc> snapshot() {
  std::vector<Proc> all;
  for (pid_t pid : list_pids()) {
    Proc proc{};
    if (describe(pid, &proc)) all.push_back(proc);
  }
  return all;
}

static bool same_proc(const Proc& was) {
  Proc now{};
  if (!describe(was.pid, &now) || !now.live) return false;
  return was.start == 0 || now.start == was.start;
}

// Job-control shells put background jobs in their own process groups, so the
// shell's group does not include them. Collect the descendant tree before
// signalling: once the shell exits, those jobs are reparented and disappear
// from a parent walk.
static void absorb(std::vector<Proc>* procs) {
  const std::vector<Proc> all = snapshot();
  std::set<pid_t> known;
  for (const Proc& proc : *procs) known.insert(proc.pid);
  bool grew = true;
  while (grew) {
    grew = false;
    for (const Proc& proc : all) {
      if (proc.pid <= 1 || known.count(proc.pid) != 0) continue;
      if (known.count(proc.ppid) == 0) continue;
      procs->push_back(proc);
      known.insert(proc.pid);
      grew = true;
    }
  }
}

static bool any_live(const std::vector<Proc>& procs) {
  for (const Proc& proc : procs) {
    if (same_proc(proc)) return true;
  }
  return false;
}

static void signal_groups(const std::vector<Proc>& procs, int sig) {
  const pid_t self = getpgrp();
  std::set<pid_t> groups;
  for (const Proc& proc : procs) {
    if (!same_proc(proc) || proc.pid == getpid()) continue;
    const pid_t pg = getpgid(proc.pid);
    if (pg <= 1 || pg == self) continue;
    if (proc.pgid > 1 && pg != proc.pgid) continue;
    groups.insert(pg);
  }
  for (pid_t pg : groups) {
    if (kill(-pg, sig) < 0 && errno != ESRCH) continue;
  }
}

// macOS will not finish exiting a process that still has unread PTY output.
static void grace(int master, const std::vector<Proc>& procs) {
  const auto deadline =
      std::chrono::steady_clock::now() + std::chrono::milliseconds(500);
  unsigned char buf[4096];
  bool master_open = master >= 0;
  while (std::chrono::steady_clock::now() < deadline) {
    if (!any_live(procs)) return;
    const auto left = std::chrono::duration_cast<std::chrono::milliseconds>(
                          deadline - std::chrono::steady_clock::now())
                          .count();
    if (left <= 0) return;
    const int slice = left > 20 ? 20 : static_cast<int>(left);
    if (!master_open) {
      poll(nullptr, 0, slice);
      continue;
    }
    pollfd fd{master, POLLIN, 0};
    const int rc = poll(&fd, 1, slice);
    if (rc < 0) {
      if (errno == EINTR) continue;
      master_open = false;
      continue;
    }
    if (rc > 0 && (fd.revents & (POLLIN | POLLHUP | POLLERR))) {
      const ssize_t n = read(master, buf, sizeof buf);
      if (n < 0 && errno == EINTR) continue;
      if (n <= 0) master_open = false;
    }
  }
}

// SIGHUP, then SIGTERM, then SIGKILL, each with up to half a second of grace
// while any descendant is still alive. Mirrors Desktop's PTY bridge close.
static void escalate(int master, pid_t child) {
  std::vector<Proc> procs;
  Proc root{};
  if (!describe(child, &root)) {
    root.pid = child;
    root.ppid = getpid();
    const pid_t pg = getpgid(child);
    root.pgid = pg > 0 ? pg : child;
    root.start = 0;
    root.live = true;
  }
  procs.push_back(root);
  const int signals[] = {SIGHUP, SIGTERM, SIGKILL};
  for (int sig : signals) {
    absorb(&procs);
    if (!any_live(procs)) return;
    signal_groups(procs, sig);
    grace(master, procs);
    if (!any_live(procs)) return;
  }
}

int main() {
  int master;
  winsize size{24, 80, 0, 0};
  const pid_t child = forkpty(&master, nullptr, nullptr, &size);
  if (child == -1) return 1;
  if (!child) {
    execl("/bin/sh", "sh", "-i", static_cast<char*>(nullptr));
    _exit(127);
  }
  signal(SIGPIPE, SIG_IGN);
  unsigned char buf[65536];
  pollfd fds[] = {{0, POLLIN, 0}, {master, POLLIN, 0}};
  while (true) {
    if (poll(fds, 2, -1) < 0) { if (errno == EINTR) continue; break; }
    if (fds[1].revents) {
      const ssize_t k = read(master, buf, sizeof buf);
      if (k <= 0 || !transfer(1, buf, k, false)) break;
    }
    if (!fds[0].revents) continue;
    // Five-byte header: data (0, uint32 big-endian length) or resize
    // (1, two uint16 big-endian dimensions). EOF is an explicit close.
    unsigned char h[5];
    if (!transfer(0, h, sizeof h, true)) break;
    if (h[0] == 1) {
      size.ws_col = (h[1] << 8) | h[2]; size.ws_row = (h[3] << 8) | h[4];
      if (!size.ws_col || !size.ws_row || ioctl(master,TIOCSWINSZ,&size)<0) break;
    } else if (h[0] == 0) {
      const uint32_t n = (uint32_t(h[1])<<24)|(uint32_t(h[2])<<16)|(uint32_t(h[3])<<8)|h[4];
      if (n>sizeof buf || !transfer(0,buf,n,true) || !transfer(master,buf,n,false)) break;
    } else break;
  }
  escalate(master, child);
  close(master);
  int status = 0;
  while (waitpid(child, &status, 0) < 0 && errno == EINTR) {}
  return WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}
