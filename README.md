# Xavier Tables | Cybersecurity & IT Portfolio

**CompTIA Security+ Certified | Tri-C SecurePath Graduate | Entry-Level SOC & IT Support**

Welcome to my cybersecurity portfolio. I'm an aspiring cybersecurity professional building practical experience in security operations, log analysis, incident response, vulnerability management, and IT troubleshooting.

I hold the CompTIA Security+ certification, completed Cuyahoga Community College's 14-week SecurePath cybersecurity bootcamp, and earned an Associate of Arts degree.

This repository documents my hands-on technical training, investigation methodology, supporting evidence, and continued development as I pursue my first professional IT or cybersecurity role.

**Career Focus:** SOC Analyst I · IT Support · Help Desk · Desktop Support · NOC Technician

## Portfolio Snapshot

| Completed project | Evidence demonstrated | Hiring signal |
|---|---|---|
| [Windows Security Log Triage](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md) | Windows Security events, account/process context, event correlation, documented disposition | SOC investigation and evidence-based reasoning |
| [Nessus Vulnerability Assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md) | Authenticated scan workflow, result interpretation, severity context, remediation planning | Vulnerability assessment and disciplined reporting |

**Current demonstrated strengths:** security-log analysis, vulnerability-assessment workflow, evidence handling, technical reporting, and clearly documented limitations.

**Next breadth targets:** SIEM alert investigation and network traffic analysis.

---

## Featured Projects

### Windows Security Log Triage: Privileged Account and Service Activity

**Status: Completed | Category: Security Operations**

[View Full Investigation](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/windows-security-log-triage/README.md)

Investigated Windows Security events from an authorized uCertify training environment to determine whether privileged-account changes and subsequent service activity indicated unauthorized access.

The Security log contained 6,530 events. I manually analyzed four security-relevant records and organized the evidence into two activity clusters.

| Event ID | Investigation Focus |
|---|---|
| 4724 | Administrator password-reset activity |
| 4738 | Administrator account changes |
| 4624 | Successful SYSTEM service logon |
| 4672 | Special privileges assigned to the SYSTEM session |

**Skills demonstrated:**
- Windows Event Viewer and Security log analysis
- Authentication and account-management event interpretation
- Event correlation using timestamps, accounts, and Logon IDs
- Distinguishing service activity from interactive or remote logons
- Evidence-based triage, investigation documentation, and escalation planning

**Key finding:** The reviewed service activity was consistent with normal Windows behavior. The Administrator password reset was corroborated by an account-change event, but its authorization could not be verified from the available training evidence.

The investigation includes event screenshots, an evidence timeline, documented findings, confidence assessment, limitations, and recommended production follow-up.

---

### Nessus Vulnerability Assessment: Authenticated Baseline & Result Triage

**Status: Completed | Category: Vulnerability Assessment**

[View Full Assessment](https://github.com/XavierTables/CyberSecurity_Portfolio/blob/main/projects/nessus-vulnerability-assessment/README.md)

Configured and executed a Basic Network Scan against the assigned host in an authorized uCertify lab. The assessment completed against one host in 23 minutes and displayed Auth: Pass.

The report explains the host severity distribution, the meaning of grouped and MIXED results, and the limits of aggregate scanner evidence. It includes five lab screenshots, an assessment workflow diagram, a final assessment, proposed remediation and verification steps, and file-integrity checksums.

**Skills demonstrated:** Nessus configuration, target authentication, result interpretation, remediation planning, and evidence-based reporting.

**Key finding:** Critical and High scanner-reported results warranted detailed applicability review. Specific exploitability and remediation were not established by the available lab evidence.

---

## Upcoming Projects

| Project | Focus | Status |
|---|---|---|
| SIEM Alert Investigation | Detection and Alert Triage | Planned |
| Network Traffic Analysis | Wireshark / Network Security | Planned |

The completed projects are summarized at the top of this portfolio and documented in full below. Upcoming projects will add SIEM and network-analysis evidence without duplicating the completed-project list.

---

## Technical Skills & Tools

| Area | Technologies & Skills |
|---|---|
| Security Operations | Windows Security Logs, Event Viewer, log analysis, alert triage fundamentals |
| Network Security | TCP/IP, Wireshark, Nmap, network traffic analysis |
| Vulnerability Assessment | Tenable Nessus, vulnerability identification and remediation prioritization |
| Systems & Administration | Windows, Linux, macOS, Active Directory fundamentals |
| Security Tools | Kali Linux, Nmap, Wireshark, Nessus |
| Investigation & Documentation | Evidence collection, event correlation, technical reporting, incident response fundamentals |

My portfolio documents the specific tools and techniques used in each investigation. Additional technical experience is developed through coursework, labs, and independent practice.

---

## Certifications & Education

**CompTIA Security+**  
Certified

**Tri-C SecurePath Cybersecurity Bootcamp**  
Cuyahoga Community College | 2026  
Completed 14 weeks of cybersecurity training covering security fundamentals and hands-on technical practice.

**Associate of Arts**  
Cuyahoga Community College (Tri-C)

---

## Professional Development

My current focus is strengthening practical skills relevant to entry-level security operations and IT support, including:

- Windows and Linux troubleshooting
- Security log investigation and event correlation
- SIEM alert analysis and detection fundamentals
- Network traffic investigation
- Vulnerability assessment and remediation
- Technical communication and incident documentation

I use this portfolio to demonstrate what I have performed, explain the reasoning behind my findings, and document the limitations of the available evidence.

---

## Connect

**GitHub:** [XavierTables](https://github.com/XavierTables)

**Location:** Cleveland, Ohio

**Career Interests:** Entry-level cybersecurity, SOC operations, IT support, desktop support, and network operations.

---

*All security testing and investigation activities are performed in authorized lab or training environments.*
