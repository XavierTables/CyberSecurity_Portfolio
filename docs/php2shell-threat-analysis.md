# PHP2Shell — Why the Disclosure Date Wasn't the Starting Point

**Security Research & Threat Intelligence** · October 22, 2026  
**CVE-2026-109618 and CVE-2026-109619** · Critical (CVSS v4.0: 9.2 each)

*This is a public-source research brief, not a PHP2Shell lab or an incident I investigated.*

[Portfolio](../README.md) · [Research index](../research/README.md)

## What happened

PHP released fixes on **October 21, 2026** for two flaws in its web-request processing. Researchers showed that attackers could use them for **unauthenticated remote code execution (RCE)** on vulnerable PHP servers. Amazon Threat Intelligence also reported an **exploitation attempt on October 17** in its MadPot honeypot data—four days before public disclosure. Additional attempts followed. [1][2]

That timeline is the part I find most important. If a team starts looking only from the day the advisory was released, it could miss earlier activity. But an observed attempt in a honeypot is **not** evidence that a specific company's server was compromised.

## How the vulnerabilities work

Both flaws involve memory that PHP handles incorrectly when a request ends abnormally, often around an **out-of-memory** condition:

| Vulnerability | Plain-language explanation |
| --- | --- |
| **CVE-2026-109618** | PHP can stop while request data is only partly initialized. Cleanup may then treat that unfinished data as valid. |
| **CVE-2026-109619** | PHP may keep a reference to memory after the request releases it. A later request can use this stale state, causing a **use-after-free**. |

The dangerous part is that the issue is in the **PHP runtime itself**, not just in a WordPress plugin or an application login. Depending on the configuration and exploit path, the result can be memory exposure or code execution. Apache `mod_php` was identified as a particularly high-risk deployment. [1][4]

**Fix:** Update PHP to a verified fixed version: **8.5.12, 8.4.27, 8.3.36, or 8.2.35** (or a vendor-confirmed backport). Older unsupported versions need special attention. Web application firewall (WAF) protections can help, but they do not replace patching. [1][3]

## My Perspective

What stood out to me is that attackers were already trying to exploit PHP2Shell before it was publicly disclosed. That shows why SOC teams can't rely only on known signatures or patches. Log monitoring, anomaly detection, and threat hunting help catch suspicious activity even when a specific vulnerability isn't known yet.

If I were investigating this as a SOC analyst, I'd first figure out which servers run PHP and whether they've been patched. But I wouldn't stop there. Since exploitation may have started before the advisory came out, I'd look back through web server logs and other relevant system logs **starting at least from October 17**, not from the disclosure date. I'd also check whether older logs were available.

Then I'd look for evidence of success, not just attempts. That could include unusual HTTP response patterns, new or unexpected files on the web server, unfamiliar processes, or suspicious outbound connections. If I found a concerning request, I'd check what the affected server did immediately afterward and whether there was a legitimate explanation. Response codes and indicators of compromise (IOCs) are leads, not proof on their own. [2][3]

My biggest takeaway is to **verify before concluding**. With a newly disclosed vulnerability, it's easy to assume the worst, but my Security+ and CySA+ studies taught me to confirm with evidence first. I'd use the logs to separate a vulnerable server, an attempted exploit, and signs that an attacker may actually have gained access.

*These are the checks I would make; I haven't run them against PHP2Shell data.*

## Key Takeaways — For Later Review

- **RCE:** The attacker may be able to run code on a remote system. *Unauthenticated* means no login is required.
- **Use-after-free:** Software keeps using memory after it was released. That can cause crashes, data exposure, or code execution.
- **Exposure ≠ attempt ≠ compromise:** Each requires different evidence. Correlate web requests with what happened on the host.
- **Patch and investigate backward:** Updating fixes the vulnerability; it doesn't establish whether an attacker exploited it before the fix.
- **Don't depend on signatures alone:** Behavior, time windows, and context can reveal activity before a CVE-specific detection exists.

## Sources

1. [PHP Project — October 21, 2026 security releases](https://www.php.net/archive/2026.php#2026-10-21-5)
2. [Amazon Threat Intelligence — pre-disclosure attempts observed by MadPot](https://aws.amazon.com/blogs/security/amazon-threat-intelligence-identifies-php2shell-exploitation-prior-to-public-disclosure-in-madpot/)
3. [Cloudflare — PHP2Shell protections and observed attack traffic](https://blog.cloudflare.com/php-vulnerabilities-waf-protection)
4. [Wiz Research — technical analysis of PHP2Shell](https://www.wiz.io/blog/php2shell-php-rce)
