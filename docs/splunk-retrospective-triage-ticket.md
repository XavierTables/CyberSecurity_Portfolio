# SOC Triage Ticket — Retrospective Training Case

> **Training exercise, written after the investigation.** I organized my existing TryHackMe findings in a ticket format to practice handoffs. This was not a production ticket, and no real-world escalation or containment occurred.

| Field | Entry |
|---|---|
| Case ID | LAB-SIEM-003-TICKET |
| Source | Authorized TryHackMe Splunk training datasets |
| Analyst | Xavier Tables |
| Detection / reason for review | Rare Windows account-management activity; unusual per-user VPN country labels |
| Entities | Lab accounts `James`, `Alberto`, `jsmith`, `kbrown` |
| Windows source | `index=windowslogs` — 12,256 events in supplied dataset |
| VPN source | `index=vpnlogs` — 2,000 events in supplied dataset |
| Alert timestamp | Not recorded as an actual production alert |
| Exact event time zone | Not established in published screenshots |
| Severity | **Not assigned** — no organizational classification policy or impact context available |
| Case status | **Pending further validation** (hypothetical production equivalent) |
| Final lab disposition | Suspicious activity; compromise unconfirmed |

## Investigation chronology (supported by documented work)
1. Surveyed Windows dataset and profiled Event ID frequency, isolating rare account-management events.
2. Examined network authentication and account activity associated with Logon ID `0x551686`, with Security/Sysmon correlations requiring additional host/time scoping.
3. Reviewed Sysmon process ancestry, including `WmiPrvSE.exe`, `net.exe`, `conhost.exe` and `net1.exe`.
4. Baselined VPN events by account/country: one rare-country event for `jsmith`, one for `kbrown`.
5. Used `streamstats` to identify four quick country-label changes around the two outlier events (15–57 minutes).
6. Documented limits and validation needs rather than treating alerts as confirmed compromise.

## Observed facts vs. unresolved questions
**Supported:** Documented searches, matching activity clusters in screenshots, per-user country baselines, process GUID ancestry and transition time gaps.

**Not established:** Same-computer/same-session linkage across all Windows/Sysmon records, administrative change approval, affected security-group privilege, authenticated devices, MFA results, actual user geography, compromise or business impact.

## Proposed Tier-1 next actions (not carried out)
- **Windows:** Verify host/session/time correlation, check change ticket or administrator approval, identify group permissions, review available endpoint and identity logs.
- **VPN:** Validate user/device, MFA, routing/proxy ownership, IP geolocation and adjacent post-login activity.
- **Escalation trigger:** Failed authorization validation, confirmed unauthorized account modification, or corroborating malicious identity/endpoint events.
- **Handoff:** Include original queries, nine screenshots, event-time and timezone caveats, alternative explanations and unanswered questions.

## Evidence
- [Full Splunk investigation](../projects/splunk-siem-investigation/README.md)
- [Executed SPL query log](../projects/splunk-siem-investigation/queries/investigation-queries.md)
- [Concise case brief](splunk-incident-brief.md)
- [Proposed revalidation plan — unexecuted](splunk-correlation-validation-plan.md)

This ticket format is a documentation exercise based on the completed lab. It doesn't represent experience working a live alert queue or meeting production SLAs.
