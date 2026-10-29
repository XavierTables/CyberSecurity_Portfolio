# My Independent Lab Evidence Record

**Status:** Blank worksheet. No tests or findings are implied by this template.

[CySA+ lab index](README.md) · [Automatic Nmap capture](tools/capture-nmap.sh) · [Command walkthrough](reproduce-and-capture.md)

Complete this **after** running the exercises on your own isolated lab VMs. Put actual values in every field; use "not tested" when necessary. Save the original scan files and terminal screenshots.

## Scope and environment

- Capture date and time (with timezone):
- Kali VM and version:
- Metasploitable 2 VM and IP:
- Hypervisor/network mode:
- Screenshot of isolated VM network settings:
- Exact commands used:
- Original Nmap output filename(s) and SHA256 hashes:

## Nmap: my own observations

| Check | Exact result from my VM | Screenshot/log |
| --- | --- | --- |
| Default open TCP port count | | |
| Full-range open TCP port count | | |
| Additional ports not visible in default output | | |
| OS fingerprint reported | | |
| Services requiring version confirmation | | |

**My explanation of the difference:**

**What I can conclude:**

**What I cannot conclude without more data:**

## SSH: my own observations

- Authorized SSH target / port:
- Module and actual options:
- Authentication result (success/failure/error):
- Session created? Actual session ID:
- `whoami` and `id` results, if session exists:
- Screenshot/log names:
- Security implication and caveat:

## VNC: my own observations

- Authorized VNC target / port:
- Service discovery result:
- Module and actual options:
- Login result (success/failure/error):
- Viewer session independently verified?:
- Screenshot/log names:
- Security implication and caveat:

## Findings and remediation

**Most important verified finding:**

**How I would reduce the risk:**

**How I would test the fix:**

**Evidence I still need:**

## Publishing check

- [ ] Commands and results are from my own test session
- [ ] Screenshot timestamps and network configuration are consistent
- [ ] The written findings match the raw tool output
- [ ] Original outputs are retained and their source is not misidentified
- [ ] Course reference screenshots are removed from the independent evidence section
