# Windows Security Log Triage: Password Reset and SYSTEM Activity

**Case:** LAB-WIN-001 · **Environment:** uCertify Windows training VM · **Tool:** Event Viewer

## Summary

I reviewed an Administrator password reset and SYSTEM activity a few minutes later. The reset and matching account-change event strongly supported a password change. The later logon belonged to SYSTEM and had the characteristics of a Windows service logon.

I kept those two event groups separate. The four reviewed records did not establish an incident, and the reset's authorization remained an open question.

## Scope and method

The source Security log contained **6,530 events**. I manually examined **four** selected records: 4724, 4738, 4624, and 4672. I compared timestamps, accounts, logon types, Logon IDs, processes, and account-change fields.

The displayed November 18, 2021 timestamps came from the preloaded training dataset. The lab did not supply an administrative approval record or broader endpoint/network investigation.

## Evidence timeline

![Two event groups: Administrator account changes and later SYSTEM service activity](images/evidence-timeline.svg)

| Displayed time | Event | Observation |
|---|---|---|
| 9:31:21 PM | 4724 | Administrator password-reset attempt; Audit Success |
| 9:31:21 PM | 4738 | Administrator account changed; Password Last Set matched the reset time |
| 9:35:47 PM | 4624 | SYSTEM logon; Type 5; services.exe |
| 9:35:47 PM | 4672 | Sensitive privileges assigned in the SYSTEM context |

## Administrator password reset

Event 4724 named `Administrator` as the target. Its subject was the computer account `WIN-KRLBFUPGGRQ$` under SYSTEM context. Event 4738 showed a matching **Password Last Set** timestamp; the old and new UAC values were both `0x210`.

Together, these records strongly corroborated a password change at the recorded time. They did not explain who approved it. I did not test subsequent authentication.

[4724 record](https://github.com/user-attachments/assets/ac5ea633-98af-448d-9494-0c9ae7b92020) · [4738 record](https://github.com/user-attachments/assets/14b8b493-6ed4-4d86-b2e7-7dfeafe523d8) · [Password Last Set detail](https://github.com/user-attachments/assets/45a70e3a-aa9f-4813-ae95-99d8b8b35233)

## Later SYSTEM service activity

Event 4624 showed `NT AUTHORITY\SYSTEM`, **Logon Type 5**, `services.exe`, and no supplied source IP/port. Event 4672 at the same displayed time showed SYSTEM privileges including `SeDebugPrivilege`, `SeBackupPrivilege`, `SeRestorePrivilege`, and `SeImpersonatePrivilege`.

The account, logon type, and process were consistent with service authentication. The later logon was not an Administrator logon, and its timing did not establish a causal connection to the reset.

[4624 record](https://github.com/user-attachments/assets/58554701-3442-490a-b343-e9d28a6551ae) · [4672 record](https://github.com/user-attachments/assets/f7b81dbf-abcb-4bbb-a7b1-7cf7179a4120)

## Conclusion and follow-up

**Assessment:** SYSTEM service activity consistent with expected behavior; password-reset approval unverified. **Confidence:** Moderate, limited to the four reviewed records.

Before closing a comparable support/security case, I would check the reset ticket or change record and confirm authorization with the responsible owner. I would also review nearby Administrator authentication and relevant process/service events. An unapproved reset or corroborating suspicious activity would be a reason to escalate.

The reviewed events do not establish the host's overall security state. This exercise used Event Viewer; broader SIEM, EDR, and network checks are follow-up work.

## Evidence handling

I [exported the Security log](https://github.com/user-attachments/assets/59c01585-3317-480e-815b-5e3ab20b748e) as `security_logs.evtx`. I included screenshots of the records I reviewed. The [source-log overview](https://github.com/user-attachments/assets/15148a3a-94cf-4fe9-ae0c-73f3a28623d8) records the log used.

## What I learned

Event 4672 looked significant until I checked the account and logon type. SYSTEM service authentication explained those privileges more plausibly than a new Administrator session. The password-reset approval was the separate question I still needed to answer.

## References

- [Microsoft: Event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4672](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4672)
- [Microsoft: Event 4724](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4724)
- [Microsoft: Event 4738](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4738)
