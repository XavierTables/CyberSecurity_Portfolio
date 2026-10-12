# SPL Query Log

These are the **11 searches I ran** during my [Splunk investigation](../README.md), in their original order.

## Search scope

I searched **All time** in the supplied training datasets. I did not record their full date ranges or Splunk's display time zone. My Windows searches also need tighter computer and time filters, which I covered in the validation plan.

I saved nine screenshots of selected results. My next Windows correlation checks are in the [validation plan](../../../docs/splunk-correlation-validation-plan.md).

## 01: Windows dataset overview

I started by checking the available Windows data.

```spl
index=windowslogs
```

Result: 12,256 events, with authentication, account, host, process, and network fields available.

## 02: Event ID distribution

I counted records by Event ID to find less common activity.

```spl
index=windowslogs
| stats count by EventID
| sort - count
```

Recorded result: 55 distinct Event IDs. Events 4720, 4724, 4726, 4728, 4729, and 4739 appeared once each. Their rarity provided leads for review.

## 03: Account-management activity

I reviewed the rare account-management events together.

```spl
index=windowslogs EventID IN (4720,4724,4726,4728,4729,4739)
| sort _time
```

The recorded findings involved subject account James, target account Alberto, and Logon ID 0x551686. A nearby 4739 event had different host/session context and was excluded from that cluster.

## 04: James network logon

I searched for a logon event matching the Logon ID.

```spl
index=windowslogs EventID=4624 "0x551686"
```

Recorded result: one 4624 event for James, with TargetLogonId 0x551686, Type 3, source IP 172.90.12.11, Kerberos, and an elevated token. This suggested a possible session connection to the account activity; host and time-window checks remain necessary.

## 05: Security timeline

I collected Security events matching the Logon ID and ordered them by record number.

```spl
index=windowslogs "0x551686" Channel=Security
EventID IN (4624,4672,4627,4688,4728,4720,4724,4729,4726,4634)
| sort 0 RecordNumber
| table RecordNumber EventTime EventID Category SubjectUserName TargetUserName SubjectLogonId TargetLogonId LogonType IpAddress Message
```

The search returned 12 rows, including authentication, process creation, account/group changes, a password-reset attempt, and logoff. RecordNumber helped order records within the Security log, subject to confirming the event computer/log instance. The table omitted the password-reset audit outcome.

## 06: Sysmon process relationships

I examined process records for James and compared them with the Security events.

```spl
index=windowslogs EventID=1 User="Cybertees\\James"
(Image="*\\net.exe" OR Image="*\\net1.exe" OR Image="*\\conhost.exe")
| sort _time
| table _time User Image ParentImage ProcessId ParentProcessId ProcessGuid ParentProcessGuid
```

The rows showed net.exe with parent image WmiPrvSE.exe, plus conhost.exe and net1.exe with GUID relationships matching that net.exe process. This supported ancestry within the Sysmon results. It did not verify a common host/session with the Security records.

## 07: VPN dataset overview

I checked the available VPN data.

```spl
index=vpnlogs
```

Recorded result: 2,000 events, 10 users, 12 source IPs, and 6 countries. The investigation used user, src_ip, src_country, and _time.

## 08: Per-user country baseline

I counted each user's VPN events by country.

```spl
index=vpnlogs
| stats count by user src_country
| sort user - count
```

Recorded result: jsmith had 199 US-labelled events and one Japan-labelled event; kbrown had 199 Germany-labelled events and one Australia-labelled event. These became candidates for follow-up.

## 09: Rare-country search

I calculated each country's share of a user's VPN events.

```spl
index=vpnlogs
| stats count by user src_country
| eventstats sum(count) as user_total by user
| eval country_pct=round((count/user_total)*100,2)
| where country_pct < 5
| sort country_pct
| table user src_country count user_total country_pct
```

The search returned the two outliers at 0.50% each (1 of 200 events). The 5% cutoff was a training-data choice; its suitability for other datasets was not tested.

## 10: jsmith source-IP baseline

I compared jsmith's source IPs, countries, and first and last observed times.

```spl
index=vpnlogs user=jsmith
| stats count min(_time) as first_seen max(_time) as last_seen by src_ip src_country
| convert ctime(first_seen) ctime(last_seen)
| sort - count
```

Recorded result: 72.14.201.12 / US had 199 events; 103.5.140.67 / Japan had one. I compared the unusual source with jsmith's other logins in this dataset.

## 11: Rapid country changes

I compared each login with the previous login for the same user.

```spl
index=vpnlogs
| sort 0 user _time
| streamstats current=f last(src_country) as previous_country last(src_ip) as previous_ip last(_time) as previous_time by user
| eval delta_minutes=round((_time-previous_time)/60,1)
| where src_country!=previous_country AND delta_minutes<=120
| table _time user previous_country previous_ip src_country src_ip delta_minutes
```

Recorded result: jsmith US to Japan in 25 minutes and Japan to US in 15; kbrown Germany to Australia in 17 and Australia to Germany in 57. Four transitions surrounded two rare-country events. The 120-minute threshold was chosen for the lab; routing and geolocation context remained unresolved.

## Reproduction notes

When I reuse these searches, I will check the fields, set a time window, and review missing values or events with identical timestamps. I will also tune the VPN thresholds against the available user history and verify the computer and subject/target Logon IDs in the Windows events.
