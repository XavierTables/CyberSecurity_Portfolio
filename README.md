# Xavier Tables | Cybersecurity & IT Portfolio

**CompTIA Security+ Certified | Tri-C SecurePath Graduate | Entry-Level SOC & IT Support**

I built this portfolio to show how I approach security work, not just which tools I have used. Each completed project includes the evidence I collected, how I worked through it, what I concluded, and what the lab data could not prove.

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

I reviewed four Windows Security events—**4724, 4738, 4624, and 4672**—from an authorized uCertify training VM. I connected an Administrator password reset to the matching account-change event, then separately worked through privileged SYSTEM service activity so I would not force unrelated events into one story.

**Assessment:** The SYSTEM activity was consistent with normal service behavior. The password reset was corroborated, but its authorization remained unverified.

The project includes the event screenshots I used, an evidence timeline, my reasoning, a confidence assessment, and the follow-up I would take in a real environment.

[Read the full investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md)

### Nessus Vulnerability Assessment

**Completed | Vulnerability Assessment**

I configured and completed a Basic Network Scan against one assigned uCertify host using the supplied Windows target credentials. The scan completed in **23 minutes** and displayed **Auth: Pass**.

**Assessment:** Critical and High scanner-reported results warranted finding-level review. Specific applicability, exploitability, and remediation remained unverified.

The project includes five lab screenshots, a workflow diagram, my interpretation of the severity and grouped results, the response steps I would take next, and file-integrity checksums.

[Read the full assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md)

### Splunk SIEM Investigation

**Completed | Security Operations / SIEM**

I used Splunk and SPL in an authorized TryHackMe environment to investigate Windows Security, Sysmon, and VPN telemetry. I followed Logon ID `0x551686` from a network authentication into related account-management activity, checked the process relationships in Sysmon, and built reusable searches for unusual VPN geography.

**Assessment:** The Windows activity was suspicious administrative behavior with authorization unverified. The VPN analysis identified geographically inconsistent authentication patterns that required identity validation, but the available telemetry did not confirm compromise.

The project includes nine evidence screenshots, the 11-query SPL trail I used, my findings and limitations, and the follow-up I would take in a production SOC.

[Read the full SIEM investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md)

## Planned Projects

| Project | Focus |
|---|---|
| Network Traffic Analysis | Wireshark investigation and evidence-based network analysis |
| Malware Analysis | Safe sandbox observations, indicators, behavior, and defensive relevance |
| Web App Security | Authorized vulnerability discovery, validation, risk explanation, and remediation guidance |

I keep future projects labeled as planned until I have actually completed the lab work and have evidence to support what I publish.

## Technical Foundation

| Area | Training and tools |
|---|---|
| Security Operations | Windows Security logs, Event Viewer, Splunk, SPL, Sysmon, log analysis, session correlation, behavioral baselining, incident-response fundamentals |
| Vulnerability Assessment | Tenable Nessus, CVSS interpretation, validation and remediation planning |
| Networking | TCP/IP, Wireshark, Nmap, network traffic analysis |
| Systems | Windows, Linux, Kali Linux, macOS, Active Directory fundamentals |
| Documentation | Evidence collection, investigation timelines, technical reports, escalation recommendations |

These tools come from coursework and hands-on lab practice. The completed projects show where I actually used them instead of treating the skills list as proof by itself.

## Certifications and Education

- **CompTIA Security+:** certified.
- **Tri-C SecurePath Cybersecurity Boot Camp:** completed 14 weeks of training at Cuyahoga Community College in 2026.
- **Associate of Arts:** Cuyahoga Community College.
- **Additional training:** CompTIA CySA+ coursework and hands-on labs.

## Lab Disclosure

The completed projects use authorized training environments such as uCertify and TryHackMe. Those platforms supplied the systems, scenarios, or datasets; the portfolio shows the evidence I worked with, the searches and analysis I performed, and how I reached each conclusion.

I keep the lab boundaries clear, separate what I observed from what I would do next in production, and do not publish course answers or credentials.

**GitHub profile:** [XavierTables](https://github.com/XavierTables)
