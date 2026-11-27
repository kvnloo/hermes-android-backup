// Private pipe child on Windows 10 1809+. Open only the system cmd.exe in
// a ConPTY. Closing the parent pipe closes this job, not other user jobs.
#define _WIN32_WINNT 0x0A00
#include <windows.h>
#include <cstdint>
#include <string>
#include <thread>
#include <vector>

static bool copy_bytes(HANDLE handle, BYTE* p, DWORD n, bool reading) {
  while (n) {
    DWORD used = 0;
    BOOL ok = reading ? ReadFile(handle,p,n,&used,nullptr) : WriteFile(handle,p,n,&used,nullptr);
    if (!ok || !used) return false;
    p += used; n -= used;
  }
  return true;
}
static bool env_key_is(const std::wstring& entry, const wchar_t* key) {
  const auto eq = entry.find(L'=');
  const size_t n = eq == std::wstring::npos ? entry.size() : eq;
  size_t i = 0;
  for (; key[i] && i < n; ++i) {
    wchar_t c = entry[i];
    wchar_t k = key[i];
    if (c >= L'A' && c <= L'Z') c = static_cast<wchar_t>(c - L'A' + L'a');
    if (k >= L'A' && k <= L'Z') k = static_cast<wchar_t>(k - L'A' + L'a');
    if (c != k) return false;
  }
  return key[i] == L'\0' && i == n;
}

// cmd.exe inherits this block. A stripped parent environment still gets
// System32 on PATH, or system commands such as findstr cannot start.
static std::wstring environment_block() {
  wchar_t system[MAX_PATH];
  const UINT got = GetSystemDirectoryW(system, MAX_PATH);
  const std::wstring system32 = got ? std::wstring(system, got) : L"";
  std::wstring windows = system32;
  const auto slash = windows.find_last_of(L"\\/");
  if (slash != std::wstring::npos) windows.resize(slash);
  const std::wstring minimal =
      system32.empty() ? L"" : system32 + L";" + windows;
  std::wstring out;
  bool saw_path = false;
  bool saw_root = false;
  wchar_t* block = GetEnvironmentStringsW();
  if (block) {
    for (const wchar_t* p = block; *p;) {
      const wchar_t* start = p;
      while (*p) ++p;
      std::wstring entry(start, p);
      ++p;
      if (env_key_is(entry, L"path") && !minimal.empty()) {
        saw_path = true;
        const auto eq = entry.find(L'=');
        const std::wstring value =
            eq == std::wstring::npos ? L"" : entry.substr(eq + 1);
        if (value.find(system32) == std::wstring::npos) {
          entry = L"PATH=" + minimal + (value.empty() ? L"" : L";") + value;
        }
      } else if (env_key_is(entry, L"systemroot")) {
        saw_root = true;
      }
      out.append(entry);
      out.push_back(L'\0');
    }
    FreeEnvironmentStringsW(block);
  }
  if (!saw_path && !minimal.empty()) {
    out.append(L"PATH=" + minimal);
    out.push_back(L'\0');
  }
  if (!saw_root && !windows.empty()) {
    out.append(L"SystemRoot=" + windows);
    out.push_back(L'\0');
  }
  out.push_back(L'\0');
  return out;
}

int main() {
  HANDLE inRead, inWrite, outRead, outWrite;
  if (!CreatePipe(&inRead,&inWrite,nullptr,0) || !CreatePipe(&outRead,&outWrite,nullptr,0)) return 1;
  HPCON pty;
  if (FAILED(CreatePseudoConsole({80,24},inRead,outWrite,0,&pty))) return 1;
  CloseHandle(inRead); CloseHandle(outWrite);
  SIZE_T bytes=0;
  InitializeProcThreadAttributeList(nullptr,1,0,&bytes);
  std::vector<BYTE> storage(bytes);
  STARTUPINFOEXW si{}; si.StartupInfo.cb=sizeof(si);
  si.lpAttributeList=reinterpret_cast<LPPROC_THREAD_ATTRIBUTE_LIST>(storage.data());
  if (!InitializeProcThreadAttributeList(si.lpAttributeList,1,0,&bytes) ||
      !UpdateProcThreadAttribute(si.lpAttributeList,0,PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,pty,sizeof(pty),nullptr,nullptr)) return 1;
  wchar_t dir[MAX_PATH];
  auto n=GetSystemDirectoryW(dir,MAX_PATH); if (!n || n>=MAX_PATH) return 1;
  auto exe=std::wstring(dir)+L"\\cmd.exe";
  auto job=CreateJobObjectW(nullptr,nullptr);
  JOBOBJECT_EXTENDED_LIMIT_INFORMATION limits{};
  limits.BasicLimitInformation.LimitFlags=JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
  if (!job || !SetInformationJobObject(job,JobObjectExtendedLimitInformation,&limits,sizeof(limits))) return 1;
  PROCESS_INFORMATION pi{};
  wchar_t cmd[]=L"cmd.exe /D"; // do not run registry AutoRun commands
  auto env=environment_block();
  if (!CreateProcessW(exe.c_str(),cmd,nullptr,nullptr,FALSE,EXTENDED_STARTUPINFO_PRESENT|CREATE_SUSPENDED|CREATE_UNICODE_ENVIRONMENT,env.empty()?nullptr:&env[0],nullptr,&si.StartupInfo,&pi)) return 1;
  if (!AssignProcessToJobObject(job,pi.hProcess) || ResumeThread(pi.hThread)==DWORD(-1)) {TerminateProcess(pi.hProcess,1);return 1;}
  CloseHandle(pi.hThread); DeleteProcThreadAttributeList(si.lpAttributeList);
  auto ended=CreateEventW(nullptr,TRUE,FALSE,nullptr);
  if (!ended) return 1;
  std::thread([=]{
    BYTE b[8192]; DWORD k;
    while (ReadFile(outRead,b,sizeof(b),&k,nullptr) && k && copy_bytes(GetStdHandle(STD_OUTPUT_HANDLE),b,k,false)) {}
    SetEvent(ended);
  }).detach();
  std::thread([=]{
    auto in=GetStdHandle(STD_INPUT_HANDLE); BYTE h[5], b[65536];
    while(copy_bytes(in,h,5,true)) {
      if (h[0]==1) {
        COORD sz{SHORT(h[1]*256+h[2]),SHORT(h[3]*256+h[4])};
        if (sz.X<=0 || sz.Y<=0 || FAILED(ResizePseudoConsole(pty,sz))) break;
      } else if (h[0]==0) {
        DWORD len=(DWORD(h[1])<<24)|(DWORD(h[2])<<16)|(DWORD(h[3])<<8)|h[4];
        if(len>sizeof b || !copy_bytes(in,b,len,true) || !copy_bytes(inWrite,b,len,false)) break;
      } else break;
    }
    SetEvent(ended);
  }).detach();
  HANDLE any[]={ended,pi.hProcess}; WaitForMultipleObjects(2,any,FALSE,INFINITE);
  CloseHandle(job); ClosePseudoConsole(pty);
  return 0;
}
