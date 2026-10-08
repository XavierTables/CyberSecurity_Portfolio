# SPL Investigation Query Log

This is the search trail I used during the Splunk SIEM investigation. I kept the queries in order so the pivots are visible instead of only showing the final searches that worked.

TryHackMe provided the authorized lab environment and datasets. The SPL, investigative pivots, results, and notes below show how I worked through the available evidence.

## Scope and Evidence Notes

The searches below preserve the SPL I executed in the lab. The published captures used **All time**; the displayed time zone and full dataset bounds were not recorded. The Windows authentication anchor shows `Hostname=Micheal.Beaven`, but the session and Sysmon table searches do not constrain or display the computer name. Before reproducing them in production, I would verify the event computer, time window, and subject/target Logon ID fields. See [the report's search-scope note](../README.md#search-scope-and-reproducibility).

Nine screenshots support the investigation, while this log records eleven searches. The country-percentage and two-hour thresholds are choices for this training dataset. Production tuning would require sufficient user history, missing-field handling, reliable timestamps, and review of false positives.

---

## Query 01 — Windows Dataset Overview

### Purpose

Establish the scope of the Windows dataset and review the available telemetry before narrowing the investigation.

### SPL

```spl
index=windowslogs
```

### Result

The search returned **12,256 Windows events**.

Available fields included security-relevant information such as EventID, Hostname, User / AccountName, Image, process information, network information, and Windows Security and Sysmon telemetry.

### Why It Mattered

Starting with the complete dataset allowed me to understand the available evidence before selecting specific events for deeper analysis.

### Next Pivot

Determine which Windows Event IDs were present and how frequently they occurred.

---

## Query 02 — Windows Event ID Distribution

### Purpose

Identify common and rare Windows Event IDs within the dataset.

### SPL

```spl
index=windowslogs
| stats count by EventID
| sort - count
```

### Result

The dataset contained **55 distinct Event IDs**.

Several account-management events appeared only once, including 4720, 4724, 4726, 4728, 4729, and 4739.

### Why It Mattered

The low-frequency account-management events provided a focused starting point for investigation. Rare activity was treated as an investigative lead rather than automatically malicious behavior.

### Next Pivot

Isolate the rare account-management events and determine whether they shared common users, sessions, hosts, or target accounts.

---

## Query 03 — Rare Account-Management Activity

### Purpose

Review the rare account-management events together and determine whether they formed a related activity cluster.

### SPL

```spl
index=windowslogs EventID IN (4720,4724,4726,4728,4729,4739)
| sort _time
```

### Result

Five events were strongly connected through common evidence involving subject account `James`, Subject Logon ID `0x551686`, the target SID associated with `Alberto`, and host `Micheal.Beaven`.

The 4739 password-policy event had different host and session context and was not treated as part of the same activity chain.

### Why It Mattered

This search identified a coherent account-management cluster while preventing an unrelated nearby event from being forced into the same narrative.

### Next Pivot

Identify the authentication session associated with Logon ID `0x551686`.

---

## Query 04 — James Successful Network Logon

### Purpose

Identify the successful authentication event associated with the Logon ID used during the account-management activity.

### SPL

```spl
index=windowslogs EventID=4624 "0x551686"
```

### Result

One successful logon event was returned with account `James`, domain `Cybertees.LOCAL`, Target Logon ID `0x551686`, Logon Type 3, source IP `172.90.12.11`, Kerberos authentication, and an elevated token.

### Why It Mattered

The matching Logon ID connected James's successful network authentication to the later account-management activity. Logon Type 3 established network authentication but did not by itself establish malicious remote access.

### Next Pivot

Reconstruct the Security-channel activity associated with the session.

---

## Query 05 — Security Session Timeline

### Purpose

Reconstruct the Windows Security activity associated with Logon ID `0x551686`.

### SPL

```spl
index=windowslogs "0x551686" Channel=Security
EventID IN (4624,4672,4627,4688,4728,4720,4724,4729,4726,4634)
| sort 0 RecordNumber
| table RecordNumber EventTime EventID Category SubjectUserName TargetUserName SubjectLogonId TargetLogonId LogonType IpAddress Message
```

### Result

The Security record sequence showed special-logon context, successful network authentication, group-membership information, process creation, group membership changes, `Alberto` account creation, a password-reset attempt, account deletion, and session logoff. The published table does not display the audit outcome of Event 4724, so it does not establish whether the reset attempt succeeded.

The relevant events occurred within the same displayed second, so Security `RecordNumber` provided the clearest available ordering within that channel.

### Why It Mattered

This organized the Security records associated with the Logon ID into a timeline. The computer and time-window validation described above remains necessary when reproducing the correlation.

### Next Pivot

Investigate the processes created within the session.

---

## Query 06 — Sysmon Process Correlation

### Purpose

Use Sysmon telemetry to independently verify the process activity observed in Windows Security Event 4688.

### SPL

```spl
index=windowslogs EventID=1 User="Cybertees\\James"
(Image="*\\net.exe" OR Image="*\\net1.exe" OR Image="*\\conhost.exe")
| sort _time
| table _time User Image ParentImage ProcessId ParentProcessId ProcessGuid ParentProcessGuid
```

### Result

Sysmon showed the process relationship:

```text
WmiPrvSE.exe
    |
    +-- net.exe
          |
          +-- conhost.exe
          |
          +-- net1.exe
```

The ProcessGuid and ParentProcessGuid values supported the parent-child relationship.

### Why It Mattered

Sysmon corroborated the process relationships for the same account and displayed second. The ProcessGuid matches supported the parent-child relationships; matching the event computer and session boundaries would strengthen the cross-source correlation. The available evidence supported WMI-associated ancestry while leaving authorization and malicious intent unresolved.

### Next Pivot

Move to the VPN dataset and establish normal user authentication behavior.

---

## Query 07 — VPN Dataset Overview

### Purpose

Establish the scope and available fields within the VPN authentication dataset.

### SPL

```spl
index=vpnlogs
```

### Result

The dataset contained **2,000 VPN events**, **10 users**, **12 source IP addresses**, and **6 source countries**.

### Why It Mattered

The dataset contained sufficient user, IP, country, and timestamp information to perform behavioral baselining and geographic anomaly analysis.

### Next Pivot

Determine each user's normal country distribution.

---

## Query 08 — VPN Country Baseline

### Purpose

Compare each user's VPN activity by source country.

### SPL

```spl
index=vpnlogs
| stats count by user src_country
| sort user - count
```

### Result

Most users showed consistent geographic behavior. Two accounts contained one rare-country event:

- `jsmith` — 199 US events / 1 Japan event
- `kbrown` — 199 Germany events / 1 Australia event

### Why It Mattered

This established two geographic anomaly candidates while preserving the distinction between unusual and malicious activity.

### Next Pivot

Determine whether the rare source IPs were also unusual within the dataset.

---

## Query 09 — Reusable Rare-Country Detection

### Purpose

Automatically identify countries representing a small percentage of an individual user's observed VPN activity.

### SPL

```spl
index=vpnlogs
| stats count by user src_country
| eventstats sum(count) as user_total by user
| eval country_pct=round((count/user_total)*100,2)
| where country_pct < 5
| sort country_pct
| table user src_country count user_total country_pct
```

### Result

The search automatically identified:

- `jsmith` / Japan — 1 of 200 events — **0.50%**
- `kbrown` / Australia — 1 of 200 events — **0.50%**

### Why It Mattered

This converted the manually observed geographic anomalies into a reusable behavioral detection method. The 5% threshold was used only as an investigative threshold for this training dataset.

### Next Pivot

Deeply investigate one candidate account and establish its IP baseline.

---

## Query 10 — jsmith IP Baseline

### Purpose

Determine whether `jsmith` normally used consistent VPN source infrastructure.

### SPL

```spl
index=vpnlogs user=jsmith
| stats count min(_time) as first_seen max(_time) as last_seen by src_ip src_country
| convert ctime(first_seen) ctime(last_seen)
| sort - count
```

### Result

`jsmith` showed:

- `72.14.201.12` / US — **199 events**
- `103.5.140.67` / Japan — **1 event**

The US source appeared throughout the observed period, while the Japan-labelled source IP appeared once for `jsmith` within that scope.

### Why It Mattered

The result established an extremely stable observed IP/country baseline for `jsmith` with one clear geographic deviation.

### Next Pivot

Determine whether the rare-country login occurred close to logins from the user's normal country.

---

## Query 11 — Rapid Country-Switch Detection

### Purpose

Automatically identify consecutive VPN events where a user's source country changed within two hours.

### SPL

```spl
index=vpnlogs
| sort 0 user _time
| streamstats current=f last(src_country) as previous_country last(src_ip) as previous_ip last(_time) as previous_time by user
| eval delta_minutes=round((_time-previous_time)/60,1)
| where src_country!=previous_country AND delta_minutes<=120
| table _time user previous_country previous_ip src_country src_ip delta_minutes
```

### Result

The detection identified four rapid geographic transitions:

- `jsmith`: US → Japan in **25 minutes**
- `jsmith`: Japan → US in **15 minutes**
- `kbrown`: Germany → Australia in **17 minutes**
- `kbrown`: Australia → Germany in **57 minutes**

### Why It Mattered

The search independently detected geographically inconsistent consecutive logins without hard-coding the known anomaly timestamps.

If the geolocation labels accurately reflected physical location, the observed transitions would be physically implausible. The VPN data alone could not distinguish among credential misuse, VPN/proxy routing, geolocation error, shared infrastructure, travel-related factors, or other explanations.

---

## Investigation Safety Note

One working search displayed a training-lab password in a process command-line field. That screenshot was excluded from the public evidence set.

The final public evidence and queries were selected to preserve useful investigative context without exposing visible credentials.
