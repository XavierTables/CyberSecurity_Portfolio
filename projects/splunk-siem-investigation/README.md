# Splunk Investigation: Windows Account Activity and VPN Logins

**Case:** LAB-SIEM-003 · **Environment:** TryHackMe training datasets · **Tool:** Splunk/SPL

[Portfolio](../../README.md) · [Case brief](../../docs/splunk-incident-brief.md) · [Executed queries](queries/investigation-queries.md) · [Sample handoff](../../docs/splunk-retrospective-triage-ticket.md)

## Summary

I followed two independent leads: rare Windows account-management activity and VPN logins outside each user's usual country pattern. The Windows work identified account events and Sysmon process relationships. The VPN searches found **two rare-country events** and **four rapid transitions** around them.

**Disposition:** Further investigation recommended. Windows host/session validation and identity context remain open.

## Data and method

| Dataset | Recorded scope | Fields used |
| --- | --- | --- |
| `windowslogs` | 12,256 events; 55 Event IDs | Accounts, Logon IDs, record numbers, process fields |
| `vpnlogs` | 2,000 events; 10 users; 12 source IPs; 6 countries | user, src_ip, src_country, _time |

I used All time on the supplied historical datasets. My [query log](queries/investigation-queries.md) preserves the **11 searches** in their original order.

**Time handling:** Complete dataset bounds and Splunk's display time zone were not recorded. The Windows logon screenshot shows April 15, 2022; the VPN transitions show February 26 and March 13, 2026. One Windows overview record displays July 14, 2022 in Time and April 15, 2022 in EventTime. Timestamp parsing needs validation before those fields can be used interchangeably.

## Windows account activity

I started with Event ID counts. Account-management events 4720, 4724, 4726, 4728, 4729, and 4739 each appeared once, which gave me a smaller set to inspect.

My notes identified subject account **James**, target account **Alberto**, and Logon ID **`0x551686`**. I then searched for the matching network logon and examined process records:

| Check | Recorded result |
| --- | --- |
| Event 4624 matching the Logon ID | James; Type 3; Kerberos; source IP `172.90.12.11`; elevated token |
| Security events matching the Logon ID | 12 rows covering authentication, process creation, account/group changes, a password-reset attempt, and logoff |
| Sysmon process relationships | `net.exe` with parent `WmiPrvSE.exe`; `net1.exe` and `conhost.exe` with parent GUIDs matching `net.exe` |

[Authentication record](evidence/03-james-network-logon.png) · [Security timeline](evidence/04-security-session-timeline.png) · [Sysmon results](evidence/05-sysmon-process-correlation.png)

I excluded a nearby Event 4739 from the broader account-management search because its host/session context differed.

**Where my interpretation changed:** The matching account and Logon ID gave me a lead, but my searches did not consistently show or constrain the computer and time window. I could explain the Sysmon ancestry without proving that those processes belonged to the Security logon session. A Logon ID must be interpreted in the correct computer/logon context; [Microsoft documents its scope](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4634).

My next steps are to verify the event computer and event-specific subject/target IDs, reproduce the process relationships, and check the password-reset outcome, group permissions, and administrative approval. The [validation checklist](../../docs/splunk-correlation-validation-plan.md) contains the proposed searches.

## VPN country changes

I counted events by user and country, then inspected the outliers and their surrounding logins.

| Account | Baseline | Transitions around the outlier |
| --- | --- | --- |
| jsmith | 199 US events; 1 Japan event | US to Japan: 25 minutes; Japan to US: 15 minutes |
| kbrown | 199 Germany events; 1 Australia event | Germany to Australia: 17 minutes; Australia to Germany: 57 minutes |

For jsmith, 199 US events used **`72.14.201.12`**; the Japan-labelled event used **`103.5.140.67`**.

The rarity query calculated each country's share of a user's events. I used a **5%** exploratory cutoff; both outliers were **0.5%** (1 of 200). The transition query sorted events by user and time and compared each event with the preceding login, using **120 minutes** as the inspection window.

<a href="evidence/09-vpn-rapid-country-switch-detection.png"><img src="evidence/09-vpn-rapid-country-switch-detection.png" width="640" alt="Four VPN country transitions around two rare-country login events"></a>

*Open the image for the original query and results.*

The four rows represent transitions into and out of two outlier events. My thresholds were lab choices and were not tested against other datasets or normal travel/VPN behavior.

**Assessment:** The pattern warrants device, MFA, source-IP, and account-owner checks. VPN/proxy routing and geolocation errors are possible explanations; physical travel or credential theft cannot be established from these fields alone.

## Recommended handoff

I would continue both leads separately:

- **Windows:** Validate the host/session connection first, then obtain change approval and group-permission context.
- **VPN:** Have the identity/VPN owner review devices, MFA, source IPs, and routing.

My [sample handoff](../../docs/splunk-retrospective-triage-ticket.md) states proposed owners, priority criteria, and escalation conditions.

## Evidence

| Screenshot | What it records |
| --- | --- |
| [01: Windows overview](evidence/01-windows-data-overview.png) | 12,256 events, available fields, and an expanded Sysmon Event 10 record |
| [02: Event ID distribution](evidence/02-windows-eventid-distribution.png) | 55 Event IDs, including six selected IDs with one occurrence each |
| [03: James logon](evidence/03-james-network-logon.png) | Event 4624: Type 3, Kerberos, source IP `172.90.12.11`, Logon ID `0x551686` |
| [04: Security timeline](evidence/04-security-session-timeline.png) | 12 matching Security rows ordered by RecordNumber; EventTime is identical across the displayed rows |
| [05: Sysmon](evidence/05-sysmon-process-correlation.png) | Three process rows and their parent/child `ProcessGuid` relationships |
| [06: VPN overview](evidence/06-vpn-data-overview.png) | 2,000 events, 10 users, 12 source IPs, and six country values |
| [07: Country baseline](evidence/07-vpn-country-baseline.png) | jsmith: 199 US/one JP event; kbrown: 199 DE/one AU event |
| [08: jsmith IP baseline](evidence/08-jsmith-ip-baseline.png) | Two source-IP/country rows, counts, and first/last observed times |
| [09: Country transitions](evidence/09-vpn-rapid-country-switch-detection.png) | Four transitions with 25-, 15-, 17-, and 57-minute gaps |

## What I learned

Broad searches helped me find leads. Establishing a Windows session requires tighter computer, time, and subject/target ID checks. The VPN results also taught me to distinguish a rare pattern from an unauthorized login.

## References

- [Microsoft: Event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4724](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4724)
- [Microsoft: Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Splunk: streamstats](https://help.splunk.com/en/splunk-enterprise/search/spl-search-reference/9.4/search-commands/streamstats)
