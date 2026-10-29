# Supplemental Cybersecurity Labs

[Back to portfolio](../README.md)

I completed these guided exercises during Tri-C SecurePath and wrote up what the results mean for real security work. The analyses are finished; the cropped terminal figures are **reference images from the coursework**, with page-by-page attribution in each evidence index. Original console logs from those examples were not preserved.

| Lab | My focus | Key result |
| --- | --- | --- |
| **[SSH + VNC remote-access security](remote-access-security/README.md)** | Weak credentials, login checks, access verification, hardening | SSH shell verified in the example; VNC password accepted without demonstrated desktop access |
| **[Nmap service discovery](nmap-service-discovery/README.md)** | Default vs full-range port scanning, OS fingerprint confidence, triage | Example found 23 vs 30 open TCP ports, seven additional listeners |
| **[SMTP user enumeration](smtp-enumeration/README.md)** | SMTP `VRFY`, enumeration, response-code interpretation | `252` is not proof of a valid user; `550 5.1.1` rejects an unknown local recipient |

## Reproduce the work

[**Hands-on walkthrough: Build your own evidence in Kali + Metasploitable**](reproduce-and-capture.md)

This guide provides the commands, screenshot checklist, expected types of results, and analyst questions for replacing the course reference figures with independently captured evidence.

For full investigations based on retained project evidence, see the [featured portfolio projects](../README.md#lab-projects).
