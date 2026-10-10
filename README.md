# Xavier Tables | Security Operations Portfolio

**CompTIA Security+ | Tri-C SecurePath graduate | Cleveland, Ohio**

I'm working toward my first SOC Analyst I or IT support role. This repository contains three completed security labs. Each report links to the searches or screenshots I used, what I found, and what I couldn't confirm.

[LinkedIn](https://www.linkedin.com/in/xaviertables/) · [GitHub profile](https://github.com/XavierTables)

## Featured investigation: Splunk SIEM

**[Full investigation](projects/splunk-siem-investigation/README.md)** · **[SPL query log](projects/splunk-siem-investigation/queries/investigation-queries.md)** · **[Short case brief](docs/splunk-incident-brief.md)**

I used Splunk to work through two sets of training logs: **12,256 Windows events** and **2,000 VPN events**.

- **Windows:** Followed a network logon into account-management activity and compared Security events with Sysmon process relationships. The searches were not consistently scoped to one host and time window, so the cross-source session link needs further validation.
- **VPN:** Found two accounts with one unusual country-labelled event each. An SPL search showed four rapid country changes around those two events, with gaps of 15–57 minutes. I documented other possible explanations, including routing and IP geolocation.
- **Result:** Both patterns deserved follow-up. The available evidence did **not** confirm compromise.

The full report includes **11 SPL searches**, nine screenshots, and the reasoning behind the findings.

## Completed projects

| Project | What I did |
|---|---|
| **[Splunk SIEM investigation](projects/splunk-siem-investigation/README.md)** | Investigated Windows authentication and VPN activity using SPL, Windows Security logs, and Sysmon. |
| **[Windows Security log triage](projects/windows-security-log-triage/README.md)** | Reviewed an Administrator password reset and separate SYSTEM service activity using Events 4724, 4738, 4624, and 4672. The reset's authorization was not available in the lab. |
| **[Nessus vulnerability assessment](projects/nessus-vulnerability-assessment/README.md)** | Ran a guided, credentialed baseline scan of one lab host and reviewed the reported severity counts. Individual findings and remediation weren't verified. |

## Technical background

**Used in the published labs:** Splunk, SPL, Windows Event Viewer and Security logs, Sysmon, Nessus, account/session investigation, process analysis, and VPN baselining.

**Additional coursework and training:** Active Directory fundamentals, networking (TCP/IP, DNS, DHCP), Wireshark, Nmap, Windows, and Linux.

**Education and certification:** CompTIA Security+ (2026); Tri-C SecurePath cybersecurity boot camp (14 weeks, completed June 2026); Associate of Arts, Cuyahoga Community College (2022). Additional CySA+ coursework.

## About the lab work

These projects used authorized TryHackMe and uCertify environments. The reports distinguish what I actually observed from follow-up steps that would need other data, tools, or approvals. They're training investigations, not production incidents.

For the Splunk case, I also wrote a [retrospective example triage ticket](docs/splunk-retrospective-triage-ticket.md) and a [host/session revalidation plan](docs/splunk-correlation-validation-plan.md). The ticket wasn't handled in a live SOC, and the proposed revalidation tests haven't been run.
