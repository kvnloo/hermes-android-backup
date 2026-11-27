// Disposable test-only peer. Does not execute commands, start Hermes or dial
// any target. The direct-tcpip responses come from the fixture itself.
package main

import (
	"bufio"
	"bytes"
	"crypto/ed25519"
	"crypto/rand"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"strings"
	"time"

	"golang.org/x/crypto/ssh"
)

func main() {
	key, err := os.ReadFile(os.Args[1])
	if err != nil {
		panic(err)
	}
	client, _, _, _, err := ssh.ParseAuthorizedKey(key)
	if err != nil {
		panic(err)
	}
	_, private, err := ed25519.GenerateKey(rand.Reader)
	if err != nil {
		panic(err)
	}
	signer, err := ssh.NewSignerFromKey(private)
	if err != nil {
		panic(err)
	}
	config := &ssh.ServerConfig{PublicKeyCallback: func(meta ssh.ConnMetadata, pub ssh.PublicKey) (*ssh.Permissions, error) {
		if meta.User() == "fixture" && bytes.Equal(pub.Marshal(), client.Marshal()) {
			return nil, nil
		}
		return nil, fmt.Errorf("refused")
	}}
	config.AddHostKey(signer)
	listener, err := net.Listen("tcp4", "127.0.0.1:0")
	if err != nil {
		panic(err)
	}
	defer listener.Close()
	json.NewEncoder(os.Stdout).Encode(map[string]any{"port": listener.Addr().(*net.TCPAddr).Port, "key": strings.TrimSpace(string(ssh.MarshalAuthorizedKey(signer.PublicKey()))), "fingerprint": ssh.FingerprintSHA256(signer.PublicKey())})
	for {
		conn, err := listener.Accept()
		if err != nil {
			return
		}
		go serve(conn, config)
	}
}
func serve(c net.Conn, config *ssh.ServerConfig) {
	defer c.Close()
	c.SetDeadline(time.Now().Add(time.Minute))
	s, chs, reqs, err := ssh.NewServerConn(c, config)
	if err != nil {
		return
	}
	defer s.Close()
	go ssh.DiscardRequests(reqs)
	for ch := range chs {
		go channel(ch)
	}
}
func channel(n ssh.NewChannel) {
	switch n.ChannelType() {
	case "direct-tcpip":
		var dest struct {
			Host       string
			Port       uint32
			Origin     string
			OriginPort uint32
		}
		err := ssh.Unmarshal(n.ExtraData(), &dest)
		if err != nil || dest.Host != "127.0.0.1" || (dest.Port != 9119 && dest.Port != 3000) {
			n.Reject(ssh.Prohibited, "fixture destinations only")
			return
		}
		ch, r, err := n.Accept()
		if err != nil {
			return
		}
		defer ch.Close()
		go ssh.DiscardRequests(r)
		q, err := http.ReadRequest(bufio.NewReader(ch))
		if err != nil {
			return
		}
		if q.Method != "GET" || q.Header.Get("Authorization") != "" || q.Header.Get("Cookie") != "" {
			return
		}
		switch {
		case dest.Port == 9119 && q.URL.Path == "/api/health":
			io.WriteString(ch, "HTTP/1.0 200 OK\r\nContent-Type: application/json\r\n\r\n{\"ok\":true}")
		case dest.Port == 3000 && q.URL.Path == "/":
			io.WriteString(ch, "HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\npreview-fixture")
		}
	case "session":
		ch, r, err := n.Accept()
		if err != nil {
			return
		}
		defer ch.Close()
		for req := range r {
			switch req.Type {
			case "pty-req":
				req.Reply(true, nil)
			case "shell":
				req.Reply(true, nil)
				line, _ := bufio.NewReader(ch).ReadString('\n')
				fmt.Fprintf(ch, "fixture-shell: %s", line)
				ch.SendRequest("exit-status", false, ssh.Marshal(struct{ Code uint32 }{0}))
				return
			default:
				req.Reply(false, nil)
			}
		}
	default:
		n.Reject(ssh.UnknownChannelType, "disabled")
	}
}
