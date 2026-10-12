# Splunk Investigation: Windows Account Activity and VPN Logins

**Case:** LAB-SIEM-003 · **Environment:** TryHackMe training datasets · **Tool:** Splunk/SPL

[Case brief](../../docs/splunk-incident-brief.md) · [Executed query log](queries/investigation-queries.md) · [Sample triage ticket](../../docs/splunk-retrospective-triage-ticket.md) · [Pending validation checklist](../../docs/splunk-correlation-validation-plan.md)

## Summary

I investigated two separate patterns: rare Windows account-management activity and VPN logins outside each user's usual country pattern.

The Windows searches returned authentication, account-management events, and Sysmon process activity. The VPN searches found **two rare-country events** and **four rapid country changes** around them. I documented both as leads for further investigation. The evidence did not establish account compromise.

![VPN query showing four country changes around two rare-country events](evidence/09-vpn-rapid-country-switch-detection.png)

## Data and method

| Dataset | Recorded scope | Main fields used |
|---|---|---|
| `index=windowslogs` | 12,256 events; 55 distinct Event IDs | EventID, accounts, Logon IDs, record numbers, process fields |
| `index=vpnlogs` | 2,000 events; 10 users; 12 source IPs; 6 countries | user, src_ip, src_country, _time |

I explored the supplied historical data using **All time**, profiled Event ID frequencies, followed a Logon ID, examined Sysmon process ancestry, and built per-user VPN baselines. The [query log](queries/investigation-queries.md) preserves all 11 searches in their original order.

The Windows logon screenshot shows April 15, 2022; the VPN transition screenshot shows February 26 and March 13, 2026. I used historical training data.

## Windows account activity

Rare events led me to activity involving subject account `James`, target account `Alberto`, and Logon ID `0x551686`.

- Event 4624 showed a successful James network logon: Type 3, source IP `172.90.12.11`, Kerberos, and an elevated token.
- The Security search matching the Logon ID returned account creation, group-membership changes, a password-reset attempt, account deletion, process creation, and logoff records.
- A nearby Event 4739 had different host/session context and was excluded from that account-management cluster.
- Sysmon rows for `Cybertees\James` showed `net.exe` with parent image `WmiPrvSE.exe`. The displayed GUID relationships connected `net1.exe` and `conhost.exe` to that `net.exe` process.

[Authentication record](evidence/03-james-network-logon.png) · [Security timeline](evidence/04-security-session-timeline.png) · [Sysmon results](evidence/05-sysmon-process-correlation.png)

The process relationships were visible within the Sysmon results. The Security-to-Sysmon session connection remains unresolved: the recorded searches did not consistently constrain or display the event computer and time window. A shared Logon ID alone cannot establish a session across computers or reboots. [Microsoft explains the Logon ID scope](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4634).

**Assessment:** Administrative activity requiring authorization and correlation checks. WMI-associated ancestry alone does not establish malicious execution. I still need to verify the password-reset outcome and the affected group's permissions.

## VPN country changes

I counted events by user and country, then inspected each outlier's surrounding logins.

| Account | Observed country baseline | Rapid changes |
|---|---|---|
| `jsmith` | 199 US events; 1 Japan event | US to Japan: 25 minutes; Japan to US: 15 minutes |
| `kbrown` | 199 Germany events; 1 Australia event | Germany to Australia: 17 minutes; Australia to Germany: 57 minutes |

For `jsmith`, the 199 US events used `72.14.201.12`; the single Japan-labelled event used `103.5.140.67`.

The rare-country query calculated each country's share of a user's events. The rapid-switch query sorted events by user and time, then used `streamstats current=f` to compare each event with the previous one. The four result rows represent transitions around two outliers, rather than four separate rare-country logins.

The **5% country-share** and **120-minute transition** thresholds were choices for this training dataset. Their suitability for other data was not tested.

**Assessment:** The changes warranted identity and device checks. IP geolocation, VPN/proxy routing, or shared infrastructure could explain the labels; physical travel and credential theft were not established.

## Follow-up

| Lead | Checks needed before deciding the outcome |
|---|---|
| Windows | Verify the event computer, bounded time window, and event-specific subject/target Logon IDs; reproduce the Sysmon ancestry; check administrative approval and group permissions. |
| VPN | Review account-owner confirmation, device identity, MFA outcomes, source-IP ownership, and routing/geolocation context. |

I recorded my next Windows checks in the [validation checklist](../../docs/splunk-correlation-validation-plan.md). Escalation would depend on failed authorization checks, corroborating malicious activity, or unresolved privileged activity under the team's procedures.

## What I learned

My first Windows searches were too broad to verify one host/session connection. I would establish the event computer and time window earlier next time. The VPN work also showed why a country change is a useful lead but needs identity and routing context.

## Evidence

| Screenshot | What it records |
|---|---|
| [01: Windows overview](evidence/01-windows-data-overview.png) | Dataset and available fields |
| [02: Event ID distribution](evidence/02-windows-eventid-distribution.png) | Event-frequency results |
| [03: James logon](evidence/03-james-network-logon.png) | Authentication fields |
| [04: Security timeline](evidence/04-security-session-timeline.png) | Matching Logon ID search ordered by RecordNumber |
| [05: Sysmon](evidence/05-sysmon-process-correlation.png) | Process fields and GUID relationships |
| [06: VPN overview](evidence/06-vpn-data-overview.png) | VPN dataset scope |
| [07: Country baseline](evidence/07-vpn-country-baseline.png) | Per-user country counts |
| [08: jsmith baseline](evidence/08-jsmith-ip-baseline.png) | Source-IP and country counts |
| [09: Country transitions](evidence/09-vpn-rapid-country-switch-detection.png) | Four transition rows and time gaps |

I used the environment and datasets supplied by TryHackMe. My work covered investigation and follow-up recommendations.

## References

- [Microsoft: Event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Microsoft: Event 4724](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4724)
- [Microsoft: Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Splunk: streamstats](https://help.splunk.com/en/splunk-enterprise/search/spl-search-reference/9.4/search-commands/streamstats)
