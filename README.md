# Xavier Tables | Cybersecurity & IT Support Portfolio

**CompTIA Security+ (2026) · Tri-C SecurePath · Cleveland, Ohio**  
**Target roles:** SOC Analyst I and entry-level IT Support

I use training labs to practice investigating security events, checking alternative explanations, and documenting what I can actually verify. My strongest work is a Splunk investigation using Windows and VPN logs. I also bring hands-on PC building and informal troubleshooting experience.

[LinkedIn](https://www.linkedin.com/in/xaviertables/) · [GitHub profile](https://github.com/XavierTables)

## Featured investigation — Splunk

![Splunk result showing rapid VPN country transitions](projects/splunk-siem-investigation/evidence/09-vpn-rapid-country-switch-detection.png)

**[Read the investigation](projects/splunk-siem-investigation/README.md)** · [11 executed SPL queries](projects/splunk-siem-investigation/queries/investigation-queries.md) · [SOC case brief](docs/splunk-incident-brief.md)

I searched two TryHackMe training datasets containing **12,256 Windows events** and **2,000 VPN events**. Two decisions shaped the results:

- **Windows account activity:** I followed uncommon account-management events to a network logon and Sysmon process relationships. I could explain the process ancestry, but couldn't yet prove the Security and Sysmon records shared the same host and logon session. [The verification steps remain pending](docs/splunk-correlation-validation-plan.md).
- **VPN activity:** I compared each user's normal country pattern with individual outliers. Two rare-country logins produced four rapid country transitions. The pattern deserved follow-up, but IP geolocation and VPN routing offered other possible explanations.

**My conclusion:** The logs showed questions worth investigating, not confirmed compromise. The missing host, authorization, device, and MFA context mattered as much as the suspicious-looking events.

## Completed hands-on investigations

| Project | What I did | What the evidence supports |
| --- | --- | --- |
| **[Splunk: Windows and VPN investigation](projects/splunk-siem-investigation/README.md)** | Ran 11 SPL searches and recorded screenshots and queries | Investigative leads, process relationships, VPN baselines, and unresolved checks |
| **[Windows Security Log Triage](projects/windows-security-log-triage/README.md)** | Reviewed four Event Viewer records and exported a Security log | Administrator password-change evidence distinct from later SYSTEM service activity |
| **[Nessus Baseline Scan](projects/nessus-vulnerability-assessment/README.md)** | Configured and completed a guided authenticated scan of one lab host | Scanner-reported findings requiring plugin-level validation before selecting fixes |

These are exercises in **TryHackMe or uCertify training environments**, not investigations of production systems.

## IT Support & troubleshooting

My [IT Support overview](it-support/README.md) connects Windows account-event analysis with the PC building, device support, and networking practice I've done outside these three projects. I'm developing an [Active Directory file-share access ticket](practice-labs/helpdesk-ad/README.md); it remains a **practice plan**, not a resolved ticket.

## Security research

I also write short, source-backed notes to understand current threats and practice communicating their operational impact. These are **research briefs, not hands-on incidents**.

[PHP2Shell threat research](docs/php2shell-threat-analysis.md) · [Research index](research/README.md)

## Tools & background

**Documented project tools:** Splunk/SPL, Windows Event Viewer and Security logs, Sysmon, Nessus (guided).  
**Additional training:** Active Directory fundamentals, Windows/Linux, Wireshark, Nmap, TCP/IP, DNS, and DHCP.  
**Education:** CompTIA Security+ (2026); Tri-C SecurePath cybersecurity training (completed June 2026); Associate of Arts, Cuyahoga Community College (2022). I studied CySA+ material but do not hold the certification.

**In progress:** [AD support ticket](practice-labs/helpdesk-ad/README.md), [Sentinel/KQL lab](practice-labs/sentinel-kql/README.md), and [Windows host/session correlation checks](docs/splunk-correlation-validation-plan.md). I will add findings only after running those exercises.
