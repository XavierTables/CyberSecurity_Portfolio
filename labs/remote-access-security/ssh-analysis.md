# SSH Authentication | What the Result Proves

[Combined assessment](README.md) · [Evidence](evidence/README.md) · [Recreate this lab](../reproduce-and-capture.md)

## Test shown

The guided exercise targets Metasploitable 2's SSH service on TCP 22 with Metasploit's `auxiliary/scanner/ssh/ssh_login`. It supplies a small training wordlist as `USER_FILE` and `PASS_FILE`, then checks for accepted combinations.

![SSH module configuration from the instructor's lab example](evidence/ssh-module-options.webp)

*Exercise 2, p.11 — training example's scanner configuration.*

## Evidence sequence

1. The scanner reports `Success: 'msfadmin:msfadmin'`.
2. The console reports an SSH shell session.
3. The session is selected and `whoami` returns `msfadmin`.

![SSH scanner success result from the training slide](evidence/ssh-login-reported.webp)

![Shell verification showing msfadmin in the example session](evidence/ssh-session-whoami.webp)

This sequence supports a narrower, defensible finding: **the example account authenticated and provided an interactive shell**. The logged-in user was `msfadmin`, not `root`. No privilege escalation or service implementation exploit is shown.

## What I would check as an analyst

| Question | Verification |
| --- | --- |
| Was access expected? | Identify the host owner, approved admin accounts, and change window |
| Was password guessing involved? | Compare source IPs, failure counts, successful login timestamps, and sshd logs |
| What privileges did the login have? | Review `whoami`, `id`, account groups, and approved access policy |
| How would I close it? | Change default credentials, remove unnecessary access, restrict SSH, then confirm the old password fails |

A successful login against intentionally vulnerable Metasploitable is useful training evidence, **not** a production incident.

## What I learned

I'd rather prove the access level than exaggerate the scanner output. Getting a shell as `msfadmin` is a real distinction from merely guessing a valid password, but it is not the same as obtaining administrative root privileges.

**Source:** Crops of instructor screenshots from *Lab Exercise 2 — Exploit SSH Server with Metasploit*, pp.11, 13–14. Full provenance is in the [evidence index](evidence/README.md).
