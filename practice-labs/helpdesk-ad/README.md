# Windows and Active Directory Support: Practice Plan

**Status: Planned.** I will document a support ticket with troubleshooting evidence and a verified result.

## Lab and scenario

I plan to use a private Windows Server/AD lab, a domain-joined Windows client, and test users/groups. I will take a snapshot before making changes.

**Ticket:** A test user cannot access a departmental file share.

## Workflow

1. I will record the exact error, affected user/device/share, timing, urgency, network connection, and whether others are affected.
2. I will reproduce the problem with the test account.
3. I will inspect `ipconfig /all`, DNS lookup results, and `Test-NetConnection <lab-server> -Port 445`. Ping can provide context when permitted; a blocked ping alone does not establish that SMB is down.
4. I will compare AD group membership with share and NTFS permissions.
5. If the user is missing an approved group membership, I will record the original state and simulated approval before making the lab change. If the cause is still unclear, I will document my checks and explain why I would escalate.
6. I will refresh the test user's session if needed, retest access, and write a short update explaining the result.

## What I will document

- Lab inventory and test-account context.
- Relevant command results and before/after permission/access captures.
- A completed ticket recording the cause, simulated approval, change or escalation, and final verification.
- Any remaining uncertainty.

## Ticket template

**Case / date / time zone:** ___  
**Issue and user impact:** ___  
**Checks and observed results:** ___  
**Cause or working hypothesis:** ___  
**Simulated approval and change / escalation:** ___  
**Verification and customer update:** ___  
**Status and evidence links:** ___

For a second case, I plan to unlock or reset a test account, simulate identity verification, and confirm that the user can sign in. I will add the results after completing the exercise.
