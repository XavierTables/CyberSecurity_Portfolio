# Nmap Network Reconnaissance: What the Default Scan Missed

**CySA+ lab analysis** · Kali Linux · Metasploitable 2 · Nmap

[Portfolio](../../README.md) · [All labs](../README.md) · [Screenshots](evidence/README.md)

## The question

How many services could be missing from a basic scan if I never check the full TCP port range?

The Nmap examples from my SecurePath training gave me something concrete to compare: **23 open ports in the default scan versus 30 in the full-range scan**.

| Scan | Command | Result |
| --- | --- | --- |
| Default TCP scan | `nmap 10.0.2.4` | 23 open ports |
| OS fingerprinting | `nmap -O 10.0.2.4` | Linux 2.6.x estimate |
| Full TCP range | `nmap -O -p 1-65535 10.0.2.4` | 30 open ports |

## First scan: establish what's listening

![Nmap default port scan](evidence/nmap-default-ports.webp)

The default scan found common services including SSH (22), Telnet (23), SMTP (25), HTTP (80), SMB-related ports (139/445), MySQL (3306), PostgreSQL (5432), and VNC (5900).

My first question would be whether all these services are actually needed. Having a port open isn't automatically a vulnerability, but every listener is something I'd want to account for.

## OS fingerprint: don't confuse an estimate with confirmation

![Nmap OS fingerprint](evidence/nmap-os-fingerprint.webp)

Nmap's OS detection pointed to a Linux 2.6.x kernel family and a virtualized network adapter. That's useful context, but I'd check the asset inventory or the host itself before treating the OS or kernel version as verified.

## Full-port scan: seven additional listeners

![Nmap full TCP port scan](evidence/nmap-full-port-range.webp)

The full scan reported 30 open TCP ports, revealing seven that were absent from the default results:

| Additional TCP port | Label shown | What I'd check next |
| --- | --- | --- |
| 3632 | `distccd` | Confirm service and version |
| 6697 | `ircs-u` | Identify the process and intended use |
| 8787 | `msgsrvr` | Verify the application's identity |
| 34748 | `unknown` | Find the owning process |
| 56105 | `unknown` | Confirm why it's listening |
| 58029 | `unknown` | Determine whether it's temporary or persistent |
| 60438 | `unknown` | Check its purpose and network access |

Those labels are starting clues, not verified application identities. Nmap may associate a service name with a port number; I'd use targeted `-sV` checks and host information to confirm what is running.

## My assessment

**Finding:** The broader scan revealed seven additional ports. A default scan alone would have left those listeners out of this inventory.

**Why I care:** An unexpected service might offer remote access, contain outdated software, or simply be unnecessary. I can't decide which without checking its purpose, version, and who can reach it.

**Next actions:** Match the results to the asset inventory, validate unusual ports, prioritize exposed management and database services, and compare the confirmed software and configuration with vulnerability-scanner findings.

### Example handoff

> Metasploitable 2 training host — 23 open TCP ports in the default scan and 30 in the full TCP range. Seven additional listeners need service identification and ownership checks. Open ports alone do not establish vulnerabilities.

## My takeaway

**Scan coverage affects what I can conclude.** A fast first scan is useful, but it isn't a complete inventory. The next step is to confirm services and decide what actually needs remediation.

This is how I'd connect discovery to my [Nessus vulnerability assessment](../../projects/nessus-vulnerability-assessment/README.md): identify the attack surface first, then validate the findings.

[Evidence and source pages](evidence/README.md)

## References

- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [Nmap Version Detection](https://nmap.org/book/man-version-detection.html)
- [Nmap Port Scanning Techniques](https://nmap.org/book/man-port-scanning-techniques.html)
