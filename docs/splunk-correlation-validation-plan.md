# Splunk Host/Session Correlation — Revalidation Plan

> **STATUS: PROPOSED TESTS, NOT EXECUTED.** The original training dataset is not available for independent re-query here. These examples do **not** repair the historical evidence or confirm that Security and Sysmon events came from one host/session.

## Why this matters
The recorded search `"0x551686" Channel=Security` operates over historical data without a host or time filter; the Sysmon query also lacks a matching computer constraint. Windows logon IDs can be reused across hosts and after restarts. A shared account and timestamp is suggestive, not definitive cross-source identity.

## Step 1 — Establish field names and event computers
Run in the same authorized Splunk dataset, then inspect returned **field values** rather than assuming the field schema:

```spl
index=windowslogs EventID=4624 "0x551686"
| table _time EventID Hostname host Computer ComputerName TargetUserName TargetLogonId SubjectLogonId LogonType IpAddress
```

Expected anchor from published capture: Windows Event 4624; James; target Logon ID `0x551686`; displayed `Hostname=Micheal.Beaven`. **The event computer for other records remains to be established.** Confirm which field actually represents the event computer before proceeding.

## Step 2 — Scope Windows Security records to the verified computer AND bounded time

```spl
index=windowslogs Channel=Security EventID IN (4624,4672,4627,4688,4728,4720,4724,4729,4726,4634)
"0x551686" earliest="<START_EPOCH>" latest="<END_EPOCH>"
| search Hostname="<VERIFIED_EVENT_COMPUTER>"
| sort 0 _time RecordNumber
| table _time Hostname RecordNumber EventID SubjectUserName TargetUserName SubjectLogonId TargetLogonId LogonType Message
```

Replace `<...>` placeholders with **measured** values. In Splunk time modifiers, `earliest` and `latest` should be placed in the base search as shown, and the exact field name may differ by sourcetype. Confirm event-specific subject vs. target Logon ID; do not assume a free-text match means the same field in every event.

## Step 3 — Independently verify Sysmon computer and process ancestry

```spl
index=windowslogs EventID=1 User="Cybertees\\James" earliest="<START_EPOCH>" latest="<END_EPOCH>"
| table _time Hostname host Computer User Image ParentImage ProcessGuid ParentProcessGuid ProcessId ParentProcessId CommandLine
```

Then filter the **actual Sysmon event-computer field** to the validated host (do not blindly reuse a field that is missing in Sysmon). Compare `ProcessGuid` / `ParentProcessGuid` for the parent-child chain. Process GUID ancestry identifies related processes, but does **not** by itself prove those processes belong to James's Windows Security logon session. Correlate session evidence independently.

## Step 4 — Record evidence and publish only if supported
Capture: the original 4624 anchor with host and timestamp; host-filtered Security timeline; matching-host Sysmon events; explicit time zone/window; subject/target Logon ID handling; process GUID relationships; contradictions or missing values.

| Test | Result | Evidence path |
|---|---|---|
| Same event computer in all relevant Security rows | **Not tested** | — |
| Same computer in Security and Sysmon evidence | **Not tested** | — |
| Compatible bounded timestamps and logon lifecycle | **Not tested** | — |
| Event-specific Logon IDs and subject/target roles checked | **Not tested** | — |
| Sysmon ProcessGuid parent-child relationships reproduced | **Not retested** | Historical screenshots in full report |
| Administrative approval or denial obtained | **Unavailable** | — |

**Decision rule:** If all technical correlation checks pass, update the report with the executed query, screenshots, date, and exactly what improved. If they fail or cannot be executed, keep the existing caveat. Do not rewrite the original 11-query execution trail.

[Original investigation](../projects/splunk-siem-investigation/README.md) · [Original query log](../projects/splunk-siem-investigation/queries/investigation-queries.md)
