# Sentinel and KQL: Practice Plan

**Status: Planned.** I have not run these queries yet.

## Goal and setup

I plan to investigate a sign-in anomaly in a training workspace and write a short handoff.

I will check the available tables and fields before running the queries. `SigninLogs` needs Entra sign-in data; `SecurityEvent` needs Windows Security data. Record the actual query window and time zone.

## Proposed queries

### 1. Count unsuccessful sign-ins in 30-minute buckets

```kusto
SigninLogs
| where TimeGenerated > ago(7d)
| where isnotempty(ResultType) and ResultType != "0"
| summarize failures=count(), sourceIPs=dcount(IPAddress) by UserPrincipalName, bin(TimeGenerated, 30m)
| where failures >= 5
| order by failures desc
```

Five events is a practice threshold to evaluate against the data. Inspect result codes and surrounding sign-ins before treating a count as an alert; MFA and conditional-access outcomes need additional context.

### 2. Inspect Windows authentication/account events

```kusto
SecurityEvent
| where TimeGenerated > ago(7d)
| where EventID in (4624, 4625, 4720, 4724, 4738)
| project TimeGenerated, Computer, EventID, Account, Activity, EventRecordId
| order by TimeGenerated asc
```

### 3. Baseline user/IP pairs

```kusto
SigninLogs
| where TimeGenerated > ago(7d)
| where isnotempty(UserPrincipalName) and isnotempty(IPAddress)
| summarize events=count() by UserPrincipalName, IPAddress
| order by UserPrincipalName asc, events desc
```

### 4. Count distinct source IPs per user

```kusto
SigninLogs
| where TimeGenerated > ago(7d)
| where isnotempty(UserPrincipalName) and isnotempty(IPAddress)
| summarize events=count(), distinctIPs=dcount(IPAddress) by UserPrincipalName
| order by distinctIPs desc
```

An unusual IP count is a lead for context checks, rather than a compromise verdict.

## Evidence to publish after execution

- Workspace/data-source description and verified table schema.
- Executed queries with sanitized screenshots or result exports.
- One candidate finding, a timestamped timeline, and alternative explanations.
- A sample ticket covering affected entities, evidence, severity rationale, conclusion, open questions, and recommended next owner.

Record actual findings and limitations after running the exercise.

## Official references

- [Microsoft: SigninLogs schema](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/signinlogs)
- [Microsoft: SecurityEvent schema](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/securityevent)
- [Microsoft: KQL](https://learn.microsoft.com/en-us/kusto/query/)
