# Splunk Case Brief: Windows and VPN Activity

**Case:** LAB-SIEM-003 · **Environment:** TryHackMe training data · **Analyst:** Xavier Tables

[Portfolio](../README.md) · [Full investigation](../projects/splunk-siem-investigation/README.md) · [Executed queries](../projects/splunk-siem-investigation/queries/investigation-queries.md)

## Question and scope

I investigated rare Windows account changes and unusual VPN country transitions as **two independent leads**. The supplied datasets contained 12,256 Windows events and 2,000 VPN events.

## Findings

| Lead | What I established | What remains open |
| --- | --- | --- |
| Windows | A James network logon matched Logon ID 0x551686; Security records showed account/group activity involving Alberto. Separate Sysmon results showed parent-child process relationships. | Whether the Security and Sysmon records share a verified computer/session; approval for the account changes |
| VPN | jsmith and kbrown each had one rare-country event. Four transitions surrounded those events, with gaps of 15–57 minutes. | Device identity, MFA outcomes, source-IP ownership, and routing/geolocation context |

## Recommended disposition

**Continue investigation on both leads.** The recorded evidence supports further checks; it does not establish account compromise.

For Windows, I would first verify the event computer, time window, and subject/target Logon IDs, then reproduce the process relationships. The Windows administrator would need to confirm whether the account changes were approved.

For VPN, I would ask the identity/VPN owner to review device and MFA records and validate the source-IP context. An unapproved change, corroborating malicious activity, or unexplained privileged actions would justify escalation.

## Supporting material

[Sample handoff and priority rationale](splunk-retrospective-triage-ticket.md) · [Windows validation checklist](splunk-correlation-validation-plan.md) · [Nine screenshots](../projects/splunk-siem-investigation/README.md#evidence)
