# Remote Access Security Assessment: SSH and VNC

**Focus:** Weak credentials, remote authentication, and access verification  
**Environment:** Kali Linux / Metasploitable 2 · **Training:** Tri-C SecurePath (CySA+)

[Portfolio](../../README.md) · [SSH investigation](ssh-analysis.md) · [VNC investigation](vnc-analysis.md) · [Evidence](evidence/README.md)

## Overview

I wanted to understand the difference between **finding a remote service**, **getting a valid login**, and **proving access**. SSH and VNC make a useful comparison because both can provide remote control, but the evidence of successful access looks different.

The two lab exercises demonstrate a successful SSH login with a known weak credential and an accepted VNC password. My focus here is what those results mean, what they *don't* prove, and what I would do if I found the same behavior on a company network.

| Service | Observed result | My assessment |
| --- | --- | --- |
| SSH / TCP 22 | Metasploit reported `msfadmin:msfadmin`, opened a shell, and `whoami` returned `msfadmin` | Authentication **and a command-line session** were demonstrated |
| VNC / TCP 5900 | Nmap detected VNC and the login scanner accepted `password` | Weak authentication was demonstrated; a **graphical session wasn't shown** |

## 1. SSH: a login is only the first check

The exercise used Metasploit's `auxiliary/scanner/ssh/ssh_login` module against the intentionally vulnerable target. The result showed a successful credential match.

![SSH login result](evidence/ssh-login-reported.webp)

The important part for me is the follow-up, not just the success message. The example goes into session 1 and runs `whoami`:

![SSH session and account check](evidence/ssh-session-whoami.webp)

The response is `msfadmin`. That supports a specific conclusion: the credentials provided **remote shell access as that account**. It does **not** show root privileges, privilege escalation, or a vulnerability in the SSH protocol.

[SSH investigation: commands, evidence, and next checks](ssh-analysis.md)

## 2. VNC: password accepted, access still needs confirmation

The second exercise identified VNC on TCP port 5900, then used `auxiliary/scanner/vnc/vnc_login` to check authentication.

![VNC scanner result](evidence/vnc-password-reported.webp)

The module reported `Login Successful: :password`. That's a meaningful authentication finding because the password is easy to guess. But unlike the SSH example, the retained result doesn't include a connected VNC viewer. I wouldn't report confirmed desktop control without that extra check.

[Read the VNC investigation](vnc-analysis.md)

## What stands out to me

**The same "success" label doesn't always mean the same thing.** With SSH, I can point to an authenticated shell and the user account it ran under. With VNC, I can point to a successful password test, but not to a verified desktop session.

I also wouldn't claim that either service was reachable from the internet. The evidence shows reachability **inside the lab network**. Exposure from an unauthorized network would require a separate test.

## What I would recommend at work

If I found these results on an actual asset, I would start with three questions:

1. **Is access expected?** Confirm the asset owner, intended administrators, and permitted source networks.
2. **How was the login allowed?** Look for default/shared passwords, password-only SSH access, VNC authentication settings, and missing access restrictions.
3. **Is there evidence of misuse?** Review SSH authentication logs, VNC or gateway logs, source addresses, failed attempts, successful sessions, and related changes.

My recommended fixes would be to remove default credentials, use strong unique authentication, limit SSH/VNC to approved management paths, and monitor access. I would then test—within authorized scope—that weak credentials no longer work.

## Final assessment

**Issue illustrated:** Remote-management access can be exposed by weak or default credentials.

**SSH outcome:** Authenticated command-line session established in the example.

**VNC outcome:** Authentication accepted; interactive graphical access unconfirmed.

**Security priority:** On a production asset, weak credentials on reachable management interfaces would warrant prompt investigation. I would determine severity from actual reachability, privileges, controls, and impact—not assume a rating from a classroom VM.

### Supporting material

- [SSH evidence analysis](ssh-analysis.md)
- [VNC evidence analysis](vnc-analysis.md)
- [Evidence index and slide sources](evidence/README.md)
- [Practice and independent evidence-capture commands](../reproduce-and-capture.md)
- [Capture your own SSH/VNC results with a known-target lab setup](../tools/capture-nmap.sh)
- [Record your actual results and limitations](../independent-evidence-record.md)

*Evidence context: The figures are cropped terminal excerpts from the SecurePath lab materials I studied. I wrote this technical interpretation and the follow-up recommendations; the original terminal recordings weren't retained.*

## References

- [Metasploit documentation](https://docs.metasploit.com/)
- [OpenSSH manuals](https://www.openssh.com/manual.html)
- [Nmap reference guide](https://nmap.org/book/man.html)
