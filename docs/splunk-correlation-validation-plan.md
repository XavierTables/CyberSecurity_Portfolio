# Windows Host/Session Validation Plan

**Status: Not executed.** This checklist would extend the original Splunk case if the training dataset becomes available again.

The recorded Security and Sysmon searches did not consistently show or constrain the event computer. A matching account, second, or Logon ID provides a lead; it does not establish a common session across sources.

## 1. Identify the event-computer fields

Proposed search:

```spl
index=windowslogs EventID=4624 "0x551686"
| table _time EventID Hostname host Computer ComputerName TargetUserName TargetLogonId SubjectLogonId LogonType IpAddress
```

The original anchor displays James, Event 4624, TargetLogonId `0x551686`, and `Hostname=Micheal.Beaven`. Inspect actual field values to establish which field represents the event computer. Check that independently for Security and Sysmon.

## 2. Bound the Security search

Replace the placeholders with measured values and adapt `Hostname` to the verified event-computer field:

```spl
index=windowslogs Channel=Security EventID IN (4624,4672,4627,4688,4728,4720,4724,4729,4726,4634)
"0x551686" earliest="<START_EPOCH>" latest="<END_EPOCH>"
| search Hostname="<VERIFIED_EVENT_COMPUTER>"
| sort 0 _time RecordNumber
| table _time Hostname RecordNumber EventID SubjectUserName TargetUserName SubjectLogonId TargetLogonId LogonType Message
```

Record the time zone/window and audit outcome where available. Inspect the event-specific subject and target Logon ID roles; the free-text match alone does not establish which field matched. Check logon/logoff and reboot context before treating rows as one session.

## 3. Check Sysmon ancestry and session context

Proposed search:

```spl
index=windowslogs EventID=1 User="Cybertees\\James" earliest="<START_EPOCH>" latest="<END_EPOCH>"
| table _time Hostname host Computer User Image ParentImage ProcessGuid ParentProcessGuid ProcessId ParentProcessId CommandLine
```

Constrain the actual Sysmon event-computer field to the verified computer. Compare ProcessGuid/ParentProcessGuid values for ancestry. Establish the Security-to-Sysmon session connection separately using available session/process fields and event context.

## Results to record

| Check | Current status |
|---|---|
| Relevant Security rows share a verified event computer | Not tested |
| Security and Sysmon records share the verified computer | Not tested |
| Time window and logon/reboot context are compatible | Not tested |
| Subject/target Logon ID roles are checked per event | Not tested |
| Sysmon GUID relationships are reproduced | Pending; original screenshot retained |
| Administrative authorization is established | Approval data unavailable in the supplied case |

Add actual results, executed queries, date/time zone, and sanitized screenshots only after running the checks. Retain the original query trail and document any contradictions or remaining gaps.

[Original report](../projects/splunk-siem-investigation/README.md) · [Original queries](../projects/splunk-siem-investigation/queries/investigation-queries.md)

[Microsoft: Logon ID scope](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4634)
