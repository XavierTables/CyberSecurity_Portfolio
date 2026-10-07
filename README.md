# Xavier Tables | Cybersecurity & IT Portfolio

**CompTIA Security+ Certified | Tri-C SecurePath Graduate | Entry-Level SOC & IT Support**

I document authorized lab work in Windows Security log analysis, SIEM investigation, and vulnerability assessment, including the evidence, reasoning, and limits of each conclusion.

**Location:** Cleveland, Ohio  
**Career focus:** SOC Analyst I · IT Support · Help Desk · Desktop Support · NOC Technician

## Completed Projects

| Project | Skills demonstrated |
|---|---|
| [Windows Security Log Triage](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md) | Event correlation, account and process context, evidence-based disposition, and escalation planning |
| [Nessus Vulnerability Assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md) | Scan configuration, target authentication, result interpretation, and remediation planning |
| [Splunk SIEM Investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md) | SPL investigation, session correlation, Security/Sysmon process analysis, behavioral baselining, and VPN anomaly detection |

## Project Summaries

### Windows Security Log Triage

**Completed | Security Operations**

Reviewed four Windows Security events—**4724, 4738, 4624, and 4672**—from an authorized uCertify training VM. I correlated an Administrator password reset with an account-change event and separately examined privileged SYSTEM service activity.

**Assessment:** The SYSTEM activity was consistent with normal service behavior. The password reset was corroborated, but its authorization remained unverified.

The report includes event screenshots, an evidence timeline, analysis, a confidence assessment, and recommended investigative follow-up.

[Read the full investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md)

### Nessus Vulnerability Assessment

**Completed | Vulnerability Assessment**

Configured and completed a Basic Network Scan against one assigned uCertify host using the supplied Windows target credentials. The scan completed in **23 minutes** and displayed **Auth: Pass**.

**Assessment:** Critical and High scanner-reported results warranted finding-level review. Specific applicability, exploitability, and remediation remained unverified.

The report includes five lab screenshots, a workflow diagram, interpretation of severity and grouped results, proposed response steps, and file-integrity checksums.

[Read the full assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md)

### Splunk SIEM Investigation

**Completed | Security Operations / SIEM**

Used Splunk and SPL in an authorized TryHackMe environment to investigate Windows Security, Sysmon, and VPN telemetry. I correlated a network-authenticated Windows session through Logon ID `0x551686`, reconstructed account-management activity, corroborated process ancestry across Security and Sysmon data, and built reusable VPN geographic-anomaly searches.

**Assessment:** The Windows activity was suspicious administrative behavior with authorization unverified. The VPN analysis identified geographically inconsistent authentication patterns that required identity validation, but the available telemetry did not confirm compromise.

The report includes nine evidence screenshots, an 11-query SPL investigation log, findings, limitations, and production SOC follow-up.

[Read the full SIEM investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md)

## Planned Projects

| Project | Focus |
|---|---|
| Network Traffic Analysis | Wireshark investigation and evidence-based network analysis |
| Malware Analysis | Safe sandbox observations, indicators, behavior, and defensive relevance |
| Web App Security | Authorized vulnerability discovery, validation, risk explanation, and remediation guidance |

Planned projects remain listed as planned until the supporting lab evidence and analysis are completed.

## Technical Foundation

| Area | Training and tools |
|---|---|
| Security Operations | Windows Security logs, Event Viewer, Splunk, SPL, Sysmon, log analysis, session correlation, behavioral baselining, incident-response fundamentals |
| Vulnerability Assessment | Tenable Nessus, CVSS interpretation, validation and remediation planning |
| Networking | TCP/IP, Wireshark, Nmap, network traffic analysis |
| Systems | Windows, Linux, Kali Linux, macOS, Active Directory fundamentals |
| Documentation | Evidence collection, investigation timelines, technical reports, escalation recommendations |

These tools reflect coursework and lab practice. Each project identifies the tools and techniques used in the completed work.

## Certifications and Education

- **CompTIA Security+:** certified.
- **Tri-C SecurePath Cybersecurity Boot Camp:** completed 14 weeks of training at Cuyahoga Community College in 2026.
- **Associate of Arts:** Cuyahoga Community College.
- **Additional training:** CompTIA CySA+ coursework and hands-on labs.

## Lab Disclosure

The completed projects use guided, authorized training environments, including uCertify and TryHackMe. Lab providers supplied systems, scenarios, or datasets; the reports document my lab evidence, searches, analysis, and understanding.

Each report separates observations from proposed follow-up and states the limitations of the available evidence. Proprietary course instructions, credentials, and assessment answers are not reproduced.

**GitHub profile:** [XavierTables](https://github.com/XavierTables)
