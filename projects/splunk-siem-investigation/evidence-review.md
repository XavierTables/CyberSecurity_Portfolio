# Screenshot Evidence Review — LAB-SIEM-003

**Review date:** October 26, 2026  
**Disposition:** Retrospective review complete; unauthorized activity undetermined.  
**Available material:** Nine retained screenshots and a historical 11-search query log. Only screenshots are currently available for validation. No raw dataset, search-result export, or new Splunk execution is represented by this review.

[Investigation](README.md) · [Historical searches](queries/investigation-queries.md) · [Case brief](../../docs/splunk-incident-brief.md) · [Sample handoff](../../docs/splunk-retrospective-triage-ticket.md)

## What was checked

Each of the nine image files was inspected. The downloaded bytes matched the repository's Git blob IDs at source commit `57561c2c24063d6ec3be2240ca831ff2a54c05bc`. The screenshots were preserved unchanged. The review compared visible counts, fields, query text and result rows with the report. It did not reconstruct unseen events or rerun SPL.

## Evidence index

| Retained image | Observation visible in the capture | What it does not establish |
| --- | --- | --- |
| [01: Windows overview](evidence/01-windows-data-overview.png) | `index=windowslogs`; 12,256 events. Sidebar shows one `host` value and three `Hostname` values. Expanded Sysmon Event 10 names `Micheal.Beaven`; displayed Time is July 14, 2022, while EventTime and UtcTime are April 15, 2022. | That every event belongs to one event computer, or that displayed Time and original event time are interchangeable. |
| [02: Event ID distribution](evidence/02-windows-eventid-distribution.png) | 55 result rows. Events 4720, 4724, 4726, 4728, 4729 and 4739 each have count 1. | Rarity as proof of malicious activity; the computer/session/detail of Event 4739. Part of the search bar is cropped. |
| [03: James network logon](evidence/03-james-network-logon.png) | Expanded Security 4624: James, `Hostname=Micheal.Beaven`, Type 3, Kerberos, source `172.90.12.11`, elevated token Yes, target Logon ID `0x551686`, and a nonzero Logon GUID. EventTime is `2022-04-15 08:06:02`. | That James was physically at the workstation, that a privilege escalation occurred, or that the separate Sysmon rows share this event computer/session. The exact query and total result count are not visible. |
| [04: Security rows](evidence/04-security-session-timeline.png) | Search and 12 rows are visible. Every displayed EventTime is `2022-04-15 08:06:02`. James is the subject for selected account/group rows; Alberto is the target in the creation/deletion rows. | Reliable elapsed timing, a verified single-computer/log instance, Alberto's involvement in group changes, or the reset outcome. The output omits event-host fields and clips complete messages. |
| [05: Sysmon relationships](evidence/05-sysmon-process-correlation.png) | Search and three rows for `Cybertees\James`: net.exe has WmiPrvSE.exe as parent; net1.exe and conhost.exe have parent GUIDs matching the displayed net.exe ProcessGuid. | Complete event-host/session correlation, full command intent or administrative approval. Event-host, Logon ID/GUID and command-line columns are absent. |
| [06: VPN overview](evidence/06-vpn-data-overview.png) | `index=vpnlogs`; 2,000 events; sidebar lists 10 users, 12 source IPs and six country values. Visible event examples show `source=vpnlogs.csv`, `host=vpn-server`, and timestamp text with `+0000`. | Independently verified physical country, a device/MFA outcome, or a documented display zone for every other capture. |
| [07: Country baseline](evidence/07-vpn-country-baseline.png) | jsmith: 199 US and 1 JP; kbrown: 199 DE and 1 AU. Each account has 200 events in the displayed baseline. | That a rare country is unauthorized or that a threshold is suitable for production use. |
| [08: jsmith IP baseline](evidence/08-jsmith-ip-baseline.png) | `72.14.201.12` / US: 199 events; `103.5.140.67` / JP: 1 event. Displayed baseline spans February 22–March 23, 2026; the JP row is February 26 at 14:15. | Historical IP ownership, actual location, device identity or account-owner confirmation. |
| [09: VPN transitions](evidence/09-vpn-rapid-country-switch-detection.png) | Query and all four transition rows are visible, with gaps of 25, 15, 17 and 57 minutes. | Four separate compromises or four rare-country events. These are transitions into and out of two outlier events. |

## Windows: observations and decisions

### Event computer and timestamps

The expanded logon supplies the event-hostname value `Micheal.Beaven`; the separate Sysmon result table supplies no hostname. The overview's one `host` value and three `Hostname` values make it especially important to distinguish Splunk metadata from the source event's computer. A hostname recovered from one record cannot be assigned to rows that omit it.

The overview's April-to-July date mismatch cannot be explained by an ordinary time-zone display offset alone. In that expanded event, EventTime is `2022-04-15 08:05:44` and UtcTime is `2022-04-15 12:05:44.335`; the field labels and values are preserved observations, not a validated account of the ingestion settings. The source zone and parsing cause cannot be recovered from these views.

All 12 Security rows show the same EventTime, and all three selected Sysmon rows display the same `_time`. This does not establish simultaneous actions or trustworthy cross-source timing. Record numbers show the displayed ordering; they support source-log chronology only after confirming the relevant computer/log instance.

