#!/usr/bin/env bash
# Collect reproducible Nmap evidence from an isolated, authorized test VM.
set -Eeuo pipefail

if [[ "$#" -ne 1 ]]; then
  echo "Usage: bash capture-nmap.sh <YOUR_ISOLATED_METASPLOITABLE_IP>" >&2
  exit 2
fi
TARGET="$1"
python3 - "$TARGET" <<'PY'
import ipaddress, sys
try:
    target = ipaddress.IPv4Address(sys.argv[1])
except ipaddress.AddressValueError:
    sys.exit("Provide a valid IPv4 address.")
allowed = tuple(ipaddress.ip_network(n) for n in (
    "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"))
if not any(target in network for network in allowed):
    sys.exit("This script only accepts RFC1918 private IPv4 addresses.")
PY

for bin in nmap python3 sha256sum sudo; do
  command -v "$bin" >/dev/null 2>&1 || {
    echo "Missing required command: $bin" >&2
    exit 2
  }
done

echo "Target: $TARGET"
echo "This must be YOUR deliberately vulnerable Metasploitable VM on an isolated"
echo "VirtualBox Internal Network or tightly restricted host-only network."
echo "A private IP address alone does NOT prove that the network is safe."
if [[ ! -t 0 ]]; then
  echo "Interactive confirmation required. Run this script in a terminal." >&2
  exit 2
fi
read -r -p "Type ISOLATED to confirm authorized, isolated scope: " CONFIRM
if [[ "$CONFIRM" != "ISOLATED" ]]; then
  echo "No scanning performed."
  exit 2
fi

OUT="$HOME/cysa-evidence/$(date -u '+%Y%m%dT%H%M%SZ')"
mkdir -p "$OUT"
chmod 700 "$OUT"
{
  echo "Captured (UTC): $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Target: $TARGET"
  echo "Tool version:"
  nmap --version | head -n 1
  echo "Kali interface inventory:"
  ip -br addr || true
  echo "Scope: user-confirmed authorized isolated training VM"
} > "$OUT/manifest.txt"

echo "Writing Nmap results to $OUT"
nmap "$TARGET" -oA "$OUT/nmap-default" 2>&1 | tee "$OUT/default-console.txt"
nmap -sV -p 22,25,5900 "$TARGET" -oA "$OUT/nmap-targeted-services" 2>&1 | tee "$OUT/services-console.txt"

echo "OS and full-range scans may require your Kali sudo password."
sudo nmap -O "$TARGET" -oA "$OUT/nmap-os" 2>&1 | tee "$OUT/os-console.txt"
sudo nmap -O -p 1-65535 "$TARGET" -oA "$OUT/nmap-full-tcp" 2>&1 | tee "$OUT/full-console.txt"

# Build single-target Metasploit resource files. They are NOT executed by this script.
cat > "$OUT/ssh-single-login.rc" <<EOF
use auxiliary/scanner/ssh/ssh_login
set RHOSTS $TARGET
set RPORT 22
set USERNAME msfadmin
set PASSWORD msfadmin
set STOP_ON_SUCCESS true
set CreateSession true
show options
run
sessions -l
EOF
cat > "$OUT/vnc-single-login.rc" <<EOF
use auxiliary/scanner/vnc/vnc_login
set RHOSTS $TARGET
set RPORT 5900
set PASSWORD password
show options
run
EOF
(
  cd "$OUT"
  sha256sum manifest.txt *.nmap *.xml *.gnmap *-console.txt *.rc > SHA256SUMS.txt
)
cat <<EOF

Real scan output saved in:
  $OUT

For the authentication exercises, only on your isolated VM:
  msfconsole -q -r "$OUT/ssh-single-login.rc" | tee "$OUT/ssh-result.txt"
  msfconsole -q -r "$OUT/vnc-single-login.rc" | tee "$OUT/vnc-result.txt"

If SSH opens a session, manually check 'sessions -l', 'sessions -i <ID>',
'whoami', and 'id'; screenshot the actual result. If it does not open a
session, record that limitation instead. Review the module options before
running either login test. The two .rc files use only the known lab credentials.

Upload your OWN generated output and screenshots for a proper independent
verification report. Do not substitute the course's historical screenshots.
EOF
