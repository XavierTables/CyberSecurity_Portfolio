# Windows and Active Directory Support: Practice Plan

**Status: Planned; not executed.** The intended output is a completed support ticket with troubleshooting evidence and a verified result.

## Lab and scenario

Use a private Windows Server/AD lab, a domain-joined Windows client, and test users/groups. Take a snapshot before changes.

**Ticket:** A test user cannot access a departmental file share.

## Workflow

1. Record the exact error, affected user/device/share, timing, urgency, network connection, and whether others are affected.
2. Reproduce the problem with the test account.
3. Inspect `ipconfig /all`, DNS lookup results, and `Test-NetConnection <lab-server> -Port 445`. Ping can provide context when permitted; a blocked ping alone does not establish that SMB is down.
4. Compare AD group membership with share and NTFS permissions.
5. If a missing authorized membership explains the failure, record the simulated approval and original state, then make the lab change. Otherwise document the evidence and escalation reason.
6. Refresh the test user's logon/token when needed and retest access. Record the result and a short customer-facing explanation.

## Evidence to publish after execution

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

An optional second case can cover a test-account unlock/password reset, with simulated identity verification and login verification. Completed evidence will be added only after the exercise is run.
