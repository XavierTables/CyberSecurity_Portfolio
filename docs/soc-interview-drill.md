# SOC Interview Prep — Personal Study Notes

*Practice questions for explaining my documented training investigations. This is a study aid, **not** a completed investigation or a separate employer-facing project.*

## Explain my strongest Splunk decisions

| Question I should be ready for | Evidence I should open |
| --- | --- |
| **Why look at the Windows account events?** | [Event ID distribution](../projects/splunk-siem-investigation/evidence/02-windows-eventid-distribution.png): uncommon account-management events gave me a lead, not a verdict. |
| **What could the Logon ID prove?** | [Security timeline](../projects/splunk-siem-investigation/evidence/04-security-session-timeline.png): useful within the right computer/logon context, but insufficient to connect different hosts or prove a common Sysmon session. |
| **What did the process data show?** | [Sysmon result](../projects/splunk-siem-investigation/evidence/05-sysmon-process-correlation.png): parent/child ProcessGuid relationships among the recorded processes. |
| **Why did I use a 5% rarity filter?** | [SPL query 09](../projects/splunk-siem-investigation/queries/investigation-queries.md#09-rare-country-search): it flagged one-in-200 country events (0.5%), but wasn't validated against other users or environments. |
| **Why are there four rapid changes but two outliers?** | [SPL query 11](../projects/splunk-siem-investigation/queries/investigation-queries.md#11-rapid-country-changes): each rare-country login had a transition into and back out of the unusual country label. |
| **What is the investigation's biggest limitation?** | [Host/session validation plan](splunk-correlation-validation-plan.md): missing verified computer and time-window correlation; VPN device and MFA checks were unavailable. |

## Practice the reasoning, not a memorized script

For each question, explain **what I saw → why I checked it → what the result supports → what I still cannot conclude**. If the screenshot or original query does not support my answer, revise the answer instead of guessing.

I should also be able to explain two other training cases:

- **[Windows account events](../projects/windows-security-log-triage/README.md):** Why did Event 4672 initially look important, and how did SYSTEM / services.exe change the interpretation?
- **[Nessus baseline](../projects/nessus-vulnerability-assessment/README.md):** Why doesn't `Auth: Pass` or a Critical count prove that a particular vulnerability is applicable or remediated?

## Handoff questions

Can I clearly state the affected entity, time window, logged observations, severity rationale (if available), next evidence needed, and the correct owner? Use the [sample SOC handoff](splunk-retrospective-triage-ticket.md) as a format example, not as proof of a live incident.

[Full Splunk report](../projects/splunk-siem-investigation/README.md) · [Original searches](../projects/splunk-siem-investigation/queries/investigation-queries.md)
