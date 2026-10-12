# Windows Host/Session Validation Plan

**Status: Not executed.** I plan to run these checks when I can access the training dataset again.

The recorded Security and Sysmon searches did not consistently show or constrain the event computer. Matching accounts, timestamps, or Logon IDs gave me leads, but I still need to confirm the computer and session.

## 1. Identify the event-computer fields

Proposed search:

```spl
index=windowslogs EventID=4624 "0x551686"
| table _time EventID Hostname host Computer ComputerName TargetUserName TargetLogonId SubjectLogonId LogonType IpAddress
```

My starting logon event shows James, Event 4624, TargetLogonId `0x551686`, and `Hostname=Micheal.Beaven`. I will check which field identifies the computer in each source.

## 2. Bound the Security search

I will replace the placeholders with the values from the data and use the verified computer field:

```spl
index=windowslogs Channel=Security EventID IN (4624,4672,4627,4688,4728,4720,4724,4729,4726,4634)
"0x551686" earliest="<START_EPOCH>" latest="<END_EPOCH>"
| search Hostname="<VERIFIED_EVENT_COMPUTER>"
| sort 0 _time RecordNumber
| table _time Hostname RecordNumber EventID SubjectUserName TargetUserName SubjectLogonId TargetLogonId LogonType Message
```

I will record the time window, time zone, and audit outcome. I will check which subject or target Logon ID matched in each event, then review logon, logoff, and reboot context.

## 3. Check Sysmon ancestry and session context

Proposed search:

```spl
index=windowslogs EventID=1 User="Cybertees\\James" earliest="<START_EPOCH>" latest="<END_EPOCH>"
| table _time Hostname host Computer User Image ParentImage ProcessGuid ParentProcessGuid ProcessId ParentProcessId CommandLine
```

I will filter Sysmon to the verified computer and compare ProcessGuid and ParentProcessGuid values. I will then check whether the process records connect to the Security logon session.

## Results to record

| Check | Current status |
|---|---|
| Relevant Security rows share a verified event computer | Not tested |
| Security and Sysmon records share the verified computer | Not tested |
| Time window and logon/reboot context are compatible | Not tested |
| Subject/target Logon ID roles are checked per event | Not tested |
| Sysmon GUID relationships are reproduced | Pending; original screenshot retained |
| Administrative authorization is established | Approval data unavailable in the supplied case |

After running the checks, I will add the results, queries, timestamps, and screenshots. I will keep my original searches and explain any conflicting results or unanswered questions.

[Original report](../projects/splunk-siem-investigation/README.md) · [Original queries](../projects/splunk-siem-investigation/queries/investigation-queries.md)

[Microsoft: Logon ID scope](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4634)
