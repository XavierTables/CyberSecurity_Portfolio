# Splunk Case Brief: Windows and VPN Activity

**Case:** LAB-SIEM-003 · **Environment:** TryHackMe training data · **Analyst:** Xavier Tables

[Portfolio](../README.md) · [Full investigation](../projects/splunk-siem-investigation/README.md) · [Executed queries](../projects/splunk-siem-investigation/queries/investigation-queries.md)

**Review status:** Retrospective screenshot review complete, October 26, 2026; unauthorized activity remains undetermined. Only screenshots are currently available for validation. No new Splunk execution or response action was performed.

## Question and scope

I investigated rare Windows account changes and unusual VPN country transitions as **two independent leads**. The supplied datasets contained 12,256 Windows events and 2,000 VPN events.

## Findings

| Lead | What I established | What remains open |
| --- | --- | --- |
| Windows | A James network logon displayed Logon ID 0x551686. Security rows showed James creating and deleting Alberto, plus group-add/remove events whose member and group details still need validation. Separate Sysmon results showed parent-child process relationships. | Whether the Security and Sysmon records share a verified computer/session; approval for the account changes |
| VPN | jsmith and kbrown each had one rare-country event. Four transitions surrounded those events, with gaps of 15–57 minutes. | Device identity, MFA outcomes, source-IP ownership, and routing/geolocation context |

## Recommended disposition

**Complete the retrospective review with evidence-limited findings.** The Windows computer/session connection cannot be established from the retained views. The VPN pattern is anomalous within the supplied data, but compromise is unconfirmed. This is completion of a lab evidence review, not a finding of benign activity or closure of a production incident.

If source data is recovered, I would first verify the Windows event computer, time window, and subject/target Logon IDs, then reproduce the process relationships. The Windows administrator would need to confirm whether the account changes were approved.

For VPN, I would ask the identity/VPN owner to review device and MFA records and validate the source-IP context. An unapproved change, corroborating malicious activity, or unexplained privileged actions would justify escalation.

The expanded logon names `Micheal.Beaven`; the Sysmon result table omits event-host and session fields. That name alone cannot connect the three Sysmon rows to the Security records. The [screenshot review](../projects/splunk-siem-investigation/evidence-review.md) records these findings and the remaining evidence boundaries.

## Supporting material

[Sample handoff and priority rationale](splunk-retrospective-triage-ticket.md) · [Windows findings and open checks](../projects/splunk-siem-investigation/README.md#windows-account-activity) · [Nine screenshots](../projects/splunk-siem-investigation/README.md#evidence)
