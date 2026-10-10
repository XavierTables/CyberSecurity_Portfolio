# SOC Analyst I — Technical Interview Drill

**Use with the [completed Splunk case](../projects/splunk-siem-investigation/README.md).** Do not memorize a polished script that exceeds what your evidence proves. Practice answering each item aloud in 60–120 seconds.

| Hiring-manager question | Minimum credible answer |
|---|---|
| What triggered your Splunk investigation? | Account-management events were rare; VPN accounts had unusual country baselines. Explain the searches that found them. |
| Did you confirm account compromise? | No. Show which facts are observable and which authorization/identity details are missing. |
| Are the four VPN transitions four compromises? | No. Four sequential country-label changes surrounded **two** rare-country events, and geolocation is not verified physical location. |
| What is the biggest flaw in your Windows correlation? | Recorded session searches were not consistently host/time scoped; same logon ID alone cannot establish one host/session. |
| Why does the ProcessGuid matter? | It supports identifying Sysmon process instances and parent-child lineage, but is not proof of the Windows logon session without additional correlation. |
| What would cause you to escalate? | Unapproved account changes, convincing corroborating endpoint/identity evidence, or unresolved privileged activity after documented checks. |
| What does Nessus Auth: Pass tell you? | Authentication succeeded as reported, not that every credentialed check had complete coverage. |
| Would you close the VPN finding? | Not solely on the country label; validate device, MFA, routing/proxy, IP ownership and baseline first. |
| What makes a usable SOC ticket? | Alert context, affected entities, timestamps/time zone, query, evidence, severity rationale, disposition and next owner. |
| What would you do on a real shift that you have not done in labs? | Follow a queue and SLAs, document and escalate according to playbooks, coordinate handoffs, handle approved containment steps. Admit you have not worked a production SOC. |

## Score yourself
For each answer: **0** = can't answer; **1** = jargon only; **2** = clear but no evidence; **3** = cites the actual query or event and names the limitation. Target **25+/30** before an interview. These are practice criteria, not a hiring predictor.

## STAR story framework
**Situation:** Authorized SIEM exercise and two anomalous patterns.  
**Task:** Determine what the telemetry actually supported.  
**Action:** Profile Event IDs, pivot using a logon identifier, examine Sysmon process relationships, and baseline VPN users.  
**Result:** Documented suspicious findings **without falsely claiming compromise**; identified host/session and identity validation required before a production disposition.

If asked to reproduce the correlations, explain the host/time scoping gap first and point to the [proposed revalidation plan](splunk-correlation-validation-plan.md).
