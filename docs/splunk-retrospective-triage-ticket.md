# Sample SOC Triage Ticket

I wrote this sample handoff using the evidence from my TryHackMe investigation. The next actions are recommendations.

| Field | Entry |
|---|---|
| Case | LAB-SIEM-003-TICKET |
| Analyst | Xavier Tables |
| Reason for review | Rare Windows account activity and unusual per-user VPN country labels |
| Windows entities | James, Alberto, Logon ID 0x551686 |
| VPN entities | jsmith, kbrown |
| Dataset scope | 12,256 Windows events; 2,000 VPN events |
| Alert time | No alert timestamp recorded; investigation began with dataset review |
| Event-time caveat | Historical timestamps; display time zone and complete dataset bounds not established |
| Severity | Unassigned: the lab supplied no organizational severity/impact criteria |
| Lab outcome | Further investigation warranted; compromise unconfirmed |

## Findings for handoff

**Windows:** The Security search returned authentication, account/group changes, and process-creation records matching a Logon ID. I also found Sysmon parent-child process relationships for the same account at the same displayed timestamp. The event computer and common-session connection still need validation, along with administrative approval and group permissions.

**VPN:** One rare-country event for each of two accounts produced four rapid transitions (15-57 minutes). The available data did not establish device identity, MFA outcomes, physical location, or source-IP ownership.

## Proposed next owner/actions

- Have the appropriate identity/endpoint owner validate the Windows computer/session and administrative authorization.
- Have the identity/VPN owner review device, MFA, routing, and account-owner context.
- Escalate under the team's process if changes are unapproved, corroborating malicious evidence appears, or privileged activity remains unresolved.

The two datasets represent separate leads. I linked my queries, screenshots, and remaining checks below.

## Evidence

[Report](../projects/splunk-siem-investigation/README.md) · [Queries](../projects/splunk-siem-investigation/queries/investigation-queries.md) · [Brief](splunk-incident-brief.md) · [Pending checks](splunk-correlation-validation-plan.md)
