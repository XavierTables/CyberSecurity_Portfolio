# Windows Validation: LAB-SIEM-003

**Prepared:** October 26, 2026 · **Execution status:** Not run against the original Splunk dataset.

**Optional future work:** Only screenshots are currently available. The [retrospective evidence review](../evidence-review.md) is complete with bounded findings. This runbook is retained for use only if original data is recovered; it is not a claim that those checks were completed or a prerequisite for reading the final screenshot-based assessment.

This is a follow-up runbook for the [investigation](../README.md), separate from the [11 recorded searches](investigation-queries.md). It does not document completed validation, confirmed compromise, or incident closure.

## Start here

Open the original TryHackMe Splunk lab containing `windowslogs`. Record the room URL/name, dataset/source reference, Splunk version if available, execution date, and display time zone. Do not substitute another walkthrough's results or the Operations Lab simulator for evidence from this exercise.

Keep the time picker on **All time for these discovery searches**. The retained screenshots show inconsistent `_time`/EventTime dates, so a narrow picker could hide relevant source events. This is discovery, not a validated final time scope. Once the source timestamps are understood, use a confirmed event-computer, source-time window and log/boot context for final correlation.

## 1. Recover the computer, session fields and original timestamp

Run this first. Export every result as CSV or JSON, including `_raw`; preserve the exact query and a screenshot of the execution. If the lab restricts redistribution, keep the permitted result table and record that restriction.

```spl
index=windowslogs ("0x551686" OR EventID=4739)
| eval splunk_epoch=_time, display_time_with_offset=strftime(_time,"%Y-%m-%dT%H:%M:%S%z")
| table splunk_epoch display_time_with_offset host Hostname Computer ComputerName source sourcetype Channel EventID RecordNumber EventRecordID EventTime UtcTime SubjectUserName SubjectLogonId TargetUserName TargetLogonId _raw
```

Missing columns are a finding to investigate. Inspect `_raw` for the event computer, provider, channel, original timestamp, zone and event-specific fields. The retained JSON-like record uses `Hostname`; preserve that field as well as any Computer/ComputerName fields found in recovered data. Splunk `host` can describe collection metadata; do not silently treat it as the event computer.

The April-to-July date mismatch cannot be explained by a normal time-zone display offset alone. Determine whether `_time` was parsed from the wrong field, whether EventTime is constant or malformed, or whether the dataset was transformed. Those are hypotheses until the raw records and source documentation support one.

Do not overwrite `_time` or guess a `strptime` pattern. First retain the original source value and its documented zone. Parse a separate source-time field using the format actually observed, count null/unparseable values, and compare numeric epochs and offsets. A local timestamp without a known zone is not verified UTC. Do not claim elapsed timing when the source cannot establish it.

## 2. Recover the Sysmon session and process context

Run this after the first search. It preserves other process activity for James rather than selecting only the three previously highlighted images.

```spl
index=windowslogs EventID=1 User="Cybertees\\James"
| eval splunk_epoch=_time
| table splunk_epoch host Hostname Computer ComputerName source sourcetype Channel EventID EventTime UtcTime User LogonId LogonGuid ProcessGuid ParentProcessGuid ProcessId ParentProcessId Image ParentImage CommandLine ParentCommandLine _raw
```

Match the account spelling and source field names to the actual records; document any changes. A missing `LogonId`/`LogonGuid` column does not mean the raw event lacks it. Check `_raw` before deciding the field is unavailable.

Verify the event computer first. Compare the parent GUID on net1.exe/conhost.exe with the ProcessGuid of the same-computer net.exe record. Preserve full command lines and original source times. Process ID numbers alone are not a durable cross-event key. Parent-child ancestry is one finding; membership in the Security session is a separate finding.

## 3. Recover account/group changes and the policy event

```spl
index=windowslogs EventID IN (4720,4724,4726,4728,4729,4739)
| eval splunk_epoch=_time
| table splunk_epoch host Hostname Computer ComputerName source sourcetype Channel EventID RecordNumber EventRecordID EventTime SubjectUserName SubjectDomainName SubjectLogonId SubjectUserSid TargetUserName TargetDomainName TargetSid MemberName MemberSid Keywords Message _raw
```

Inspect all returned records, including Event 4739 even if it belongs to a different computer or session. Preserve the comparison that supports either keeping it with the lead or treating it separately.

For 4720/4726, record the actual target account/SID. For 4728/4729, distinguish the subject actor, member name/SID, and target group name/SID. Resolve SIDs only with supplied directory evidence. For 4724, retain the target and audit outcome; the Event ID alone does not prove a successful reset. For 4739, identify the domain and changed policy attributes. Any approval/authorization claim requires evidence beyond the event's existence.

## Decisions required before updating the findings

| Check | Evidence needed | Current status |
| --- | --- | --- |
| Event-computer scope | Original Computer value, provider/channel and source/log provenance on both sources | Not established from retained screenshots |
| Timestamp interpretation | Raw source timestamps, documented zone, parser result/parse failures and comparison with numeric `_time` | Not established from retained screenshots |
| Security session | Event-specific subject/target IDs, account/SID, computer, source-time window, and reboot/log boundary evidence or explicit boundary limitation | Not established from retained screenshots |
| Sysmon connection | Same event computer and compatible source time plus matching session/GUID context where present; GUID ancestry checked separately | Not established from retained screenshots |
| Alberto/group relationship | Expanded 4728/4729 member and group fields, compared with the account SID | Not established from retained screenshots |
| Password reset | Expanded 4724 target and audit outcome | Not established from retained screenshots |
| Event 4739 relevance | Original record and saved computer/session/time comparison | Not established from retained screenshots |
| Administrative approval | Supplied change record, owner confirmation, or explicit statement that it is unavailable | Unavailable in retained evidence |

Use each event's schema: for the 4624 session being investigated, start with TargetLogonId; administrative action records usually identify the actor in SubjectLogonId. Do not combine those into one unlabeled ID. A Logon ID is scoped to a computer between reboots. A repeated ID, matching username, nearby `_time`, or matching PID by itself is insufficient.

If evidence is absent or contradicts the proposed relationship, report that result. A valid investigation can finish with a bounded conclusion that correlation cannot be established from the supplied data. That does not close a real incident or establish the activity as authorized.

## VPN work

The retained screenshots support two rare-country events and four surrounding transitions, with gaps of 25, 15, 17 and 57 minutes. Keep this lead separate from Windows. The pattern does not establish physical travel or credential theft. Device, MFA, account-owner and routing/geolocation verification still depend on evidence not present in the repository. Do not invent those confirmations to finish a training report.

## Save the result

After execution, retain: the exact query, source/lab reference, execution date and display zone, event-computer scope, numeric/source timestamps, result count, exported records, and your observation versus interpretation. Link the outputs from the investigation and update the brief/handoff consistently. Keep an unexecuted query labeled unexecuted.

## Primary references

- [Microsoft: Event 4624 and logon fields](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4634 and Logon ID scope](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4634)
- [Microsoft: Event 4739 domain-policy changes](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4739)
- [Microsoft: Sysmon process telemetry](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Splunk: date and time evaluation functions](https://help.splunk.com/en/splunk-enterprise/spl-search-reference/9.4/evaluation-functions/date-and-time-functions)
- [Splunk: timestamp storage and time-zone processing](https://help.splunk.com/en/splunk-enterprise/search/search-manual/9.0/specify-time-ranges/how-time-zones-are-processed-by-the-splunk-platform)
