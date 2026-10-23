# IT Support / Help Desk — Practical Evidence

My IT Support background combines PC building, troubleshooting computers for family members, networking fundamentals, and Windows/Active Directory training. This page links to the **support-related work I can document** rather than claiming a finished help desk ticket I haven't completed.

## Windows account-change investigation (uCertify)

**[Read the report and view the evidence](../projects/windows-security-log-triage/README.md)**

**Question:** Did the records show an Administrator password change, and was a privileged logon several minutes later related to it?

I examined Event IDs **4724** and **4738**, which supported a password change. Then I compared **4624** and **4672** and found the later activity belonged to **SYSTEM / services.exe**. The timing alone wasn't enough to connect those events to the password change.

**Result:** I kept the Administrator and SYSTEM activity separate and identified the missing authorization check. The training data didn't include the approval record, so I couldn't close that question or claim an incident.

[Password-reset evidence](../projects/windows-security-log-triage/evidence/ac5ea633-98af-448d-9494-0c9ae7b92020.png) · [Account-change evidence](../projects/windows-security-log-triage/evidence/14b8b493-6ed4-4d86-b2e7-7dfeafe523d8.png) · [SYSTEM logon](../projects/windows-security-log-triage/evidence/58554701-3442-490a-b343-e9d28a6551ae.png) · [EVTX export screenshot](../projects/windows-security-log-triage/evidence/59c01585-3317-480e-815b-5e3ab20b748e.png)

This was **log analysis**, not a live support ticket or a demonstrated end-user fix.

## Other relevant experience

| Area | Experience | Documentation |
| --- | --- | --- |
| PC and home support | Built PCs; helped family with software, hardware and home-network issues | Personal experience; no individual repair ticket recorded |
| Active Directory | Practiced user accounts, groups, password resets, and permission concepts through SecurePath training | Training experience; full file-share case still to be completed |
| Network tools | Wireshark, Nmap, command-line work; TCP/IP, DNS, and DHCP fundamentals | Training experience; no completed network ticket posted |

## Next project: file-share access ticket

My [Active Directory ticket plan](../practice-labs/helpdesk-ad/README.md) starts with a user who cannot access a departmental share. The work will be to **reproduce the error, separate connectivity from access-control issues, check AD membership and share/NTFS permissions, document authorization, and verify access as the affected test user**.

The plan is public, but the troubleshooting hasn't been executed yet. I'll add a real resolution or escalation with screenshots once I perform the lab. I have a [blank support ticket template](support-ticket-template.md) for recording the results.

## Related investigations

[Splunk and Windows/VPN investigation](../projects/splunk-siem-investigation/README.md) · [Nessus guided assessment](../projects/nessus-vulnerability-assessment/README.md)

[Back to portfolio](../README.md)
