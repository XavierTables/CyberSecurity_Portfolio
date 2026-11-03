# Windows & IT Troubleshooting | Supporting Skills

**Supporting my SOC focus:** Windows troubleshooting · Accounts and permissions · Networking fundamentals  
[Cybersecurity portfolio](../README.md) · [SOC résumé](../resume/Xavier_Tables_SOC_Resume.pdf) · [LinkedIn](https://www.linkedin.com/in/xaviertables/)

I enjoy figuring out why something isn't working and explaining the fix in a way the other person can follow. I've built PCs, helped family with computer and home-network issues, and studied Windows, Active Directory fundamentals and networking through Tri-C SecurePath. These are useful foundations for investigating endpoint and identity alerts in a SOC.

## At a glance

| Area | What I can discuss or show |
| --- | --- |
| **Windows account and event review** | [Documented Event Viewer case](../projects/windows-security-log-triage/README.md) with screenshots, a timeline and my reasoning |
| **PC troubleshooting** | Experience building PCs and helping with hardware and software problems at home |
| **Network fundamentals** | TCP/IP, DNS, DHCP, basic connectivity checks and [Nmap service discovery](../labs/nmap-service-discovery/README.md) |
| **Account administration concepts** | Windows users, groups, password resets and permissions covered in SecurePath training |

## Featured case: separating account changes from normal SYSTEM activity

**Question:** Were an Administrator password change and later privileged Windows events part of the same suspicious sequence?

I examined Event IDs **4724, 4738, 4624 and 4672** and compared the accounts, Logon IDs, processes and timestamps. The first two records supported a password change. The later privileged events were associated with `SYSTEM` and `services.exe`, so I did **not** treat them as proof of a related compromise.

**Next check:** Confirm whether the password change was authorized, then examine surrounding authentication activity if needed.

[**Read my walkthrough and see the evidence**](../projects/windows-security-log-triage/README.md)

## How I approach troubleshooting

I want to understand the user's symptoms first, narrow down the possible causes, make one change at a time, and verify the result. I also want to leave notes clear enough that another technician could understand what I checked.

**Next practical project:** Document a full end-user access or shared-folder permissions support case—from reported problem through diagnosis, resolution and verification. My current Windows case is a **log-review investigation**, not a completed end-user support ticket.
