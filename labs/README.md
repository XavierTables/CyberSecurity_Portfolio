# Cybersecurity Labs — Network and Authentication Analysis

[Back to my portfolio](../README.md)

These exercises are from my CySA+ coursework at Tri-C SecurePath. I use them to work through how tools report results, what those results actually establish, and what I'd investigate or recommend next. I kept the reports focused on the technical questions rather than reproducing step-by-step classroom slides.

| Lab | What I investigated | Main takeaway |
| --- | --- | --- |
| **[SSH and VNC authentication](remote-access-security/README.md)** | Weak credentials, SSH shell verification, and VNC login testing | An accepted credential and a confirmed remote session aren't interchangeable |
| **[Nmap network reconnaissance](nmap-service-discovery/README.md)** | Default vs full-range port discovery and OS fingerprinting | Seven more listeners appeared in the full-range scan; each needs validation |
| **[SMTP user enumeration](smtp-enumeration/README.md)** | `VRFY` responses and account-enumeration risk | SMTP reply codes need careful interpretation before claiming account validity |

**Evidence:** I retained screenshots from the course materials for reference; individual [SSH/VNC](remote-access-security/evidence/README.md) and [Nmap](nmap-service-discovery/evidence/README.md) evidence indexes identify their sources. My written analysis is separate from those instructional images.

[Practice commands and evidence-capture checklist](reproduce-and-capture.md) · [Featured SOC investigations](../README.md#lab-projects)