### Actor, target and operation outcome

| Record number shown in screenshot 04 | Visible event/relationship | Bounded interpretation |
| --- | --- | --- |
| 56034 | 4624; James is the target/new-logon account; TargetLogonId `0x551686`; Type 3 | A network logon record for the candidate session. |
| 56058 | 4688; computer-account subject; SubjectLogonId `0x3e4`; James is the target; TargetLogonId `0x551686` | The same ID occurs in a target field. James must not be described as the subject actor of every matching row. |
| 56078 | 4728; James subject; SubjectLogonId `0x551686`; TargetUserName displayed as None | A group-add record is present. Member name/SID and actual group detail are not exposed in this view. |
| 56079 | 4720; James subject; Alberto target | The creation row names Alberto. This does not resolve the member/group in 4728. |
| 56080 | 4724; James subject; target and audit outcome not shown | A reset-attempt event is present; a successful reset or its target is not established by this capture. |
| 56081 | 4729; James subject; TargetUserName displayed as None | A group-remove record is present; actual member/group details are not established. |
| 56082 | 4726; James subject; Alberto target | The deletion row names Alberto. |
| 56087 | 4634; James target; TargetLogonId `0x551686`; Type 3 | A matching-ID logoff row is shown, subject to the unresolved computer/log context. |

A matching number must retain its subject/target meaning. Microsoft's Logon ID scope is the same computer between reboots; that scope cannot be verified for every table row here. An elevated token or special-logon record alone does not establish a new privilege escalation.

### Process ancestry

| Image in screenshot 05 | Process ID | Parent process ID | Parent image | GUID comparison |
| --- | --- | --- | --- | --- |
| net.exe | 7768 | 3952 | WmiPrvSE.exe | Its ProcessGuid matches both children's ParentProcessGuid. |
| net1.exe | 3692 | 7768 | net.exe | ParentProcessGuid matches the displayed net.exe ProcessGuid. |
| conhost.exe | 7264 | 7768 | net.exe | ParentProcessGuid matches the displayed net.exe ProcessGuid. |

This supports the displayed parent-child relationships. Without event-host/session fields and full command lines, it does not connect those processes to all Security changes or decide between approved administration and unauthorized use.

### Event 4739

Screenshot 02 shows one occurrence; screenshot 04's search omits it. No retained detail compares its computer, session, time or changed attributes with the lead. The earlier claim that its different host/session justified exclusion is withdrawn as unsupported. Event 4739 is a domain-policy change, not an account-creation event.

**Final Windows decision:** The retained evidence supports the individual logon/account observations and separate Sysmon ancestry. It is insufficient to establish a single correlated Security/Sysmon session, successful password reset, affected group/member, administrative approval, or compromise. Those are explicit limits of this completed retrospective review.

## VPN: observations and decision

| Displayed current time | Account | Transition | Previous source → current source | Gap, minutes |
| --- | --- | --- | --- | --- |
| 2026-02-26 14:15:00 | jsmith | US → JP | 72.14.201.12 → 103.5.140.67 | 25 |
| 2026-02-26 14:30:00 | jsmith | JP → US | 103.5.140.67 → 72.14.201.12 | 15 |
| 2026-03-13 11:41:00 | kbrown | DE → AU | 91.64.42.130 → 103.224.182.5 | 17 |
| 2026-03-13 12:38:00 | kbrown | AU → DE | 103.224.182.5 → 91.64.42.130 | 57 |

Times are transcribed as displayed; the display zone was not recorded. The raw example timestamps in screenshot 06 do not independently verify the interpretation of every transition record.

Each rare country accounts for `1 / 200 × 100 = 0.5%` of that user's displayed events. That arithmetic is corroborated by screenshot 07; a separate capture of the rarity-query execution was not retained. The 5% rarity cutoff and 120-minute transition window were exploratory lab choices, without retained evaluation against representative benign and malicious activity.

**Final VPN decision:** Two rare-country events and four surrounding transitions are corroborated within the supplied data. They warrant identity/routing checks if those sources are available. Country labels and short intervals do not establish actual travel or credential theft. Device, MFA, owner confirmation and historical routing evidence are unavailable, so unauthorized access remains undetermined.

## Historical execution coverage

The written log records 11 searches. Screenshots directly show selected query/result pairs, not all 11 executions. The exact account/policy search result and separate rarity-query run lack retained captures. The expanded James logon supports its visible fields but does not show the query bar or one-result count. The event-distribution query is partly cropped. These distinctions do not invalidate the displayed findings; they limit independent reproduction.

No search was rerun during this review. The three queries in the [optional validation runbook](queries/windows-validation.md) remain unexecuted and separate from the historical 11.

## Completion boundary

The retrospective lab review is complete with the conclusions above. The two leads remain separate, and no benign authorization, containment, remediation or production incident closure is claimed. If original data is recovered later, the optional runbook defines the additional evidence needed to strengthen or change these conclusions.

## Primary references

- [Microsoft: Event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4634 and Logon ID scope](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4634)
- [Microsoft: Event 4739](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4739)
- [Microsoft: Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Splunk: timestamp and time-zone processing](https://help.splunk.com/en/splunk-enterprise/search/search-manual/9.0/specify-time-ranges/how-time-zones-are-processed-by-the-splunk-platform)
