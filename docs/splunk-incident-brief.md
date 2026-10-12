# Splunk Case Brief: Windows and VPN Logs

**Case:** LAB-SIEM-003 · **Environment:** TryHackMe training data · **Analyst:** Xavier Tables

## Question

What did the unusual Windows account activity and VPN logins tell me, and what should I check next?

## Evidence and assessment

| Lead | Recorded evidence | Assessment |
|---|---|---|
| Windows | A James network logon matching Logon ID 0x551686; account/group changes involving Alberto; Sysmon process ancestry including WmiPrvSE.exe, net.exe, conhost.exe, and net1.exe | Administrative activity requiring authorization checks. I still need to confirm whether the Security and Sysmon events came from the same computer and session. |
| VPN | jsmith and kbrown each had one rare-country event; the transition query returned four country changes with gaps of 15-57 minutes | Unusual login patterns requiring device, MFA, routing, and geolocation checks. |

The supplied datasets contained 12,256 Windows events and 2,000 VPN events. These were separate investigative leads; the analysis did not establish a connection between them.

## Next checks

- **Windows:** Verify event computer, time window, subject/target Logon IDs, process ancestry, administrative approval, and affected group permissions.
- **VPN:** Review account-owner confirmation, device identity, MFA results, source-IP ownership, and routing/geolocation context.

**Conclusion:** Further investigation warranted; compromise unconfirmed. Escalation would depend on unapproved changes, corroborating malicious activity, or unresolved privileged activity under the team's procedures.

## Case material

[Full report](../projects/splunk-siem-investigation/README.md) · [11 executed searches](../projects/splunk-siem-investigation/queries/investigation-queries.md) · [Sample handoff ticket](splunk-retrospective-triage-ticket.md) · [Pending validation checklist](splunk-correlation-validation-plan.md)

I saved nine screenshots with the report. My next step is to validate the Windows host/session connection.
