# Network and Authentication Labs

[Back to my portfolio](../README.md)

These are technical write-ups from topics I studied in Tri-C SecurePath's CySA+ training. I focused on interpreting results, explaining the risk, and deciding what an analyst should verify next.

| Analysis | Key result | What it demonstrates |
| --- | --- | --- |
| **[SSH and VNC authentication](remote-access-security/README.md)** | SSH session as `msfadmin`; weak VNC password accepted | Authentication testing, access verification, and careful conclusions |
| **[Nmap network reconnaissance](nmap-service-discovery/README.md)** | 23 open ports in a default scan, 30 in a full-range scan | Port discovery, service analysis, and investigation priorities |
| **[SMTP user enumeration](smtp-enumeration/README.md)** | Different SMTP `VRFY` responses | Protocol analysis and enumeration risk |

The terminal figures and their original source pages are linked in each report's evidence index: [SSH/VNC](remote-access-security/evidence/README.md) · [Nmap](nmap-service-discovery/evidence/README.md).

[Hands-on reproduction guide](reproduce-and-capture.md) · [Evidence capture script](tools/capture-nmap.sh) · [Featured SOC work](../README.md#lab-projects)
