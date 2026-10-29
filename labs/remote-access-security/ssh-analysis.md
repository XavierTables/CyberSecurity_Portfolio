# SSH Authentication: Checking What Access Was Established

[Remote-access report](README.md) · [VNC comparison](vnc-analysis.md) · [Evidence index](evidence/README.md)

## What I examined

The SSH exercise used Kali Linux and the Metasploit module `auxiliary/scanner/ssh/ssh_login` against TCP 22 on Metasploitable 2.

The module options establish the target and credential-testing method. `RHOSTS` specifies the host, `USER_FILE` and `PASS_FILE` supply possible credentials, and `STOP_ON_SUCCESS` controls when testing stops.

![SSH module options](evidence/ssh-module-options.webp)

## Results

The login scanner reported `msfadmin:msfadmin` as successful and opened an SSH shell session.

![SSH login result](evidence/ssh-login-reported.webp)

A follow-up session check produced:

```text
sessions -i 1
whoami
msfadmin
```

![SSH session identity check](evidence/ssh-session-whoami.webp)

## My conclusion

The login wasn't just a positive password guess. The shell session and `whoami` result support **interactive access as the msfadmin user**.

I would not describe that as root access, privilege escalation, or an exploit of the SSH protocol. The weakness shown is the predictable credential on a deliberately vulnerable training system.

## What I'd investigate on a company server

I'd check whether the account was approved, when and where the connection came from, failed attempts preceding the successful login, and commands executed afterward. I'd recommend removing default credentials, restricting SSH to approved management paths, and using stronger authentication where supported.

**Verification after remediation:** Confirm the weak credentials no longer authenticate while approved administrative access continues to work.

[Practice the commands and capture your own output](../reproduce-and-capture.md) · [Screenshot source pages](evidence/README.md)
