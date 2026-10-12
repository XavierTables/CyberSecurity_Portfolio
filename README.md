# Xavier Tables | Cybersecurity Portfolio

**Security+ certified | Seeking SOC Analyst I or IT Support | Cleveland, Ohio**

These three training projects document the searches I ran, the evidence I reviewed, and my conclusions. They cover Splunk investigations, Windows Security logs, and a guided Nessus scan.

[LinkedIn](https://www.linkedin.com/in/xaviertables/) · [GitHub profile](https://github.com/XavierTables)

## Featured project: Splunk investigation

**[Case brief](docs/splunk-incident-brief.md)** · **[Full report](projects/splunk-siem-investigation/README.md)** · **[11 executed SPL queries](projects/splunk-siem-investigation/queries/investigation-queries.md)**

I worked with supplied TryHackMe datasets containing **12,256 Windows events** and **2,000 VPN events**.

- **Windows:** Examined a network logon, account-management events, and Sysmon process relationships. The searches produced investigative leads; the host/session connection still needs validation.
- **VPN:** Found two rare-country logins and four rapid country changes around them. Routing and IP geolocation remained possible explanations.
- **Conclusion:** Follow-up was warranted. The available logs did not establish account compromise.

## Completed lab projects

| Project | Work completed |
|---|---|
| [Splunk investigation](projects/splunk-siem-investigation/README.md) | Windows account-activity review and VPN baselining using SPL, with queries and screenshots. |
| [Windows Security log triage](projects/windows-security-log-triage/README.md) | Reviewed four events involving an Administrator password reset and separate SYSTEM service activity. |
| [Nessus vulnerability assessment](projects/nessus-vulnerability-assessment/README.md) | Ran a guided scan of one assigned host and interpreted the severity summary and grouped results. |

## IT support and troubleshooting

I'm also pursuing Tier 1 Help Desk, Service Desk, and PC Deployment opportunities. My Tri-C SecurePath training included Windows and Active Directory lab work (users, groups, permissions, and password resets) plus TCP/IP, DNS, DHCP, and connectivity fundamentals. I bring customer communication and time-sensitive issue resolution experience from Foot Locker and DoorDash.

**Windows troubleshooting:** In my [Windows Security log triage](projects/windows-security-log-triage/README.md), I distinguished routine SYSTEM service activity from a separate Administrator account change and documented the need to verify authorization. My next planned exercise is [troubleshooting Active Directory file-share access](practice-labs/helpdesk-ad/README.md).

## Tools and training

**Used in these projects:** Splunk, SPL, Event Viewer, Windows Security logs, Sysmon, and Nessus.

**Additional training:** Active Directory fundamentals, TCP/IP, DNS, DHCP, Wireshark, Nmap, Windows, and Linux.

**Education:** CompTIA Security+ (2026); Tri-C SecurePath cybersecurity training (14 weeks, completed June 2026); Associate of Arts, Cuyahoga Community College (2022). I also completed CySA+ coursework.

## Practice plans

The [Windows/Active Directory support exercise](practice-labs/helpdesk-ad/README.md) and [Sentinel/KQL exercise](practice-labs/sentinel-kql/README.md) are **plans awaiting execution**. The Splunk [host/session validation checklist](docs/splunk-correlation-validation-plan.md) is also pending.

I wrote a [sample handoff ticket](docs/splunk-retrospective-triage-ticket.md) based on my Splunk investigation.

All completed projects used authorized TryHackMe or uCertify training environments. Each report states the scope of the work and the checks that remain open.
