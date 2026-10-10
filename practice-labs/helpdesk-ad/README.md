# Windows / Active Directory Help Desk Case — Lab Workbook

> **STATUS: NOT COMPLETED / NOT CLAIMED AS NEW EXPERIENCE.** This is a repeatable practice scenario and blank ticket package. The resume already lists school-based AD labs, but this separate support-case workflow has not been performed or verified.

## Goal
Show Tier-1 support ability to diagnose, communicate, document, verify and close (or correctly escalate) an access problem in a safe lab.

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

## Resume honesty rule
After this lab has been performed and screenshots/tickets are verified, you may add a bullet indicating **lab** experience documenting AD troubleshooting and resolution. Until then, keep it out of your completed-project list.
