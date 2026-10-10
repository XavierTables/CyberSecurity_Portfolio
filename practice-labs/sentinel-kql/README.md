# Microsoft Sentinel + KQL Incident Triage — Lab Workbook

> **STATUS: NOT COMPLETED / NOT CLAIMED AS A PORTFOLIO PROJECT.** This workbook is a plan and query starter. No Sentinel workspace, log ingestion, detections or results have been verified for this account. Do not add Sentinel or KQL as hands-on work to a resume until you actually run and document the exercises.

## Goal
Demonstrate a second SIEM and a ticketed security investigation using **real authorized training telemetry** (or explicitly labelled synthetic data). Investigate a sign-in anomaly, test explanations and submit a defensible analyst handoff.

## Setup and safety
1. Use a permitted Microsoft Sentinel practice workspace with relevant data already connected. Check Azure billing/free-trial conditions; do not deploy paid resources without understanding costs.
2. Inspect the tables available to you. `SigninLogs` requires the appropriate Microsoft Entra diagnostic data; `SecurityEvent` requires Windows Security ingestion. If your workspace lacks either table, **do not claim these searches returned results**.
3. Capture a table schema/field inventory and a documented time window. Protect real names and IPs before publishing.

## KQL starter searches — proposed, not executed

**A. Count failed Entra sign-ins by user in 30-minute buckets**
```kusto
SigninLogs
| where TimeGenerated > ago(7d)
| where ResultType != "0"
| summarize failures=count(), sourceIPs=dcount(IPAddress) by UserPrincipalName, bin(TimeGenerated, 30m)
| where failures >= 5
| order by failures desc
```

**B. Inspect Windows logon and account-management events when SecurityEvent is present**
```kusto
SecurityEvent
| where TimeGenerated > ago(7d)
| where EventID in (4624, 4625, 4720, 4724, 4738)
| project TimeGenerated, Computer, EventID, Account, Activity, EventRecordId
| order by TimeGenerated asc
```

**C. Baseline sign-ins by observed IP (not a compromise verdict)**
```kusto
SigninLogs
| where TimeGenerated > ago(7d)
| summarize events=count(), distinctIPs=dcount(IPAddress) by UserPrincipalName, IPAddress
| order by UserPrincipalName asc, events desc
```

**Important:** These are examples of KQL syntax, not confirmed alert detections. Tune date windows, thresholds and field availability after inspecting the data; `ResultType` does not tell the full story of MFA and conditional access.

## Required evidence before marking the lab complete
- Workspace or authorized exercise description and data source, without exposing credentials.
- Three **executed** KQL queries with screenshots or redacted result exports.
- One candidate alert and a timeline with normalized timestamps.
- Alternative explanations and what observations favor or weaken each.
- A simulated incident ticket: asset/user, alert time, severity rationale, disposition, evidence, recommended handoff.
- A limitations section specifying missing telemetry and anything not tested.

## Fill-in incident ticket
**Case ID:** LAB-SENT-___ | **Analyst:** ___ | **Lab date:** ___  
**Alert / rule:** ___ | **Data source:** ___ | **Time zone:** ___  
**Affected identity/device:** ___ | **Severity + rationale:** ___  
**Detection query:** ___ | **Observed evidence:** ___  
**What would change my assessment:** ___ | **Disposition:** ___  
**Escalation / next owner:** ___ | **Evidence references:** ___

## Official schema reference
- [Microsoft: SigninLogs fields](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/signinlogs)
- [Microsoft: SecurityEvent fields](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/securityevent)
- [Microsoft: KQL documentation](https://learn.microsoft.com/en-us/kusto/query/)

**Publishing rule:** Move into completed projects only after you perform, verify and document the lab, and rewrite this README with actual results. Never label these sample queries as executed.
