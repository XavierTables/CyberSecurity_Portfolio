# Xavier Tables | Cybersecurity & IT Portfolio

**CompTIA Security+ Certified | Tri-C SecurePath Graduate | Entry-Level SOC & IT Support**

I built this portfolio to show how I approach security work, not just which tools I have used. Each completed project includes the evidence I collected, how I worked through it, what I concluded, and what the lab data could not prove.

**Location:** Cleveland, Ohio  
**Career focus:** SOC Analyst I · IT Support · Help Desk · Desktop Support · NOC Technician

**LinkedIn:** [Xavier Tables](https://www.linkedin.com/in/xaviertables/)

**Jump to:** [Featured case](#featured-soc-investigation--splunk-siem-triage) · [Projects](#completed-projects) · [Skills](#technical-foundation) · [Credentials](#certifications-and-education)

## Featured SOC Investigation — Splunk SIEM Triage

**[Read the one-page SOC case brief](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/docs/splunk-incident-brief.md)** · **[Review the validation plan](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/docs/splunk-correlation-validation-plan.md)**

**[Read the full Splunk investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md)** · **[View the SPL investigation query log](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/queries/investigation-queries.md)**

I investigated Windows authentication and account activity and isolated **two rare-country VPN events**, with **four rapid country-label transitions** around them.

- **Windows evidence:** Account-management records and Sysmon process relationships provided leads for authorization review. Cross-source host/session linkage remains unverified.
- **VPN evidence:** `jsmith` had 199 US-labelled events and one Japan-labelled event; `kbrown` had 199 Germany-labelled events and one Australia-labelled event. Transition gaps were 15–57 minutes.
- **Final disposition:** Suspicious activity; **compromise unconfirmed**. Documented administrative-approval checks and VPN identity, device, MFA, and routing validation.

**Scope and evidence:** Authorized TryHackMe lab; 12,256 Windows events and 2,000 VPN events in the supplied datasets, nine screenshots, and an 11-query SPL investigation trail.

## Completed Projects

| Project | Outcome | Skills demonstrated |
|---|---|---|
| [Splunk SIEM Investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/splunk-siem-investigation/README.md) | Two rare-country VPN events; four transitions; compromise unconfirmed | SPL, Windows/Sysmon analysis, behavioral baselining, and validation planning |
| [Windows Security Log Triage](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md) | SYSTEM service activity consistent with normal behavior; reset approval unverified | Event correlation, account context, evidence-based disposition, and escalation planning |
| [Nessus Guided Vulnerability Assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md) | Guided baseline complete; finding validation and remediation open | Scan configuration, authentication evidence, aggregate-result interpretation, and proposed follow-up |

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

## Professional Readiness Materials (Practice, Not Completed Work)

The completed investigations above are evidence of performed lab work. The resources below are **training plans and interview preparation**, not evidence of executed Microsoft Sentinel or AD support cases:

- **[Microsoft Sentinel / KQL lab workbook](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/practice-labs/sentinel-kql/README.md)** — proposed queries, evidence requirements, and a simulated incident-ticket template. **Not yet executed.**
- **[Active Directory help desk lab workbook](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/practice-labs/helpdesk-ad/README.md)** — planned account/access troubleshooting and ticket closeout. **Not yet executed.**
- **[SOC Analyst I interview drill](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/docs/soc-interview-drill.md)** — technical questions tied to existing evidence and limitations.
- **[Splunk host/session revalidation plan](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/docs/splunk-correlation-validation-plan.md)** — proposed queries to test the unresolved cross-source correlation. **Not yet executed.**

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
