# Remote Access Security — SSH and VNC Authentication

**Type:** Supplemental guided-lab analysis · **Training:** Tri-C SecurePath / CySA+ preparation  
**Environment shown:** Kali Linux, Metasploitable 2, Metasploit, Nmap · **Scope:** One intentionally vulnerable lab target at a time

[Portfolio](../../README.md) · [All supplemental labs](../README.md) · [SSH detail](ssh-analysis.md) · [VNC detail](vnc-analysis.md)

## Summary

**Question:** What can a weak password or default credential let someone do when a remote-access service is reachable?

**Work reviewed:** I revisited two guided bootcamp exercises, one against SSH on TCP 22 and one against VNC on TCP 5900. I compared the login-scan output with the follow-up evidence instead of treating every scanner message as equivalent.

**Finding:** The instructional SSH example reports a successful `msfadmin:msfadmin` login and shows an interactive SSH session running `whoami` as `msfadmin`. The VNC example reports successful password authentication with `password`, but it does not show an interactive VNC desktop session.

**Assessment:** The two examples illustrate weak authentication controls on deliberately vulnerable lab services. They do **not** establish exposure on a real corporate network, public internet reachability, a flaw in SSH itself, root access, or real-world compromise.

**Evidence status:** Cropped terminal excerpts from instructional slides provided for my bootcamp. They are labeled as lesson material, **not** as original terminal screenshots I independently captured. The examples' on-screen timestamps need not match my training date.

## Side-by-side results

| Service | Reported observation | What it establishes | What remains unverified |
| --- | --- | --- | --- |
| SSH / TCP 22 | `ssh_login` returned `Success: 'msfadmin:msfadmin'` and opened shell session 1 | The sample credentials authenticated to the Metasploitable SSH service, followed by a shell | Whether a real environment would permit the same access; authorization, monitoring, and any broader privileges |
| VNC / TCP 5900 | Nmap showed VNC open; `vnc_login` reported `Login Successful: :password` | The demonstration's VNC password check accepted a weak password | Whether a graphical client session could be established, what privileges it would grant, and internet exposure |

## Evidence excerpt: SSH authentication

![Instructional terminal excerpt showing the Metasploit SSH login module reporting a successful msfadmin:msfadmin login and opening an SSH session.](evidence/ssh-login-reported.webp)

*Source: supplied **Lab Exercise 2 — Exploit SSH Server with Metasploit**, page 13. This is a cropped instructor-slide example, not an independently retained console log.*

The important follow-up is that a remote shell is visible and the `whoami` response is `msfadmin`. I would not call that root access.

![Instructional terminal excerpt showing a Metasploit SSH shell session and whoami returning msfadmin.](evidence/ssh-session-whoami.webp)

*Source: Lab Exercise 2, page 14. [See my SSH interpretation](ssh-analysis.md).*

## Evidence excerpt: VNC authentication

![Instructional Metasploit vnc_login terminal excerpt showing Login Successful password on port 5900.](evidence/vnc-password-reported.webp)

*Source: supplied **Lab Exercise 3 — How to Hack VPN Port 5900**, page 15. Despite the PDF title, the protocol tested is **VNC**, not VPN. [See my VNC interpretation](vnc-analysis.md).*

## Why this matters defensively

A listening service is not automatically a vulnerability. The concern in these two lessons is that **reachable remote-access software combined with guessable credentials** can offer an attacker a way to authenticate. SSH and VNC have different consequences:

- With SSH, a successful login can provide command-line access as the authenticated account. The shown `whoami` result is the clearest demonstration of achieved access.
- With VNC, accepted authentication could permit graphical remote access depending on the implementation and configuration, but the saved slide demonstrates only the login scanner result.

An actual report would identify the asset owner, intended users, external/internal exposure, authentication policy, relevant security controls, and whether the observed behavior was authorized.

## Recommendations I would make to an organization

1. **Remove shared or default credentials.** Use unique, strong secrets; disable unnecessary accounts. For SSH, prefer managed key-based authentication when appropriate and limit who can log in.
2. **Restrict management access.** Put SSH and VNC behind approved network access controls, VPN or a hardened gateway as appropriate. Do not infer public exposure merely because a service was reachable from a lab VM.
3. **Watch authentication activity.** Review SSH authentication logs and remote-access gateway/VNC logs for repeated failures, suspicious sources, successful logins after password guessing, and unusual sessions.
4. **Use layered safeguards.** Where supported, MFA, connection-rate limits, account protection, and session auditing reduce risk. Verify whether the particular VNC product provides encryption and appropriate authentication.
5. **Verify remediation.** Re-test only approved lab or organizational targets to confirm the default/weak credential no longer works and legitimate access still functions.

## Confidence and boundaries

I can confidently describe **what the supplied slide screenshots show**, not certify that the exact scanner output came from a session I personally recorded. These are guided educational examples and no original command history or independent SSH/VNC server logs were included. No production-severity rating is assigned.

A different level of evidence would be needed to claim an independently reproduced finding: dated original output, target configuration, authorized test scope, verification from the service side, and remediation re-test.

## Additional detail

- [SSH credential testing and shell verification](ssh-analysis.md)
- [VNC service discovery and authentication check](vnc-analysis.md)
- [Evidence index and provenance](evidence/README.md)

## References

- [Metasploit documentation](https://docs.metasploit.com/) — auxiliary scanner modules and console use
- [OpenSSH manual pages](https://www.openssh.com/manual.html) — SSH administration and configuration
- [Nmap Reference Guide](https://nmap.org/book/man.html) — discovery and service identification
