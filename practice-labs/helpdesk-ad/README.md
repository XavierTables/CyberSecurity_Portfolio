# Active Directory Help Desk — Practice Plan

> **Planned exercise — not completed.** This is a file-share troubleshooting scenario and ticket template. I haven't run this specific support case yet.

## Goal
Practice handling one help desk ticket from intake to troubleshooting, an approved fix or escalation, and final verification in a safe Windows lab.

## Lab environment
Use a Windows Server evaluation VM with Active Directory Domain Services, a Windows client joined to your lab domain, and test-only users and groups. Ensure sufficient VM resources, use a host-only/private lab network, and snapshot before changes. **Do not operate on someone else's production domain.**

## Ticket scenario — user cannot access a departmental file share
1. **Intake:** Record user's exact error, time, affected app/share, device, network connection, whether others are affected, urgency and callback method. Avoid collecting passwords.
2. **Reproduce:** Sign in with a test account and record the expected vs. observed access result.
3. **Connectivity:** Check `ipconfig /all`, `nslookup <lab-domain>`, `ping <lab-server>` (when permitted), and `Test-NetConnection <lab-server> -Port 445`. A blocked ping does not alone prove SMB is down.
4. **Identity and entitlement:** Inspect test-user group memberships in Active Directory Users and Computers and compare share vs. NTFS permissions. Do not add privileged access without an approved reason.
5. **Change control:** If a missing authorized group membership is the cause, document approval, make the *lab-only* change and record the original state. Otherwise document the reason for escalation.
6. **Verify and close:** Retest with the test user, record the successful/unsuccessful outcome and communicate clearly. Note that changes may require token refresh/new logon.

## Optional second case
Create a test-only account unlock/password-reset scenario. Record identity verification as a **simulated step** (not actual organizational policy), handle access securely, and verify the user can log in without publishing secrets.

## Publishable evidence checklist
- Lab diagram or short environment inventory (no real credentials).
- Before/after screenshots of relevant AD settings and test outcomes.
- Sanitized command output from at least two appropriate troubleshooting checks.
- **One completed ticket** with root cause, approval, changes and verification.
- What you would escalate and why, and any unresolved limits.

## Blank Tier-1 ticket (copy and complete only after doing the lab)
**Ticket:** LAB-HD-___ | **Date/time/time zone:** ___  
**Reported issue:** ___ | **User impact:** ___ | **Affected asset:** ___  
**Troubleshooting performed and results:** ___  
**Root-cause hypothesis / supporting facts:** ___  
**Authorization/approval:** ___  
**Change implemented or escalation reason:** ___  
**Validation result:** ___ | **Customer-facing resolution:** ___  
**Status:** Open / Escalated / Closed | **Evidence:** ___

## When this becomes a completed project
After I run the case, I'll add the actual ticket, screenshots, commands, and verification results. For now, it's a practice outline, not completed project evidence.
