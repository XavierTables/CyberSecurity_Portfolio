# VNC Authentication: Investigating Port 5900

[Back to remote-access assessment](README.md) · [Screenshot sources](evidence/README.md)

## Objective

Find a remote-desktop service, check whether a weak password is accepted, and determine how much access the result actually proves.

## Approach

The lab uses Nmap to identify the VNC service on TCP 5900:

```bash
nmap -sV -p 5900 192.168.1.106
```

![VNC service identified](evidence/vnc-nmap-port5900.webp)

The scan reports `5900/tcp open vnc` with VNC protocol version 3.3. That shows a listener responded on the lab network; it doesn't show the server was exposed to the public internet.

Next, the Metasploit `auxiliary/scanner/vnc/vnc_login` module checks passwords against that service.

## Result

![VNC authentication result](evidence/vnc-password-reported.webp)

The relevant line is:

```text
Login Successful: :password
```

## My interpretation

The VNC service in the example accepted a simple, predictable password. That is an authentication concern because remote-desktop services can give a connected user control over a GUI session.

But I would **not** write "desktop compromised" based on this screenshot. The image shows a successful password check, not a VNC viewer connected to the desktop. The next test would be an authorized graphical login and a check of the permissions granted.

I also corrected a terminology issue in the training title: **VNC isn't VPN**. VNC is a remote-display protocol; a VPN connects networks or clients through a secure tunnel.

## What I would do next

I would check service ownership, allowed source networks, authentication configuration, encryption, and whether any unexpected connections were logged. Then I'd restrict management access, replace weak passwords, and validate the result with a permitted retest.

**Bottom line:** I have evidence of an accepted weak password; I would seek session-level verification before escalating the claim to confirmed remote-desktop access.

[Practice on an isolated lab VM](../reproduce-and-capture.md)

*The screenshot excerpts are from SecurePath Exercise 3; source pages are listed in the [evidence index](evidence/README.md).*
