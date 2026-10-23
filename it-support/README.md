# IT Support and Troubleshooting

[Portfolio](../README.md) · [LinkedIn](https://www.linkedin.com/in/xaviertables/)

My background includes PC building, informal computer/home-network support, and Windows/Active Directory training through SecurePath.

## Documented Windows account review

**[Windows Security Log Triage: report and evidence](../projects/windows-security-log-triage/README.md)**

I examined password-reset/account-change records, then checked whether a later privileged logon was related. Events 4724 and 4738 supported an Administrator password change. The later 4624/4672 records belonged to SYSTEM and `services.exe`, so I kept that activity separate.

The follow-up is to confirm reset authorization with the responsible administrator. This case demonstrates log review; it does not document an end-user repair.

[Password-reset record](../projects/windows-security-log-triage/evidence/ac5ea633-98af-448d-9494-0c9ae7b92020.png) · [Account-change record](../projects/windows-security-log-triage/evidence/14b8b493-6ed4-4d86-b2e7-7dfeafe523d8.png) · [SYSTEM logon](../projects/windows-security-log-triage/evidence/58554701-3442-490a-b343-e9d28a6551ae.png)

## Additional experience and training

| Area | Background |
| --- | --- |
| PC and home support | Built PCs and helped family with hardware, software, and home-network issues |
| Windows and Active Directory | Training in users, groups, password resets, and permission concepts |
| Networking | Training with Wireshark, Nmap, command-line tools, TCP/IP, DNS, and DHCP |

## Planned support case

The [AD file-share practice plan](../practice-labs/helpdesk-ad/README.md) covers reproducing an access error, checking connectivity/DNS, comparing group membership with share/NTFS permissions, and verifying access after an approved lab change. Execution and resolution are still pending.

[Support ticket template](support-ticket-template.md) · [Project roadmap](../docs/project-roadmap.md)
