# SOC Incident Brief — Windows Account Activity and VPN Geographic Anomalies

**Case:** LAB-SIEM-003 · **Environment:** Authorized TryHackMe training dataset · **Status:** Investigation documented; production validation not performed  
**Analyst:** Xavier Tables · **Tool:** Splunk / SPL · **Classification:** Suspicious activity, compromise unconfirmed

## Question
Do the observed Windows account-management events or unusual VPN locations establish unauthorized activity?

## Evidence reviewed
- **Windows:** 12,256-event dataset. Rare account-management events involving `James` and `Alberto`; network logon associated with Logon ID `0x551686`; related Security records and Sysmon process ancestry featuring `WmiPrvSE.exe`, `net.exe`, `conhost.exe`, and `net1.exe`.
- **VPN:** 2,000-event dataset. `jsmith`: 199 US-labelled and one Japan-labelled event. `kbrown`: 199 Germany-labelled and one Australia-labelled event. A `streamstats` search identified four consecutive country-label transitions (15–57 minutes) around **two** rare-country events.
- **Artifacts:** Eleven documented SPL searches and nine supporting screenshots.

## Findings and judgment
**Windows — suspicious administrative activity; authorization unverified.** Logon-ID, account, event-order and process evidence raise questions, but the recorded Security/Sysmon searches did not consistently scope or display the host, and matching same-session boundaries were **not established**. The evidence does not prove malicious WMI activity, elevated group membership, or account compromise.

**VPN — anomalous geography; identity verification required.** The rapid US/JP and DE/AU transitions warrant follow-up. IP geolocation, corporate routing, VPN/proxy infrastructure, devices and MFA outcomes were not validated. Country changes alone do not prove impossible physical travel or credential theft.

## Disposition and next steps
**No compromise confirmed. Do not close the production-equivalent investigation as a benign false positive without additional verification.** Validate the Windows host and session linkage, administrative change authorization, group privileges and surrounding EDR telemetry. For VPN events, check the account owner, device, MFA results, geolocation confidence and IP ownership. Escalate if authorization fails or corroborating indicators appear.

## Scope / integrity
This is a **summary of a completed training-data investigation**, not a production incident or a verified host-scoped reconstruction. No containment or remediation was performed. Case evidence and limitations: [Full investigation](../projects/splunk-siem-investigation/README.md) · [Original SPL query trail](../projects/splunk-siem-investigation/queries/investigation-queries.md) · [Proposed validation plan](splunk-correlation-validation-plan.md).
