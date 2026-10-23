# Windows Security Log Triage: Password Reset and SYSTEM Activity

**Case:** LAB-WIN-001 · **Environment:** uCertify Windows training VM · **Tool:** Event Viewer

## Summary

I reviewed an Administrator password reset and SYSTEM activity a few minutes later. The reset and matching account-change event strongly supported a password change. The later logon belonged to SYSTEM and had the characteristics of a Windows service logon.

I kept those two event groups separate. The four reviewed records did not establish an incident, and the reset's authorization remained an open question.

## Scope and method

The source Security log contained **6,530 events**. I manually examined **four** selected records: 4724, 4738, 4624, and 4672. I compared timestamps, accounts, Logon IDs, processes, and account-change fields.

The displayed November 18, 2021 timestamps came from the preloaded training dataset. The lab did not supply an administrative approval record or broader endpoint/network investigation.

## Evidence timeline

![Two event groups: Administrator account changes and later SYSTEM service activity](images/evidence-timeline.svg)

| Displayed time | Event | Observation |
|---|---|---|
| 9:31:21 PM | 4724 | Administrator password-reset attempt; Audit Success |
| 9:31:21 PM | 4738 | Administrator account changed; Password Last Set matched the reset time |
| 9:35:47 PM | 4624 | SYSTEM logon; services.exe; Logon ID 0x3E7 |
| 9:35:47 PM | 4672 | Sensitive privileges assigned in the SYSTEM context |

## Why I kept the events separate

Event 4672 caught my attention because it records sensitive privileges. My interpretation changed when I checked the related 4624 event: the account was **SYSTEM**, the process was **services.exe**, and the Logon ID was `0x3E7`. That pointed toward routine service activity, not a new interactive Administrator session. The four-minute gap after the password change was not enough to connect the events.

The separate question was whether the Administrator password change was authorized. Events 4724 and 4738 supported the change, but the training dataset did not contain its approval record or a follow-up login test.

## Administrator password reset

Event 4724 named `Administrator` as the target. Its subject was the computer account `WIN-KRLBFUPGGRQ$` under SYSTEM context. Event 4738 showed a matching **Password Last Set** timestamp; the old and new UAC values were both `0x210`.

Together, these records strongly corroborated a password change at the recorded time. They did not explain who approved it. I did not test subsequent authentication.

[4724 record](evidence/ac5ea633-98af-448d-9494-0c9ae7b92020.png) · [4738 record](evidence/14b8b493-6ed4-4d86-b2e7-7dfeafe523d8.png) · [Password Last Set detail](evidence/45a70e3a-aa9f-4813-ae95-99d8b8b35233.png)

## Later SYSTEM service activity

The Event 4624 screenshot shows `NT AUTHORITY\SYSTEM`, Logon ID `0x3E7`, `services.exe`, and dashes for source IP and port. Event 4672 at the same displayed time showed SYSTEM privileges including `SeDebugPrivilege`, `SeBackupPrivilege`, `SeRestorePrivilege`, and `SeImpersonatePrivilege`.

The SYSTEM account and services.exe process were consistent with service activity. The later logon was not an Administrator logon, and its timing did not establish a causal connection to the reset.

[4624 record](evidence/58554701-3442-490a-b343-e9d28a6551ae.png) · [4672 record](evidence/f7b81dbf-abcb-4bbb-a7b1-7cf7179a4120.png)

## Conclusion and follow-up

**Assessment:** SYSTEM service activity consistent with expected behavior; password-reset approval unverified. **Confidence:** Moderate, limited to the four reviewed records.

Before closing a comparable support/security case, I would check the reset ticket or change record and confirm authorization with the responsible owner. I would also review nearby Administrator authentication and relevant process/service events. An unapproved reset or corroborating suspicious activity would be a reason to escalate.

The reviewed events do not establish the host's overall security state. This exercise used Event Viewer; broader SIEM, EDR, and network checks are follow-up work.

## Evidence handling

I exported the Security log as `security_logs.evtx`. The export screenshot shows the saved file in Documents. The 6,530-event count is visible in the Security log screenshots.

| Screenshot | What it shows |
|---|---|
| [4724: Password reset](evidence/ac5ea633-98af-448d-9494-0c9ae7b92020.png) | Administrator target, SYSTEM subject, Logon ID 0x3E7, and Audit Success at 9:31:21 PM |
| [4738: Account change](evidence/14b8b493-6ed4-4d86-b2e7-7dfeafe523d8.png) | Administrator target and SYSTEM subject at the same displayed time |
| [4738: Changed attributes](evidence/45a70e3a-aa9f-4813-ae95-99d8b8b35233.png) | Password Last Set at 9:31:21 PM; old and new UAC values both 0x210 |
| [4624: SYSTEM logon](evidence/58554701-3442-490a-b343-e9d28a6551ae.png) | SYSTEM, services.exe, Logon ID 0x3E7, and dashes for source IP/port at 9:35:47 PM |
| [4672: SYSTEM privileges](evidence/f7b81dbf-abcb-4bbb-a7b1-7cf7179a4120.png) | SYSTEM, Logon ID 0x3E7, and the listed privileges at 9:35:47 PM |
| [Saved export](evidence/59c01585-3317-480e-815b-5e3ab20b748e.png) | security_logs.evtx selected in the Documents folder |
| [Event Viewer overview](evidence/15148a3a-94cf-4fe9-ae0c-73f3a28623d8.png) | Overview and Summary page, including the available logs |

## What I learned

Event 4672 looked significant until I checked the account and the related logon process. SYSTEM service authentication explained those privileges more plausibly than a new Administrator session. The password-reset approval was the separate question I still needed to answer.

## References

- [Microsoft: Event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4672](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4672)
- [Microsoft: Event 4724](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4724)
- [Microsoft: Event 4738](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4738)
