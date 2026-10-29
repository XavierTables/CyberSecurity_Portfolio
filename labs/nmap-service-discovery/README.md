# Nmap Service Discovery and OS Fingerprinting

**Type:** Supplemental guided-lab analysis · **Training:** Tri-C SecurePath / CySA+ preparation  
**Environment shown:** Kali Linux scanning a deliberately vulnerable Metasploitable VM  
**Source:** Supplied "Lab Exercise 5 — Nmap Security Scanner" instructional PDF

[Portfolio](../../README.md) · [All supplemental labs](../README.md) · [Evidence index](evidence/README.md)

## Summary

**Question:** How much changes when I scan a target's default TCP port set versus its full TCP port range?

**Work reviewed:** I compared the Nmap screenshots from a guided classroom lesson: a basic scan, an OS-detection scan, and an all-port scan. I concentrated on what the terminal output supports rather than labeling open ports as confirmed vulnerabilities.

**Result:** The example's default scan reported **23 open TCP ports**, while the full-range scan listed **30 open TCP ports**. Seven ports appear only in the longer scan's displayed list.

**Assessment:** The target has a broad exposed service surface within its lab network. Additional testing would be required to identify actual software, validate vulnerabilities, and determine business risk.

**Evidence provenance:** The images below are cropped from supplied instructor slides, **not** independently captured console output. The terminal images display July 15, 2025 timestamps; they are historical examples and are not presented as scans I executed in 2026.

## 1. Basic Nmap scan

The first example uses:

```bash
nmap 10.0.2.4
```

![Cropped instructor Nmap terminal showing 23 open TCP ports during a basic scan.](evidence/nmap-default-ports.webp)

*Source: Lab Exercise 5, page 22.*

The output lists common services such as FTP (21), SSH (22), Telnet (23), SMTP (25), HTTP (80), SMB-related ports (139/445), MySQL (3306), PostgreSQL (5432), and VNC (5900).

**My interpretation:** Those service names are a useful initial map, not proof of software versions, exploitable vulnerabilities, or whether every service should be reachable. For prioritization, I would ask which services are required and who is authorized to access them.

## 2. OS fingerprinting

The example then uses:

```bash
nmap -O 10.0.2.4
```

![Cropped instructor Nmap output showing Linux 2.6.x OS fingerprint and related detection results.](evidence/nmap-os-fingerprint.webp)

*Source: Lab Exercise 5, page 24.*

Nmap reports a **Linux 2.6.x** fingerprint with an OS-details range rather than a precise verified kernel version. It also identifies a VirtualBox-like network adapter. I would treat an OS fingerprint as an estimate until checked against host inventory or system-level evidence.

## 3. Full TCP-port-range scan

The next example scans the full 1–65535 TCP range while requesting OS detection:

```bash
nmap -O 10.0.2.4 -p 1-65535
```

![Cropped instructor terminal output showing 30 open ports and Linux fingerprint in a full-range scan.](evidence/nmap-full-port-range.webp)

*Source: Lab Exercise 5, page 25.*

### What changed?

| Observation | Default scan | Full-range scan |
| --- | ---: | ---: |
| Reported open TCP ports | 23 | 30 |
| Reported closed TCP ports | 977 within the default port set | 65,505 in the full range |
| Higher-numbered ports uncovered beyond the initial list | Not in the screenshot | 3632, 6697, 8787, 34748, 56105, 58029, 60438 |

The full scan shows **seven additional ports** not listed in the initial screenshot. Nmap displays service labels for some of them, including `distccd` on 3632, but a port-based service label is **not a validated service identity**. I would use targeted version detection and service-owner confirmation before describing a specific running daemon or vulnerability.

This is the part of the lab I find most useful: a quick default scan can miss services on unusual ports. That affects both asset visibility and vulnerability-scanning scope.

## 4. What I would do with these results in a SOC or vulnerability-management role

1. **Confirm scope and asset ownership.** Match the IP and host details to the approved inventory, then determine why each exposed service is running.
2. **Validate services.** Use authorized targeted version-detection methods such as `-sV`, system inventory, or configuration review rather than assuming a port number proves a product.
3. **Prioritize exposure.** Remote management, legacy protocols, database ports and unexpected listeners deserve context-dependent review. An open port alone is not a finding with proven exploitability.
4. **Correlate with security monitoring.** Repeated scans or connections against unusual services may be useful SOC leads when reviewed with source IPs, change windows and expected administrative activity.
5. **Support remediation.** Close unnecessary listeners, restrict required ones, confirm patching and secure configuration, then re-scan after approved changes.

## Limitations and next validation

The retained artifacts are **instructional PDF screenshots**, not original Nmap XML/normal output files collected from a system I controlled. I cannot verify the scan options beyond what is visible in the terminal, reproduce historical results, or attribute those terminal sessions to me.

The slide's Linux fingerprint does not identify an exact operating-system patch level. The port table does not verify authentication weaknesses, vulnerabilities, internet reachability, or successful exploitation. I have not assigned a CVSS score.

If recreating the exercise in an authorized lab, I would capture my own timestamped Nmap output, record the VM network configuration, compare `-sV` results, and connect the confirmed service inventory to one validated Nessus finding.

## Why this complements my other work

My [Nessus baseline scan](../../projects/nessus-vulnerability-assessment/README.md) is about scanner-reported vulnerability results. This guided Nmap review illustrates an earlier step: **finding which services exist before deciding what requires deeper assessment**.

## References

- [Official Nmap Reference Guide](https://nmap.org/book/man.html)
- [Nmap Port Scanning Techniques](https://nmap.org/book/man-port-scanning-techniques.html)
- [Nmap Version Detection](https://nmap.org/book/man-version-detection.html)
