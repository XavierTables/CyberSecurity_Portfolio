# Xavier Tables | Cybersecurity & IT Portfolio

**CompTIA Security+ Certified | Tri-C SecurePath Graduate | Entry-Level SOC & IT Support**

I built this portfolio to show how I approach security work, not just which tools I have used. Each completed project includes the evidence I collected, how I worked through it, what I concluded, and what the lab data could not prove.

**Location:** Cleveland, Ohio  
**Career focus:** SOC Analyst I · IT Support · Help Desk · Desktop Support · NOC Technician

**LinkedIn:** [Xavier Tables](https://www.linkedin.com/in/xaviertables/)

**Jump to:** [Featured case](#featured-soc-investigation--splunk-siem-triage) · [Projects](#completed-projects) · [Skills](#technical-foundation) · [Credentials](#certifications-and-education)

## Featured SOC Investigation — Splunk SIEM Triage

**[Read the full Splunk investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md)** · **[View the SPL investigation query log](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/queries/investigation-queries.md)**

In an authorized TryHackMe environment, I analyzed **12,256 Windows events** and **2,000 VPN authentication events** using Splunk and SPL. The investigation followed two leads:

- **Windows authentication and account activity:** Pivoted from a network logon and Logon ID to account-management events, then examined supporting Windows Security and Sysmon process relationships. Host/session-boundary verification remains necessary before treating the correlation as a production finding.
- **VPN geographic anomaly:** Baselined account behavior and identified a user with **199 US-labelled events and one Japan-labelled event**, with US-labelled activity 25 minutes before and 15 minutes after the outlier. Flagged the sequence for identity/device and routing validation rather than declaring account compromise.

**Evidence:** Nine screenshots and an 11-query SPL investigation trail, with findings, limitations, and recommended follow-up.

**Outcome:** Suspicious activity identified; **compromise not confirmed** by the available training telemetry.

## Completed Projects

| Project | Skills demonstrated |
|---|---|
| [Splunk SIEM Investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md) | SPL investigation, session correlation, Security/Sysmon process analysis, behavioral baselining, and VPN anomaly detection |
| [Windows Security Log Triage](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md) | Event correlation, account and process context, evidence-based disposition, and escalation planning |
| [Nessus Vulnerability Assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md) | Scan configuration, target authentication, aggregate-result interpretation, and proposed validation/remediation workflow |

## Other Completed Investigation Summaries

### Windows Security Log Triage

**Completed | Security Operations**

I reviewed Windows Security events **4724, 4738, 4624, and 4672** in a uCertify training VM. I separated the Administrator password reset from later SYSTEM service activity.

**Assessment:** The SYSTEM activity was consistent with normal service behavior. The password reset was corroborated, but its authorization remained unverified.

**Evidence:** Event screenshots, a timeline, analysis, and recommended follow-up.

[Read the full investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md)

### Nessus Vulnerability Assessment

**Completed baseline | Guided Vulnerability Assessment**

I configured and completed a Basic Network Scan against one assigned uCertify host using the supplied Windows target credentials. The scan completed in **23 minutes** and displayed **Auth: Pass**.

**Assessment:** Critical and High scanner-reported results warranted finding-level review. Specific applicability, exploitability, and remediation remained unverified.

**Evidence:** Five screenshots, a workflow diagram, result interpretation, and file-integrity checksums.

[Read the full assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md)

## Technical Foundation

| Area | Training and tools |
|---|---|
| Security Operations | Windows Security logs, Event Viewer, Splunk, SPL, Sysmon, log analysis, session correlation, behavioral baselining, incident-response fundamentals |
| Vulnerability Assessment | Tenable Nessus, CVSS interpretation, validation and remediation planning |
| Networking | TCP/IP, Wireshark, Nmap, network traffic analysis |
| Systems | Windows, Linux, Kali Linux, macOS, Active Directory fundamentals |
| Documentation | Evidence collection, investigation timelines, technical reports, escalation recommendations |

These skills reflect coursework and hands-on lab practice. Each project report identifies the tools I used in that investigation.

## Certifications and Education

- **CompTIA Security+:** certified.
- **Tri-C SecurePath Cybersecurity Boot Camp:** completed 14 weeks of training at Cuyahoga Community College in 2026.
- **Associate of Arts:** Cuyahoga Community College.
- **Additional training:** CompTIA CySA+ coursework and hands-on labs.

## Planned Projects

| Project | Focus |
|---|---|
| Network Traffic Analysis | Wireshark investigation and evidence-based network analysis |
| Malware Analysis | Safe sandbox observations, indicators, behavior, and defensive relevance |
| Web App Security | Authorized vulnerability discovery, validation, risk explanation, and remediation guidance |

## Lab Disclosure

The completed projects use authorized training environments such as uCertify and TryHackMe. Those platforms supplied the systems, scenarios, or datasets; the portfolio shows the evidence I worked with, the searches and analysis I performed, and how I reached each conclusion.

I keep the lab boundaries clear, separate what I observed from what I would do next in production, and do not publish course answers or credentials.

**GitHub profile:** [XavierTables](https://github.com/XavierTables)
