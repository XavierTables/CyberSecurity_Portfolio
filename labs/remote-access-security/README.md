# Remote Access Security: SSH and VNC

**CySA+ lab analysis** · Kali Linux · Metasploitable 2 · Metasploit

[Portfolio](../../README.md) · [SSH analysis](ssh-analysis.md) · [VNC analysis](vnc-analysis.md) · [Screenshots](evidence/README.md)

## What I wanted to find out

A tool reporting a successful login sounds straightforward, but I wanted to know what that actually proves. Does it mean a password worked? Did it create a session? What level of access did it provide?

I compared the SSH and VNC results from my SecurePath training because they show why those questions matter.

## Findings

| Service | What the output showed | My conclusion |
| --- | --- | --- |
| **SSH — TCP 22** | `ssh_login` accepted `msfadmin:msfadmin`; an SSH session opened; `whoami` returned `msfadmin` | The account had working remote shell access |
| **VNC — TCP 5900** | Nmap identified VNC; `vnc_login` accepted the password `password` | Weak authentication was confirmed in the exercise; a desktop session was not shown |

The issue in both cases is **weak or known credentials on remote-management services**. The difference is how far the evidence goes.

## SSH: verify the access, not just the password

The Metasploit SSH login module reported a successful match:

![SSH scanner showing successful authentication](evidence/ssh-login-reported.webp)

That result matters, but I would not stop there. The follow-up selected the shell session and ran `whoami`:

![SSH session displaying the authenticated user](evidence/ssh-session-whoami.webp)

The response was `msfadmin`. I can describe the result as an **authenticated command-line session as msfadmin**. Nothing in these results establishes root privileges or exploitation of the SSH software itself.

[My SSH analysis](ssh-analysis.md)

## VNC: a successful password check is not the whole story

The VNC exercise targeted TCP 5900 with Metasploit's `vnc_login` scanner. It reported:

![VNC scanner showing the accepted password](evidence/vnc-password-reported.webp)

The accepted password was `password`, which is a serious warning sign for remote access. However, a successful scanner login and a verified graphical desktop session are two different outcomes. I'd want a permitted viewer connection before reporting desktop control.

[My VNC analysis](vnc-analysis.md)

## How I'd handle this at work

My first move wouldn't be to call either one a breach. I'd establish the asset owner, whether access was authorized, and whether the service was reachable from networks that shouldn't have access.

For SSH I'd examine authentication logs, successful and failed logins, source addresses, account privileges, and activity after login. For VNC I'd check network rules, the product's authentication settings, encryption, and remote-session records.

My recommendations would be to replace default or shared passwords, limit management access to approved users and networks, disable unused accounts, and monitor suspicious login patterns. After changes, I'd verify that the old credentials fail and authorized access still works.

## My takeaway

**A scanner result is a starting point.** For SSH, the session and account check confirmed the type of access. For VNC, the password check was positive but graphical access still needed verification.

That's the distinction I'd want to make before escalating a finding or writing a security report.

[SSH details](ssh-analysis.md) · [VNC details](vnc-analysis.md) · [Screenshot sources](evidence/README.md) · [Practice commands](../reproduce-and-capture.md)

## References

- [Metasploit documentation](https://docs.metasploit.com/)
- [OpenSSH manuals](https://www.openssh.com/manual.html)
- [Nmap reference guide](https://nmap.org/book/man.html)
