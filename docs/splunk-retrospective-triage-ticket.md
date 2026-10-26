# Sample SOC Handoff: Two Independent Leads

**Case:** LAB-SIEM-003-TICKET · **Analyst:** Xavier Tables · **Status:** Retrospective review complete; unauthorized activity undetermined

This is a retrospective lab handoff based on my recorded searches and nine retained screenshots. The October 26, 2026 review found no available source-log export or live lab results to settle the remaining checks; only screenshots are currently available. The priorities and owners below are illustrative recommendations for follow-up if the required evidence is recovered.

[Case brief](splunk-incident-brief.md) · [Investigation](../projects/splunk-siem-investigation/README.md) · [Queries](../projects/splunk-siem-investigation/queries/investigation-queries.md)

## Windows account activity

**Current finding:** Account/logon observations and separate Sysmon ancestry are supported. A common computer/session, password-reset outcome, group member/group identity, and administrative approval are not established. The expanded 4624 names `Micheal.Beaven`, but the Sysmon table omits event-host and session fields.

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

**Current finding:** Two rare-country events and four surrounding transitions are supported. Account misuse, actual travel, or a benign routing explanation cannot be confirmed from the retained fields.

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

The two leads are separate. The retrospective evidence review is complete, with the limits documented in the [screenshot review](../projects/splunk-siem-investigation/evidence-review.md). No containment, remediation, owner confirmation, new Splunk execution, or production incident closure was performed. Unavailable evidence is not treated as proof that the activity was authorized or benign.
