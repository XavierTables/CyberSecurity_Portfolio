# VNC Authentication: Weak Password on Port 5900

[Remote-access report](README.md) · [SSH comparison](ssh-analysis.md) · [Evidence index](evidence/README.md)

## What I examined

This exercise starts by identifying VNC on the lab target using service detection:

```bash
nmap -sV -p 5900 192.168.1.106
```

![Nmap identifying VNC on TCP 5900](evidence/vnc-nmap-port5900.webp)

Nmap reported `5900/tcp open vnc` with VNC protocol 3.3. This establishes reachability from the lab scanner, not public internet exposure.

## Password check

The Metasploit `auxiliary/scanner/vnc/vnc_login` module then checked authentication. The key output was:

```text
Login Successful: :password
```

![VNC scanner reporting accepted password](evidence/vnc-password-reported.webp)

## My conclusion

The lab's VNC service accepted a weak password. That's worth investigating because remote-desktop services can provide control of another system.

What I can confirm from this output is **successful authentication**. A viewer actually connecting and controlling the desktop would require its own session evidence. This is also **VNC**, not VPN; port 5900 is associated with the remote-display service tested here.

## What I'd investigate at work

I'd verify which systems could reach the VNC listener, identify its owner and product, review authentication and encryption settings, and look for unexpected connections. I'd recommend strong unique credentials, approved access restrictions, and a follow-up test showing weak passwords are rejected.

**My takeaway:** Don't confuse an accepted password with a demonstrated remote desktop session.

[Practice the commands and capture your own output](../reproduce-and-capture.md) · [Screenshot source pages](evidence/README.md)
