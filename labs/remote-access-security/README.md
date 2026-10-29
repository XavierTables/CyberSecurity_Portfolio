# Remote Access Security | SSH and VNC Authentication

**Completed CySA+ guided-lab review** · Tri-C SecurePath · Kali Linux / Metasploitable 2  
[Portfolio](../../README.md) · [Lab collection](../README.md) · [Reproduce and capture your own results](../reproduce-and-capture.md)

## The question

What does a successful password check actually prove about access to a remote service?

I worked through SSH and VNC exercises during cybersecurity training, then revisited the preserved results with a defender's perspective. I wanted to distinguish a successful **credential check** from a demonstrated **remote session**.

## Outcome at a glance

| Service | Result in the exercise | What I can conclude |
| --- | --- | --- |
| SSH, TCP 22 | `ssh_login` accepts `msfadmin:msfadmin`; a shell opens and `whoami` returns `msfadmin` | The example demonstrates authenticated command-line access as the named user |
| VNC, TCP 5900 | Nmap sees VNC; `vnc_login` accepts `password` | The example demonstrates accepted weak-password authentication, **not** a confirmed graphical desktop session |

**My finding:** In a reachable management service, a known or guessable credential can be the difference between an exposed login interface and unauthorized access. The observed access level matters: SSH has a shell confirmation; VNC has a scanner success message only.

**Evidence:** These are cropped screenshots from the course's guided-lab slide examples. The analysis is my own; original independent session logs were not retained. Exact pages and image sources are in the [evidence index](evidence/README.md).

## SSH | From credentials to a session

![Metasploit SSH module reporting a successful msfadmin login in the course exercise](evidence/ssh-login-reported.webp)

*Exercise 2, p.13 — SSH login result.*

The strongest step in the SSH sequence isn't the word **Success**. It's the next check: the example opens a session and `whoami` returns `msfadmin`.

![SSH session and whoami confirmation in the guided exercise](evidence/ssh-session-whoami.webp)

*Exercise 2, p.14 — account context.*

I would describe this as **interactive SSH access with a known lab account**, not root compromise, an SSH software exploit, or privilege escalation.

[Read the command-by-command SSH analysis](ssh-analysis.md)

## VNC | Password accepted, desktop not yet verified

![VNC login scanner returning an accepted password in the training example](evidence/vnc-password-reported.webp)

*Exercise 3, p.15 — VNC password result.*

Nmap showed TCP 5900 open, and the VNC auxiliary scanner reported `Login Successful: :password`. The slide doesn't include a VNC viewer session. I would verify that separately before claiming desktop control.

The course PDF calls this a "VPN" exercise, but the actual service on port 5900 is **VNC** (remote desktop). These are different technologies.

[Read the VNC service and authentication analysis](vnc-analysis.md)

## Defensive interpretation

**What I would investigate first:** Were these management services supposed to be reachable from this source network? Are the tested accounts legitimate and still needed? Does the server record repeated failures and successful sign-ins?

**What I would recommend:** Replace default or shared credentials, remove unused accounts, restrict management access, use stronger authentication where supported, and monitor login events. For VNC, confirm the product's transport security and session authorization. After a permitted change, repeat the targeted login test to validate the fix.

**What I would not claim:** That these lab machines were exposed to the public internet, that SSH itself was broken, or that VNC desktop control occurred. The screenshots don't establish those outcomes.

## Why I included this exercise

It connects service discovery to authentication risk and teaches a useful distinction: **a tool's positive result is not always the same thing as a verified impact**. I would use that same reasoning when triaging scanner findings in a SOC or vulnerability-management workflow.

## Evidence and next step

- [SSH analysis and full module-options screenshot](ssh-analysis.md)
- [VNC analysis and Nmap service-discovery screenshot](vnc-analysis.md)
- [Source-labeled evidence index](evidence/README.md)
- [Step-by-step independent lab recreation and screenshot checklist](../reproduce-and-capture.md)

**Status:** Guided-training analysis complete. Reproducing the exercise for original, independently captured evidence is an optional upgrade—not something this report claims is already done.

## References

- [Rapid7: SSH login scanner module documentation](https://github.com/rapid7/metasploit-framework/blob/master/documentation/modules/auxiliary/scanner/ssh/ssh_login.md)
- [Rapid7: VNC login scanner source](https://github.com/rapid7/metasploit-framework/blob/master/modules/auxiliary/scanner/vnc/vnc_login.rb)
- [Nmap reference guide](https://nmap.org/book/man.html)
