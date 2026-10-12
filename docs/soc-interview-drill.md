# Portfolio Interview Practice

These are the questions I use to practice explaining my [Splunk investigation](../projects/splunk-siem-investigation/README.md). I check my answers against the query log and screenshots.

| Question | Evidence to explain |
|---|---|
| What started the investigation? | Rare account-management Event IDs and unusual per-user VPN country counts. |
| What did the VPN search find? | Two rare-country events with four surrounding transitions, at 15-57 minute gaps. |
| How did the transition query work? | Sort by user/time; use streamstats current=f to keep prior values; compare countries and calculate the time gap. |
| Did the data establish compromise? | No. I still need authorization, identity, device, and routing checks. |
| What limits the Windows correlation? | The recorded searches did not consistently constrain/show the computer or time window. A shared Logon ID alone is insufficient. |
| What did the process GUIDs support? | Parent-child relationships in Sysmon; the common Security/Sysmon session still needs validation. |
| What would you check next? | The pending host/session checklist, administrative approval, group permissions, and VPN identity/device context. |
| What would prompt escalation? | Unapproved changes, corroborating malicious evidence, or unresolved privileged activity under the team's process. |
| What does Nessus Auth: Pass establish? | The scanner reported successful authentication. I still need to check scan coverage and whether individual findings apply. |
| What belongs in a handoff? | Trigger, affected entities, time window, queries, evidence, conclusion, open questions, and next owner. |

## Practice method

1. I pick a query and explain its input, each command, the result, and what I would check next.
2. I open the screenshot and identify the fields supporting my explanation.
3. I distinguish the work I completed from my next steps.
4. I review the documentation or rerun the exercise if I cannot explain a query or finding.

## Project story

**Situation:** Two unusual patterns in authorized training logs.

**Task:** Determine what the available evidence supported.

**Actions:** Profiled Event IDs, examined a Logon ID and process relationships, and built VPN baselines and a transition query.

**Result:** Documented follow-up leads and identified the host/session and identity checks still needed.
