# SMTP User Enumeration — Guided Metasploitable 2 Lab

**Training:** Tri-C SecurePath cybersecurity bootcamp · **Lab date:** May 27, 2026  
**Environment described in the lesson:** Kali Linux, Metasploitable 2, VirtualBox, Metasploit, Nmap, Telnet  
**Type:** Supplemental guided lab / protocol analysis, **not** an independent penetration test  
**Result:** The retained lesson screenshots show a Metasploit SMTP enumeration result and two different `VRFY` responses.

[Back to supplemental labs](../README.md) · [Portfolio home](../../README.md)

## Question

Can an SMTP service disclose useful account information through an enumeration scanner or through responses to the `VRFY` command?

I worked through this topic during SecurePath. When revisiting the exercise, I focused on what the SMTP responses actually establish instead of treating every scanner result as a verified account.

## Lab context

The exercise paired a Kali Linux machine with the intentionally vulnerable Metasploitable 2 VM. The lesson used port 25 on the target's SMTP service and showed how to inspect that service with Metasploit and Telnet. The presentation also discussed VM networking and keeping vulnerable machines isolated.

This was an authorized training environment. The slides describe virtual networking, but they do **not** preserve enough information to reconstruct the exact adapter settings or prove the target was isolated at every stage.

## Workflow documented in the lesson

1. Start the Kali and Metasploitable 2 virtual machines, and identify the lab target's IP address.
2. Review an Nmap service scan of the target. Only part of that terminal output is visible in the retained slides; I am not reconstructing a complete port inventory from it.
3. Open Metasploit with `msfconsole` and select `auxiliary/scanner/smtp/smtp_enum`.
4. Review the module options, set the lab target as `RHOSTS`, and use SMTP port `25`.
5. Run the auxiliary scanner and review its candidate account output.
6. Connect to the SMTP service with Telnet and compare its responses to two `VRFY` requests.

The slides select the module by a numbered search-result index (`use 25` in one screenshot). Index numbers change between installations, so the full module path above identifies the module more reliably.

## Retained observations

These are **transcriptions from the bootcamp presentation screenshots**, not original terminal logs preserved in this repository.

| Source shown in slides | Observed response | What I can reasonably conclude |
| --- | --- | --- |
| SMTP connection on port 25 | `220 metasploitable.localdomain ESMTP Postfix (Ubuntu)` | The demonstrated service presented an SMTP banner identifying Postfix on Ubuntu. |
| Metasploit `smtp_enum` result | `Users found:` followed by several names including `backup`, `daemon`, `ftp`, `mail`, `mysql` and `postfix` | The module **reported** candidate accounts. This output alone does not independently verify every account. |
| Telnet: `VRFY mail` | `252 2.0.0 mail` | **Inconclusive:** SMTP code 252 means the server cannot verify the user but may accept a message and attempt delivery. It does **not** establish that `mail` exists. |
| Telnet: `VRFY jsmith` | `550 5.1.1 <jsmith>: Recipient address rejected: User unknown in local recipient table` | The demonstrated server explicitly rejected `jsmith` as an unknown local recipient. This is not proof that the name could not exist in some other account system. |

The screenshots also show a completed scan of one target and a Metasploit module execution message. In Metasploit, entering `exploit` can execute an auxiliary module; **this exercise demonstrates enumeration, not a confirmed system compromise**.

## My interpretation

The interesting result was not simply that the scanner printed a list of usernames. It was that the SMTP service returned **different answers** for two queries: one non-confirming response (`252`) and one explicit local-recipient rejection (`550 5.1.1`).

That difference can expose information about how a mail server handles recipients. An attacker might try to use such differences to refine username guesses. But these two replies do not justify saying that `mail` was verified as a real user, that all scanner-reported names exist, or that an authentication weakness was exploited.

For an actual security finding, I would need to confirm the behavior against more controlled test cases, examine the mail server's configuration, and determine whether the responses are useful for reliably distinguishing valid from invalid accounts.

## Recommendations for a real organization

- **Review `VRFY` and `EXPN` behavior:** If not required, configure the mail server to avoid disclosing directory or account details through these commands. Validate the change rather than assuming that simply disabling a command eliminates every enumeration path.
- **Look for response differences beyond `VRFY`:** Evaluate whether recipient handling leaks account information in a way that can be reliably exploited, while preserving necessary mail delivery behavior.
- **Monitor for probing:** Review SMTP logs for repetitive `VRFY` requests, rapid recipient checks, and unusual remote sources. Investigate patterns in context rather than treating one command as an incident.
- **Protect mail submission separately:** Require appropriate authentication and TLS for mail submission. Port **587** is commonly used with STARTTLS; port **465** uses implicit TLS. Port **25** remains normal for server-to-server SMTP relay and should not simply be replaced with 587.
- **Review exposure and maintenance:** Keep the mail service supported and patched, limit unnecessary access, and confirm it is not an open relay.

**Assessment:** The guided screenshots illustrate a *possible account-information exposure mechanism*. They do **not** establish a confirmed production vulnerability, successful account validation, compromise, or business impact. I would not assign a severity score from this evidence alone.

## Evidence provenance and limitations

The retained artifacts are screenshots of instructional presentation slides supplied from the May 27 SecurePath lesson. Several slides contain terminal captures, but I do not have the original Nmap output, Metasploit session logs, mail-server configuration, or a complete set of unedited screenshots tied to my own console session.

For that reason, I am documenting **what the material shows** rather than presenting the slides as independently produced scan evidence. I have not copied the classroom slide deck into this public repository. The sample usernames and responses above are short text excerpts transcribed for analysis.

This page records my interpretation of guided training and my recommended follow-up. It should not be mistaken for an externally commissioned assessment or an independently reproduced test.

## What I took away

A scanner finding is a lead, not automatically a confirmed vulnerability. I would check the server's direct responses and explain the limits of the evidence before making a claim to another analyst. In this lab, the distinction between SMTP reply codes `252` and `550` was more important than the size of the scanner's username list.

## References

- [RFC 5321 — Simple Mail Transfer Protocol](https://www.rfc-editor.org/rfc/rfc5321.html) — SMTP `VRFY`, reply codes `252` and `550`, and security considerations.
- [RFC 6409 — Message Submission for Mail](https://www.rfc-editor.org/rfc/rfc6409.html) — separates mail submission from server-to-server relay.
- [RFC 8314 — TLS for Email Submission and Access](https://www.rfc-editor.org/rfc/rfc8314.html) — TLS use on submission ports 587 and 465.
- [Metasploit documentation](https://docs.metasploit.com/) — framework and auxiliary scanner reference.
