# Xavier Tables | SOC Analyst Portfolio

**CompTIA Security+ (2026) · Tri-C SecurePath · Cleveland, Ohio**

I'm pursuing a SOC Analyst I role. These labs show how I investigate Windows and VPN activity, check alternative explanations, and document the evidence behind my conclusions.

**[Start with the case brief](docs/splunk-incident-brief.md)** · [SOC résumé](resume/Xavier_Tables_SOC_Resume.pdf) · [LinkedIn](https://www.linkedin.com/in/xaviertables/) · [IT Support](it-support/README.md)

## Featured case: Windows and VPN activity in Splunk

I ran **11 SPL searches** across **12,256 Windows events** and **2,000 VPN events** in supplied TryHackMe datasets. I followed account changes and process relationships in Windows, then compared VPN country changes with each user's baseline.

The VPN searches found **two rare-country events and four rapid transitions**. The Windows results gave me a process-ancestry lead, with host/session validation still open. My [case brief](docs/splunk-incident-brief.md) explains the findings and recommended follow-up.

**[Full investigation](projects/splunk-siem-investigation/README.md)** · [Executed SPL queries](projects/splunk-siem-investigation/queries/investigation-queries.md) · [Sample handoff](docs/splunk-retrospective-triage-ticket.md) · [Evidence index](projects/splunk-siem-investigation/README.md#evidence)

<a href="projects/splunk-siem-investigation/evidence/09-vpn-rapid-country-switch-detection.png"><img src="projects/splunk-siem-investigation/evidence/09-vpn-rapid-country-switch-detection.png" width="640" alt="Splunk query results: four country transitions around two rare-country VPN events"></a>

*VPN result preview. Open the image for the original screenshot.*

## Lab projects

| Project | Work demonstrated | Recorded outcome |
| --- | --- | --- |
| **[Splunk investigation](projects/splunk-siem-investigation/README.md)** | SPL searches, account-event review, Sysmon ancestry, VPN baselining | Two separate leads documented for follow-up |
| **[Windows Security Log Triage](projects/windows-security-log-triage/README.md)** | Compared four Event Viewer records and their account/process context | Distinguished an Administrator password change from later SYSTEM service activity |
| **[Nessus Baseline Scan](projects/nessus-vulnerability-assessment/README.md)** | Configured and completed a guided authenticated scan of one lab host | Recorded scanner severity totals; individual finding validation is the next step |

Each report links to its screenshots and explains the scope of the training exercise.

## Tools and background

**Documented in these projects:** Splunk/SPL, Windows Event Viewer, Security logs, Sysmon, and Nessus.
**Additional training:** Windows/Linux, Active Directory fundamentals, Wireshark, Nmap, TCP/IP, DNS, and DHCP.

**Education:** CompTIA Security+ (2026); Tri-C SecurePath cybersecurity training, completed June 2026; Associate of Arts, Cuyahoga Community College (2022).

## More work

[IT Support and troubleshooting](it-support/README.md) · [Security research](research/README.md) · [Project roadmap](docs/project-roadmap.md)

The roadmap tracks pending Splunk validation and planned AD/Sentinel exercises.
