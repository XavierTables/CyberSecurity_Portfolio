# Nmap Network Reconnaissance: Finding the Services a Default Scan Missed

**Focus:** Port discovery, OS fingerprinting, and attack-surface review  
**Environment:** Kali Linux / Metasploitable 2 · **Training:** Tri-C SecurePath (CySA+)

[Portfolio](../../README.md) · [All labs](../README.md) · [Evidence](evidence/README.md)

## The question I wanted to answer

**How much of a host's attack surface could I overlook if I stopped after a basic port scan?**

I compared three Nmap scan examples from my CySA+ training: a normal scan, OS fingerprinting, and a full TCP-port scan against the same deliberately vulnerable Metasploitable host.

The difference was worth investigating:

| Scan type | Command used in the exercise | Reported open TCP ports |
| --- | --- | ---: |
| Default scan | `nmap 10.0.2.4` | **23** |
| OS fingerprinting | `nmap -O 10.0.2.4` | OS estimate |
| Full TCP range | `nmap -O -p 1-65535 10.0.2.4` | **30** |

That is **seven additional open ports** in the full-range results.

## Step 1 — Establish a baseline

![Nmap default scan results](evidence/nmap-default-ports.webp)

The default result includes SSH (22), Telnet (23), SMTP (25), HTTP (80), SMB-related ports (139/445), MySQL (3306), PostgreSQL (5432), and VNC (5900), among others.

My first question isn't "Which exploit works?" It's **"Which of these services should be running, and who should be able to reach them?"**

A port being open means Nmap received evidence of a listening service. It does not automatically mean the service is vulnerable.

## Step 2 — Interpret the OS fingerprint carefully

![Nmap OS detection output](evidence/nmap-os-fingerprint.webp)

The scan's network-based fingerprint points toward a Linux 2.6.x kernel family and a virtualized network adapter.

I would treat the OS result as an **estimate**, not an authoritative inventory record. Fingerprinting can be less accurate when devices filter packets, hosts present unusual network stacks, or there isn't enough response data. If it mattered to a vulnerability assessment, I'd confirm the host and version through system access or asset-management records.

## Step 3 — Compare with the full TCP scan

![Nmap full-range scan output](evidence/nmap-full-port-range.webp)

The complete TCP-port-range example returned 30 open ports, exposing seven listeners that weren't in the default scan result:

| Additional port | Service label shown | My next question |
| --- | --- | --- |
| 3632 | `distccd` | Is this genuinely distccd, and is it required? |
| 6697 | `ircs-u` | Which process owns it, and who can connect? |
| 8787 | `msgsrvr` | Is the label correct, or is another application listening? |
| 34748 | `unknown` | What application is behind this port? |
| 56105 | `unknown` | Does the asset owner expect this listener? |
| 58029 | `unknown` | Is it an ephemeral or persistent service? |
| 60438 | `unknown` | Does this port need to be reachable? |

I wouldn't report these service labels as confirmed installed software. Nmap can infer labels from port assignments. **Service/version detection** and host-level confirmation would be the next step.

## What this tells me as an analyst

The main lesson isn't just that the full scan had a higher number. It's that **the scope of the scan changes what I can see and therefore what I can responsibly conclude**.

If I handed off only the default scan, I might miss services that need review. If I handed off every open port as a confirmed vulnerability, I'd overstate the evidence. The stronger handoff is a verified list of listeners, their purpose, owners, network reachability, and any follow-up findings.

## What I would investigate in a real environment

1. **Confirm scope:** Make sure the target and scan method are authorized and that the IP belongs to the expected asset.
2. **Validate listeners:** Compare Nmap's results with `-sV`, asset inventory, firewall rules, and available process data.
3. **Review the exposure:** Pay particular attention to unexpected management, file-sharing, and database access.
4. **Correlate risk:** Tie verified versions and configurations to actual findings; compare with vulnerability-scanner results.
5. **Recommend changes:** Close or restrict unneeded services, confirm legitimate services still work, and re-scan after remediation.

### Example SOC handoff

> **Asset:** Metasploitable training VM, 10.0.2.4  
> **Observation:** 23 open TCP ports in the default scan versus 30 in the full-range scan.  
> **Triage direction:** Validate the seven additional listeners and their accessibility; service identities and vulnerabilities remain unconfirmed.  
> **Recommended follow-up:** Confirm versions, network rules, and whether services are approved.

## My takeaway

Nmap is useful for **discovery**, not automatic proof of compromise. The next step is to understand what the services actually are and whether their exposure creates a real risk.

That connects to my [Nessus vulnerability assessment](../../projects/nessus-vulnerability-assessment/README.md): I would first establish which services are present, then use vulnerability evidence and configuration checks to decide what needs remediation.

### Evidence and practice

- [Cropped scan screenshots and source information](evidence/README.md)
- [Commands for recreating and recording these scans](../reproduce-and-capture.md)

*Evidence context: The scan figures are excerpts from my SecurePath course materials. The comparisons, conclusions, and proposed follow-up are my analysis; raw independent Nmap output wasn't retained.*

## References

- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [Service Version Detection](https://nmap.org/book/man-version-detection.html)
- [Port Scanning Techniques](https://nmap.org/book/man-port-scanning-techniques.html)
