# SSH Authentication: Verifying What a Successful Login Means

[Back to remote-access assessment](README.md) · [Screenshot sources](evidence/README.md)

## Objective

Use a controlled SSH login test to see whether weak credentials work against the Metasploitable service, then check what kind of access follows.

## Approach

In the SecurePath exercise, Kali runs Metasploit's `auxiliary/scanner/ssh/ssh_login` against SSH on TCP 22. The module is configured with a small training list of possible usernames and passwords.

![SSH module settings](evidence/ssh-module-options.webp)

The useful options here are `RHOSTS`, `USER_FILE`, `PASS_FILE`, and `STOP_ON_SUCCESS`. They're important because they tell me **which host was tested**, **where the credential guesses came from**, and **when the scanner would stop**.

## Result

The example reports a credential match for `msfadmin:msfadmin` and opens an SSH session.

![SSH authentication result](evidence/ssh-login-reported.webp)

The next step matters more than the tool's summary. The session is selected and the account is checked:

```text
sessions -i 1
whoami
msfadmin
```

![SSH session and whoami](evidence/ssh-session-whoami.webp)

## My interpretation

I can support a conclusion of **interactive SSH access as `msfadmin`**. I cannot support a claim of root access or a vulnerability in the SSH software. The weakness demonstrated is the predictable credential for this deliberately vulnerable account.

If I were handling this as a SOC alert, I'd separate a login attempt from a confirmed successful session. I'd correlate the source IP, authentication logs, username, timing, and any shell or process activity after login.

## Remediation and validation

For an organizational host, I would replace default/shared credentials, remove unused accounts, restrict SSH to the approved administration network, and review key-based authentication and MFA where suitable. I'd verify the fix by confirming the previous credentials fail and legitimate administrators can still connect.

**Bottom line:** A scanner success result gets my attention. A subsequent session and `whoami` result make my assessment more specific.

[Recreate this test in an authorized VM](../reproduce-and-capture.md)

*The screenshot excerpts are from the SecurePath Exercise 2 materials; see the [evidence index](evidence/README.md) for source pages.*
