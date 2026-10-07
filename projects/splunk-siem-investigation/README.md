# Splunk SIEM Investigation: Windows Session Correlation & VPN Geographic Anomaly Detection

![Focus](https://img.shields.io/badge/Focus-SIEM%20Investigation-555?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Splunk-555?style=flat-square)
![Query Language](https://img.shields.io/badge/Query%20Language-SPL-555?style=flat-square)
![Environment](https://img.shields.io/badge/Environment-Authorized%20TryHackMe%20Lab-555?style=flat-square)

## Executive Summary

I used Splunk and SPL in an authorized TryHackMe training environment to investigate two security-relevant activity patterns: correlated Windows account-management activity and anomalous VPN authentication behavior.

The Windows investigation began with 12,256 events. I profiled the available Event IDs, isolated rare account-management activity, and correlated a successful network logon for `James` with Windows Security and Sysmon telemetry. The shared Logon ID `0x551686` connected the authenticated session to process creation and subsequent activity involving the `Alberto` account. Sysmon independently corroborated a process relationship involving `WmiPrvSE.exe`, `net.exe`, `conhost.exe`, and `net1.exe`.

The VPN investigation analyzed 2,000 authentication events. Behavioral baselining identified two users with rare-country logins. I selected `jsmith` for deeper review because 199 of 200 observed events came from one US source IP while a single event originated from a unique Japanese IP. Normal US activity occurred 25 minutes before and 15 minutes after the Japanese login.

Neither investigation provided enough evidence to confirm compromise. Both demonstrated activity that warranted additional validation in a production SOC.

**Final disposition:** Suspicious activity identified in both datasets; additional authorization, identity, and endpoint validation would be required before classifying either case as a confirmed security incident.

---

## Project Overview

| Field | Details |
|---|---|
| Environment | Authorized TryHackMe training environment |
| SIEM platform | Splunk |
| Query language | SPL |
| Windows dataset | `index=windowslogs` |
| Windows events | 12,256 |
| VPN dataset | `index=vpnlogs` |
| VPN events | 2,000 |
| Primary telemetry | Windows Security, Sysmon, VPN authentication |
| Investigation focus | Session correlation, process analysis, behavioral baselining, geographic anomaly detection |
| Final disposition | Suspicious activity requiring additional validation |

---

## Investigation Objectives

This project was designed to answer two primary questions:

### Windows

**Could the rare Windows account-management activity be connected to a specific authenticated session and supporting process telemetry?**

### VPN

**Did any VPN authentication activity significantly deviate from individual users' observed geographic behavior?**

I did not want to start with the assumption that either dataset showed an attack. I followed the evidence, correlated related events, tested different explanations, and documented where the telemetry was strong and where it still left questions.

---

## Skills Demonstrated

- Splunk Search & Reporting
- SPL filtering and field selection
- Event-frequency analysis
- Windows Event ID interpretation
- Logon ID correlation
- Windows Security session reconstruction
- Sysmon process analysis
- Cross-source event correlation
- Parent/child process relationships
- Behavioral baselining
- VPN authentication analysis
- Geographic anomaly detection
- `stats`, `eventstats`, `eval`, `where`, and `streamstats`
- Chronological event analysis
- Evidence-based incident triage
- Investigation documentation
- Limitations and escalation planning

The primary SPL searches used during the investigation are documented in [the SPL Investigation Query Log](./queries/investigation-queries.md).

---

# Part 1 — Windows Investigation

## Dataset Exploration

I began with the complete Windows dataset rather than immediately searching for a specific security event.

```spl
index=windowslogs
```

The dataset contained **12,256 events** and exposed security-relevant fields including Event IDs, accounts, hosts, processes, network information, Windows Security telemetry, and Sysmon telemetry.

![Windows dataset overview](evidence/01-windows-data-overview.png)

*Figure 1. Broad Windows dataset search used to establish the available telemetry before narrowing the investigation.*

---

## Event ID Profiling

I counted events by Event ID to identify both common and unusual activity.

```spl
index=windowslogs
| stats count by EventID
| sort - count
```

The dataset contained **55 distinct Event IDs**.

Several account-management events appeared only once, including:

- 4720 — user account created
- 4724 — password-reset attempt
- 4726 — user account deleted
- 4728 — member added to a security-enabled global group
- 4729 — member removed from a security-enabled global group
- 4739 — domain policy changed

I treated the rare events as leads for deeper review, not as proof of malicious behavior.

![Windows Event ID distribution](evidence/02-windows-eventid-distribution.png)

*Figure 2. Event-frequency analysis used to identify low-frequency account-management activity for deeper review.*

---

# Finding 1 — Correlated Windows Account-Management Activity

## Initial Account-Management Cluster

Reviewing the rare account-management activity revealed a cluster involving:

- subject account `James`
- target account `Alberto`
- shared Logon ID `0x551686`
- host `Micheal.Beaven`

The related activity included security-enabled global group membership changes, creation of the `Alberto` account, a password-reset attempt against `Alberto`, removal from the security-enabled global group, and deletion of the `Alberto` account.

A nearby Event 4739 password-policy change used different host and session context, so I did not automatically include it in the same activity chain.

---

## James Network Authentication

I searched for Event ID 4624 using the Logon ID observed in the account-management events.

The resulting event showed:

| Field | Observed Value |
|---|---|
| Event ID | 4624 |
| Account | `James` |
| Domain | `Cybertees.LOCAL` |
| Logon Type | 3 |
| Source IP | `172.90.12.11` |
| Authentication package | Kerberos |
| Target Logon ID | `0x551686` |
| Elevated token | Yes |

Logon Type 3 showed that this was a network logon. The matching Logon ID gave me the session anchor I needed to connect James's authentication to the later account-management activity.

![James successful network logon](evidence/03-james-network-logon.png)

*Figure 3. Successful network authentication associated with Logon ID `0x551686`.*

---

## Security Session Reconstruction

I reconstructed the relevant Windows Security events using the shared session identifier.

Because the relevant events displayed the same second, I used Windows Security `RecordNumber` values to establish the clearest available order within that log channel.

The observed sequence included:

- Event 4672 — special privileges associated with the session
- Event 4624 — successful James network authentication
- Event 4627 — group membership information
- Event 4688 — process creation
- Event 4728 — member added to a security-enabled global group
- Event 4720 — `Alberto` account created
- Event 4724 — password-reset attempt against `Alberto`
- Event 4729 — member removed from the security-enabled global group
- Event 4726 — `Alberto` account deleted
- Event 4634 — James session logged off

The Event 4724 record was marked as an audit failure. I therefore interpreted it as a **password-reset attempt**, not proof that the password was successfully changed.

![Windows Security session timeline](evidence/04-security-session-timeline.png)

*Figure 4. Windows Security activity ordered by RecordNumber and associated with Logon ID `0x551686`.*

---

## Cross-Source Process Correlation

Windows Security Event ID 4688 showed process-creation activity associated with the session.

I then used Sysmon Event ID 1 to independently examine the process relationships.

Sysmon showed:

```text
WmiPrvSE.exe
    |
    +-- net.exe
          |
          +-- conhost.exe
          |
          +-- net1.exe
```

The ProcessGuid and ParentProcessGuid values supported the parent-child relationships.

![Sysmon process correlation](evidence/05-sysmon-process-correlation.png)

*Figure 5. Sysmon process telemetry corroborating the process relationship under `Cybertees\James`.*

### Analysis

Seeing the same process activity in Sysmon gave me more confidence that I was following the same authenticated session rather than looking at unrelated events.

At that point I could connect the network logon, elevated session context, WMI-associated process ancestry, `net.exe` and `net1.exe` execution, account creation, group membership changes, the failed password-reset attempt, account deletion, and logoff into one security-relevant sequence.

What I still could not answer was whether James was supposed to be doing it. `WmiPrvSE.exe` in the process ancestry supports WMI-associated execution, but it does not prove malicious remote WMI by itself. I also could not confirm from the supplied data that the security-enabled global group was privileged.

### Windows Finding Disposition

**Suspicious administrative activity — authorization unverified.**

The session would warrant escalation or authorization validation in a production SOC. The supplied telemetry does not provide enough evidence to classify the activity as confirmed malicious behavior or account compromise.

---

# Part 2 — VPN Authentication Investigation

## VPN Dataset Overview

I next examined the VPN dataset.

```spl
index=vpnlogs
```

The dataset contained **2,000 events**, **10 users**, **12 source IP addresses**, and **6 source countries**. Useful fields included `user`, `src_ip`, `src_country`, and `_time`.

![VPN dataset overview](evidence/06-vpn-data-overview.png)

*Figure 6. Initial VPN dataset review before behavioral analysis.*

---

# Finding 2 — VPN Geographic Authentication Anomaly

## Country Baseline

I grouped VPN activity by user and source country.

```spl
index=vpnlogs
| stats count by user src_country
| sort user - count
```

Most users displayed consistent geographic behavior.

Two accounts contained one rare-country event:

| User | Primary Country | Count | Rare Country | Count |
|---|---|---:|---|---:|
| `jsmith` | US | 199 | JP | 1 |
| `kbrown` | DE | 199 | AU | 1 |

![VPN geographic baseline](evidence/07-vpn-country-baseline.png)

*Figure 7. Per-user VPN country distribution showing two geographic outliers.*

I treated the rare country as a reason to investigate further, not as proof that the account was compromised.

---

## jsmith Behavioral Baseline

I selected `jsmith` for deeper investigation.

The account showed:

| Source IP | Country | Count |
|---|---|---:|
| `72.14.201.12` | US | 199 |
| `103.5.140.67` | Japan | 1 |

The Japanese source appeared exactly once.

![jsmith IP baseline](evidence/08-jsmith-ip-baseline.png)

*Figure 8. Source-IP and country baseline for `jsmith`.*

This established an unusually stable observed pattern: **199 of 200 VPN events came from one US source IP.**

---

## Time-of-Day Validation

I compared the rare-country event against the user's observed login-hour behavior.

The Japanese event happened at an otherwise normal login hour for `jsmith`. That mattered because one part of the event looked unusual while another part did not.

I kept that negative finding in the analysis instead of describing the login as suspicious across every dimension.

---

## Reusable Rare-Country Detection

I converted the manual country observation into a reusable SPL detection.

```spl
index=vpnlogs
| stats count by user src_country
| eventstats sum(count) as user_total by user
| eval country_pct=round((count/user_total)*100,2)
| where country_pct < 5
| sort country_pct
| table user src_country count user_total country_pct
```

The search identified:

- `jsmith` / Japan — 1 of 200 events — 0.50%
- `kbrown` / Australia — 1 of 200 events — 0.50%

The 5% value was used as an investigative threshold for this training dataset and is not presented as a universal SOC standard.

---

## Rapid Geographic Switching

I then created an SPL search that compared each VPN event with the user's immediately previous event.

```spl
index=vpnlogs
| sort 0 user _time
| streamstats current=f last(src_country) as previous_country last(src_ip) as previous_ip last(_time) as previous_time by user
| eval delta_minutes=round((_time-previous_time)/60,1)
| where src_country!=previous_country AND delta_minutes<=120
| table _time user previous_country previous_ip src_country src_ip delta_minutes
```

The search automatically identified:

- `jsmith`: US → Japan in **25 minutes**
- `jsmith`: Japan → US in **15 minutes**
- `kbrown`: Germany → Australia in **17 minutes**
- `kbrown`: Australia → Germany in **57 minutes**

![Rapid geographic switching detection](evidence/09-vpn-rapid-country-switch-detection.png)

*Figure 9. Reusable SPL search identifying rapid changes in source country.*

For `jsmith`, the sequence was:

```text
US
 |
25 minutes
 |
 v
Japan
 |
15 minutes
 |
 v
US
```

If the geographic labels accurately reflected physical user location, this sequence would be physically implausible.

### Analysis

The `jsmith` event contained several characteristics that justified further review:

- 199 of 200 VPN events came from one US source IP.
- Only one event originated from Japan.
- The Japanese source IP appeared only once in the dataset.
- Normal US activity occurred 25 minutes before the Japanese login.
- Normal US activity resumed 15 minutes afterward.
- The login hour itself was not statistically unusual.

By this point, I had a strong geographic inconsistency and an impossible-travel-style signal, but still not enough to call it credential theft or unauthorized access.

There were several explanations I could not rule out from the VPN data alone, including corporate VPN or proxy routing, inaccurate IP geolocation, shared infrastructure, legitimate remote access, travel, or another routing condition.

### VPN Finding Disposition

**Suspicious geographic inconsistency — identity validation required; insufficient evidence to confirm account compromise.**

In a production SOC, I would escalate the activity for identity and device validation before classifying the event as malicious.

---

# Final Assessment

This investigation identified two security-relevant patterns within the supplied datasets.

The Windows investigation reconstructed an authenticated session associated with `James` and Logon ID `0x551686`. Windows Security telemetry linked the session to process and account-management activity, while Sysmon independently corroborated the observed process relationships.

The evidence justified classifying the activity as suspicious administrative behavior requiring authorization validation. It did not establish malicious intent or confirmed compromise.

The VPN investigation established normal geographic behavior before identifying rare-country authentication events. For `jsmith`, 199 of 200 events came from one US source IP, while one event came from a unique Japanese IP. Normal US activity occurred 25 minutes before and 15 minutes after the Japanese event.

The VPN evidence justified identity validation but did not independently prove credential theft.

**Overall disposition: Suspicious activity identified in both datasets, with additional validation required before either case could be classified as a confirmed security incident.**

---

# Scope and Limitations

This investigation was performed in an authorized TryHackMe training environment using supplied Windows and VPN datasets.

The analysis is limited to the available telemetry.

## Windows Limitations

The available evidence did not establish:

- whether James's activity was authorized
- whether James's credentials were compromised
- whether `172.90.12.11` represented an approved system
- whether the WMI-associated execution was malicious
- whether the affected security-enabled global group was privileged
- whether additional endpoint activity occurred outside the supplied telemetry

One working query exposed a training-lab password inside a command-line field. That screenshot was intentionally excluded from the public evidence set.

## VPN Limitations

The VPN dataset did not provide:

- MFA results
- identity-provider authentication details
- device identity
- source-IP reputation
- VPN/proxy ownership information
- authoritative IP-geolocation confidence
- endpoint activity associated with the login
- user travel information
- confirmation from the account owner

The geographic anomaly therefore cannot independently establish credential compromise.

---

# Recommended Production SOC Follow-Up

## Windows Activity

In a production environment, I would:

1. Validate whether James's network session was expected and authorized.
2. Identify the system associated with `172.90.12.11`.
3. Review identity and Active Directory authentication records.
4. Compare the account-management activity with approved administrative tasks or change requests.
5. Review EDR and additional Sysmon telemetry surrounding the session.
6. Investigate additional WMI and remote-management activity.
7. Review service creation, scheduled tasks, PowerShell, and related process telemetry.
8. Identify the affected security group and determine its privileges.
9. Review subsequent activity involving `Alberto`.
10. Escalate the session if authorization could not be confirmed.

## VPN Activity

For the `jsmith` anomaly, I would:

1. Validate the login with the account owner.
2. Review MFA challenge and approval records.
3. Identify the device associated with the login.
4. Review identity-provider logs surrounding the event.
5. Investigate reputation and ownership information for `103.5.140.67`.
6. Determine whether VPN, proxy, or shared infrastructure could explain the location.
7. Review endpoint activity after the authentication.
8. Check for password resets or additional authentication anomalies.
9. Review other users for related infrastructure.
10. Escalate or contain the account if additional evidence supported unauthorized access.

---

# What I Learned

Before this project, I mostly thought of Splunk as a place to search through logs. What clicked for me here was that every useful search can create the next question. I could start broad, find something unusual, and keep moving deeper depending on what the evidence showed.

The Windows investigation made that clear. A rare account-management event led me to a Logon ID, that Logon ID led me to James's network session, and then Security and Sysmon gave me different views of the same activity. I started to understand why correlation matters more than looking at one event by itself.

The VPN side taught me a different lesson. The Japan login looked suspicious immediately, but its time of day was normal for `jsmith`. I did not want to ignore that just because it weakened the first impression. It showed me why an investigation has to test the parts that do not fit the theory too.

The biggest lesson I took from the project was patience. Suspicious does not automatically mean malicious. My job as the analyst is to keep following the evidence, understand the context, and be clear about what I can prove and what still needs validation.

---

# Evidence Index

Each item below links directly to the screenshot used in the investigation.

| Evidence | Purpose |
|---|---|
| [`01-windows-data-overview.png`](./evidence/01-windows-data-overview.png) | Establish Windows dataset scope |
| [`02-windows-eventid-distribution.png`](./evidence/02-windows-eventid-distribution.png) | Identify rare Windows activity |
| [`03-james-network-logon.png`](./evidence/03-james-network-logon.png) | Correlate James authentication with Logon ID |
| [`04-security-session-timeline.png`](./evidence/04-security-session-timeline.png) | Reconstruct Windows Security activity |
| [`05-sysmon-process-correlation.png`](./evidence/05-sysmon-process-correlation.png) | Corroborate process lineage using Sysmon |
| [`06-vpn-data-overview.png`](./evidence/06-vpn-data-overview.png) | Establish VPN dataset scope |
| [`07-vpn-country-baseline.png`](./evidence/07-vpn-country-baseline.png) | Identify geographic outliers |
| [`08-jsmith-ip-baseline.png`](./evidence/08-jsmith-ip-baseline.png) | Establish `jsmith` source-IP baseline |
| [`09-vpn-rapid-country-switch-detection.png`](./evidence/09-vpn-rapid-country-switch-detection.png) | Detect rapid geographic transitions |

### Evidence Preview

![Windows dataset overview](./evidence/01-windows-data-overview.png)

![Windows Event ID distribution](./evidence/02-windows-eventid-distribution.png)

![James successful network logon](./evidence/03-james-network-logon.png)

![Windows Security session timeline](./evidence/04-security-session-timeline.png)

![Sysmon process correlation](./evidence/05-sysmon-process-correlation.png)

![VPN dataset overview](./evidence/06-vpn-data-overview.png)

![VPN geographic baseline](./evidence/07-vpn-country-baseline.png)

![jsmith IP baseline](./evidence/08-jsmith-ip-baseline.png)

![Rapid geographic switching detection](./evidence/09-vpn-rapid-country-switch-detection.png)

---

# Lab Disclosure

This project was completed in an authorized TryHackMe training environment.

TryHackMe supplied the Splunk environment and training datasets. The screenshots, SPL searches, investigative pivots, evidence interpretation, findings, and final assessment documented here represent my analysis of the supplied telemetry.

This report does not reproduce proprietary room instructions, challenge answers, credentials, or an answer key.

All security analysis was performed within the authorized training environment.
