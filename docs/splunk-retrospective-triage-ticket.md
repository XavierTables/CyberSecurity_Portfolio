# Sample SOC Handoff: Two Independent Leads

**Case:** LAB-SIEM-003-TICKET · **Analyst:** Xavier Tables · **Status:** Follow-up recommended

This is a retrospective lab handoff based on my recorded searches. The priorities and owners below are illustrative recommendations.

[Case brief](splunk-incident-brief.md) · [Investigation](../projects/splunk-siem-investigation/README.md) · [Queries](../projects/splunk-siem-investigation/queries/investigation-queries.md)

## Windows account activity

| Field | Handoff |
| --- | --- |
| Entities | James; Alberto in the account-creation/deletion rows; Logon ID `0x551686`; group member/group identity still unverified |
| Evidence | Security authentication/account/group records; a separate Sysmon process tree involving `WmiPrvSE.exe`, `net.exe`, `net1.exe`, and `conhost.exe` |
| Provisional priority | **Medium:** account/privilege activity warrants review; authorization and impact are unresolved |
| First action | Verify the event computer, time window, and subject/target Logon ID for each Security record; check timestamp parsing before comparing sources |
| Proposed owners | Investigating analyst for correlation; Windows administrator for change approval and affected group permissions |
| Next decision | Escalate if the activity is unapproved, malicious evidence corroborates it, or privileged actions remain unexplained |
| Evidence links | [Logon](../projects/splunk-siem-investigation/evidence/03-james-network-logon.png), [Security rows](../projects/splunk-siem-investigation/evidence/04-security-session-timeline.png), [Sysmon](../projects/splunk-siem-investigation/evidence/05-sysmon-process-correlation.png) |

The parent-child Sysmon relationships do not yet establish a common session with the Security records. The separate group-change rows do not establish Alberto as the group member. Event 4739 also requires an expanded record before its relationship to this lead can be decided. The [investigation report](../projects/splunk-siem-investigation/README.md#windows-account-activity) records the remaining computer, time-window, and session checks.

## VPN country changes

| Field | Handoff |
| --- | --- |
| Entities | jsmith; kbrown |
| Evidence | One rare-country event per account; four surrounding transitions with 15–57-minute gaps |
| Provisional priority | **Medium:** unusual account activity merits identity checks; unauthorized access is unconfirmed |
| First action | Review device identity and MFA results; verify source-IP ownership and possible VPN/proxy routing |
| Proposed owner | Identity/VPN administrator, with the investigating analyst reviewing the results |
| Next decision | Escalate if the owner denies the activity or device, MFA, or network evidence supports account abuse; document a validated benign explanation if established |
| Evidence links | [Country baseline](../projects/splunk-siem-investigation/evidence/07-vpn-country-baseline.png), [IP baseline](../projects/splunk-siem-investigation/evidence/08-jsmith-ip-baseline.png), [Transitions](../projects/splunk-siem-investigation/evidence/09-vpn-rapid-country-switch-detection.png) |

## Illustrative priority criteria

- **High:** corroborated unauthorized access, active malicious activity, or material impact requiring urgent response.
- **Medium:** unusual authentication or administrative activity with authorization or impact still unresolved.
- **Low:** a validated expected explanation with no remaining suspicious evidence within the case scope.

These criteria explain the sample priorities. A production team would apply its own impact, asset, and response requirements.

## Timing and scope

The work began with dataset review, so there is no recorded alert-receipt time or response SLA. Searches used All time; complete dataset bounds and display time zone were not captured. Windows records include a displayed Time/EventTime mismatch that needs validation. The VPN screenshot records February 26 and March 13, 2026 transitions.

The two leads are separate. No containment, remediation, owner confirmation, or case closure was performed in this exercise.
