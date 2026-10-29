# Recreate the CySA+ Labs and Collect Your Own Evidence

[Supplemental labs](README.md) · [SSH/VNC analysis](remote-access-security/README.md) · [Nmap analysis](nmap-service-discovery/README.md)

This is the **practical upgrade path** for the guided-lab reports. The currently published screenshots are instructor-slide examples. When I repeat the steps and save original output, I can replace them with screenshots I genuinely captured and update the report's observed results.

**Only perform these steps on Kali and Metasploitable VMs you own or are explicitly authorized to test.** Metasploitable 2 is deliberately vulnerable. Keep it disconnected from production networks and do not use bridged networking.

## A. Get the lab ready

1. Open VirtualBox. Start one Kali Linux VM and one Metasploitable 2 VM.
2. Put both network adapters on the same **Internal Network** (same network name), or use a properly restricted host-only network. Do **not** connect Metasploitable to bridged networking or port-forward its services onto the internet.
3. In Metasploitable, log in with the exercise's published credentials `msfadmin / msfadmin`.
4. On Metasploitable, type `ip -br addr` or `ip a` and record the address of the lab-network interface. In Kali, do the same. Confirm both are in the intended isolated segment.
5. From Kali, check that the lab target responds. Replace **LAB_IP** below with the actual address of *your own VM*, not the slide's example IP.

In a Kali terminal:

```bash
export LAB_IP="YOUR_METASPLOITABLE_IP"
mkdir -p "$HOME/cysa-lab-evidence"
date -u
ip -br addr
```

The date, host address, VM network configuration, and command output help establish that a new test was actually performed. If a connection fails, check the virtual network and target address before assuming any exploit succeeded.

## B. Repeat Nmap discovery

Run these separately and save the real results:

```bash
nmap "$LAB_IP" -oN "$HOME/cysa-lab-evidence/nmap-default.txt"
nmap -sV -p 22,25,5900 "$LAB_IP" -oN "$HOME/cysa-lab-evidence/nmap-services.txt"
sudo nmap -O "$LAB_IP" -oN "$HOME/cysa-lab-evidence/nmap-os.txt"
sudo nmap -O -p 1-65535 "$LAB_IP" -oN "$HOME/cysa-lab-evidence/nmap-all-tcp.txt"
```

**Capture:** A screenshot of the command plus its output for each scan. Keep each associated `.txt` file. The number of open ports on a new setup may differ from the 23/30 in the older training slides—**report the new results**, do not force the old numbers.

**Think like an analyst:** Which services are confirmed, which are only Nmap labels, and which require `-sV` or host-level validation?

## C. Repeat the SSH account check

In Kali:

```text
msfconsole
use auxiliary/scanner/ssh/ssh_login
set RHOSTS YOUR_METASPLOITABLE_IP
set USERNAME msfadmin
set PASSWORD msfadmin
set STOP_ON_SUCCESS true
show options
run
sessions -l
```

Only if an SSH session actually appears, select the **session ID shown in your output**:

```text
sessions -i SESSION_ID
whoami
id
```

**Capture:** Module options, accepted authentication result, actual session list, and `whoami`/`id`. Do not write "root shell" unless the live result proves it. If modern Kali refuses an old SSH algorithm, document the incompatibility; don't silently change system-wide security settings or claim success anyway.

## D. Repeat the VNC password check

First confirm the service:

```bash
nmap -sV -p 5900 "$LAB_IP" -oN "$HOME/cysa-lab-evidence/nmap-vnc.txt"
```

In Metasploit:

```text
use auxiliary/scanner/vnc/vnc_login
set RHOSTS YOUR_METASPLOITABLE_IP
set RPORT 5900
set PASSWORD password
show options
run
```

**Capture:** Open VNC port, selected module options, and actual authentication result. A scanner's "Login Successful" line proves its authentication attempt was accepted; it does not by itself prove that you controlled a remote desktop. If you later verify a graphical viewer session in this authorized lab, document that as an additional, separate observation.

## E. Finish the security story

For each lab, write short answers in your own words:

1. **Question:** What did I test?
2. **Procedure:** What commands did I actually run, against what authorized VM?
3. **Evidence:** What does each screenshot or saved log prove?
4. **Meaning:** Why would this behavior matter in a real organization?
5. **Limit:** What does the data *not* demonstrate?
6. **Remediation:** What would I change, and how would I verify the change?

### Evidence checklist

- [ ] Screenshot of VM network settings demonstrating the intended isolated environment
- [ ] Kali and target IPs documented, with date and scope
- [ ] Original Nmap output saved with `-oN`
- [ ] SSH login output and actual session identity captured (if successful)
- [ ] VNC scan output captured (whether successful or unsuccessful)
- [ ] Written interpretation using only results actually observed
- [ ] Image names, links, and source descriptions updated in GitHub
- [ ] Instructor-slide reference images replaced or clearly distinguished from original screenshots

### What to say in an interview

> "I completed these activities during SecurePath. I later reviewed the saved course examples and documented what the evidence proves. The Nmap exercise taught me why default port coverage can miss services, and the SSH/VNC exercises taught me to distinguish authentication success from verified access. Where I've reproduced a test myself, I've linked my own output separately."

When you do capture original scans, change the report from "guided example" to "independent lab reproduction" **only for the steps you truly reproduced**.

## Official references

- [Nmap manual](https://nmap.org/book/man.html)
- [Metasploit SSH login module](https://github.com/rapid7/metasploit-framework/blob/master/documentation/modules/auxiliary/scanner/ssh/ssh_login.md)
- [Metasploit VNC login module source](https://github.com/rapid7/metasploit-framework/blob/master/modules/auxiliary/scanner/vnc/vnc_login.rb)
- [VirtualBox manual — networking modes](https://www.virtualbox.org/manual/ch06.html)
