# VNC Authentication | Port 5900 and a Weak Password

[Combined assessment](README.md) · [Evidence](evidence/README.md) · [Recreate this lab](../reproduce-and-capture.md)

## Service discovery

The lab example runs Nmap against Metasploitable:

```text
nmap 192.168.1.106 -sV -p 5900
5900/tcp open vnc VNC (protocol 3.3)
```

![Nmap detects VNC in the training example](evidence/vnc-nmap-port5900.webp)

*Exercise 3, p.9 — VNC service identified on TCP 5900.*

The first answer is simply that a VNC service is reachable **from the scanning VM**. Nmap does not establish that the service is reachable from the internet.

## Credential test

The Metasploit module `auxiliary/scanner/vnc/vnc_login` tries the lab's password candidates. The slide shows:

```text
Starting VNC login sweep
Login Successful: :password
Scanned 1 of 1 hosts (100% complete)
```

![Metasploit VNC weak password success from the guided slide](evidence/vnc-password-reported.webp)

*Exercise 3, p.15 — `password` accepted.*

## My conclusion

The demonstrated configuration accepts a weak VNC password, which could permit inappropriate remote desktop access **if** the service is accessible to an unauthorized actor. But the slide stops at authentication; it does not show a VNC viewer attached to a desktop. My finding is **successful password authentication**, not verified desktop takeover.

Despite its PDF title, this is a **VNC**, not **VPN**, activity.

## Defensive response

I would check network reachability, remote-access ownership, authentication settings, encryption, successful-login records, and intended user permissions. The fix would center on strong nonshared credentials, restricting reachable management interfaces, and any stronger authentication supported by the selected VNC product.

A useful follow-up would be an authorized viewer-session test and a post-remediation negative test. Neither is shown in these materials.

**Source:** Crops from *Lab Exercise 3 — How to Hack VPN Port 5900*, pp.9 and 15; source notes appear in the [evidence index](evidence/README.md).
