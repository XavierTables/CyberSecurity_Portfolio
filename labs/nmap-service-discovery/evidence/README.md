# Nmap Lab Evidence Index

[Lab report](../README.md)

**Source:** "Lab Exercise 5 — Nmap Security Scanner" — provided SecurePath instructional PDF.

The three images are crops of the terminal output printed in **instructor slides**. They were not taken from an original Nmap log or a fresh scan. Every crop includes a label documenting its slide source.

| Image | Source page | Visible command and evidence |
| --- | --- | --- |
| [Default TCP scan](nmap-default-ports.webp) | 22 | \`nmap 10.0.2.4\`; 23 displayed open TCP ports |
| [OS fingerprint](nmap-os-fingerprint.webp) | 24 | \`nmap -O 10.0.2.4\`; Linux 2.6.x estimate |
| [Full range](nmap-full-port-range.webp) | 25 | \`nmap -O 10.0.2.4 -p 1-65535\`; 30 displayed open TCP ports and estimated OS |

**Evidence limitations:** The screenshots show a July 15, 2025 example, whereas the trainee's CySA+ coursework took place later. The screenshots alone do not establish exact service versions, vulnerability validation, public exposure, or independent execution by the trainee.

For defensible conclusions, the report uses only commands and outputs visible in these instructional excerpts, and distinguishes interpretations from observed details.
