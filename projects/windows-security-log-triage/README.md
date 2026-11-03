# Windows Security Log Triage: Password Reset and SYSTEM Activity

**Case:** LAB-WIN-001 · **Environment:** uCertify Windows training VM · **Tool:** Event Viewer

[Portfolio](../../README.md) · [Evidence index](#evidence)

## Case at a glance

| My question | What I checked | What I concluded |
| --- | --- | --- |
| Did the Administrator password change and later privileged activity belong to the same suspicious sequence? | Four Event Viewer records: **4724, 4738, 4624 and 4672**; account names, Logon IDs, timestamps and processes | The first pair supported an **Administrator password change**. The later pair matched **SYSTEM service activity**, not a proven continuation of the reset. |

**Evidence:** [Event timeline](#scope-and-timeline) · [Original screenshots](#evidence)

**Limit:** I reviewed four selected records from a supplied Windows training log. I couldn't verify who approved the password change or assess the rest of the host from those four records alone.

## Why I looked twice

Event 4672 stood out because it listed sensitive privileges. I didn't want to assume that meant someone had escalated access. I checked the nearby logon and found `NT AUTHORITY\\SYSTEM`, `services.exe`, and Logon ID `0x3E7`. Those details changed how I interpreted the later activity.

I kept the password-change records and the SYSTEM service records separate. My next step in a real support or security workflow would be to verify whether the Administrator change was approved, then review other relevant authentication and process events if it wasn't.

## Scope and timeline

The source Security log contained **6,530 events**. I manually examined **four** selected records, comparing timestamps, accounts, Logon IDs, processes, and account-change fields. The displayed November 18, 2021 timestamps came from the preloaded training data.

![Two event groups: Administrator account changes and later SYSTEM service activity](images/evidence-timeline.svg)

| Displayed time | Event | Observation |
| --- | --- | --- |
| 9:31:21 PM | 4724 | Administrator password-reset attempt; Audit Success |
| 9:31:21 PM | 4738 | Administrator account changed; Password Last Set matched the reset time |
| 9:35:47 PM | 4624 | SYSTEM logon; `services.exe`; Logon ID `0x3E7` |
| 9:35:47 PM | 4672 | Sensitive privileges assigned in the SYSTEM context |

## Evidence behind the SYSTEM assessment

The 4624 record showed `NT AUTHORITY\\SYSTEM`, `services.exe` and dashes for source IP and port. Event 4672, at the same displayed time, listed `SeDebugPrivilege`, `SeBackupPrivilege`, `SeRestorePrivilege` and `SeImpersonatePrivilege`.

That event pair occurred roughly four minutes after the account-change records. The time gap alone was not enough to tie the two groups together.

## Administrator password change

Event 4724 named Administrator as the target and the computer account `WIN-KRLBFUPGGRQ$` as the subject under SYSTEM context. Event 4738 showed a matching Password Last Set timestamp; its old and new UAC values were both `0x210`.

Together, these records strongly corroborated a password change. The lab did not provide an approval record or a follow-up authentication test.

## Recommended follow-up

I would check the reset ticket or change record with the responsible administrator, then review nearby Administrator authentication and relevant process/service events. An unapproved reset or corroborating suspicious activity would justify escalation.

The reviewed records support an interpretation of these events. A broader host-security assessment would require additional endpoint and network evidence.

## Evidence

I exported the Security log as `security_logs.evtx` in the training VM. **This repository contains the export screenshot; the raw EVTX file is unavailable for download.**

| Screenshot | What it shows |
| --- | --- |
| [4724: Password reset](evidence/ac5ea633-98af-448d-9494-0c9ae7b92020.png) | Administrator target, SYSTEM subject, Logon ID `0x3E7`, and Audit Success at 9:31:21 PM |
| [4738: Account change](evidence/14b8b493-6ed4-4d86-b2e7-7dfeafe523d8.png) | Administrator target and SYSTEM subject at the same displayed time |
| [4738: Changed attributes](evidence/45a70e3a-aa9f-4813-ae95-99d8b8b35233.png) | Password Last Set at 9:31:21 PM; old/new UAC values both `0x210` |
| [4624: SYSTEM logon](evidence/58554701-3442-490a-b343-e9d28a6551ae.png) | SYSTEM, `services.exe`, Logon ID `0x3E7`, and dashes for source IP/port |
| [4672: SYSTEM privileges](evidence/f7b81dbf-abcb-4bbb-a7b1-7cf7179a4120.png) | SYSTEM, Logon ID `0x3E7`, and the listed privileges at 9:35:47 PM |
| [Saved EVTX export](evidence/59c01585-3317-480e-815b-5e3ab20b748e.png) | `security_logs.evtx` selected in Documents |
| [Event Viewer overview](evidence/15148a3a-94cf-4fe9-ae0c-73f3a28623d8.png) | Overview and Summary page with available logs |

## What I learned

The account and process context mattered more than the event's alarming-looking privilege list. Checking those fields kept me from treating normal SYSTEM activity as evidence of an Administrator compromise.

## References

- [Microsoft: Event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4672](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4672)
- [Microsoft: Event 4724](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4724)
- [Microsoft: Event 4738](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4738)
