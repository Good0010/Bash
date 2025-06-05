#!/bin/bash

# ---------- Module 01: Variables and Functions ----------
target="$1"
outfile="scan_$(date +%F_%H-%M-%S).txt"

function banner() {
    echo "==========================================="
    echo "🛡️  NRVS - Network Recon & Vulnerability Scanner"
    echo "Target: $target"
    echo "Output File: $outfile"
    echo "==========================================="
}

# ---------- Module 02: Using Arrays ----------
common_ports=(21 22 23 25 53 80 110 139 143 443 445 8080)

# ---------- Module 03: Basic Operators + 04: Decision Making ----------
if [ $# -eq 0 ]; then
    echo "❌ Usage: $0 <target IP or domain>"
    exit 1
fi

# ---------- Module 05: Shell Loops + 06: Loop Control ----------
function port_scan() {
    echo "[*] Scanning common ports..."
    for port in "${common_ports[@]}"; do
        timeout 1 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "✅ Port $port is open" | tee -a "$outfile"
        else
            echo "❌ Port $port is closed" >> "$outfile"
            continue
        fi
    done
}

# ---------- Module 07: Shell Substitution ----------
function resolve_hostname() {
    hostname=$(host "$target" | grep "domain name pointer" | cut -d " " -f5)
    echo "🔎 Hostname: ${hostname:-Not Found}" >> "$outfile"
}

# ---------- Module 08: Quoting Mechanisms ----------
function ping_check() {
    echo "[*] Pinging \"$target\"..."
    ping -c 1 "$target" > /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Host is alive" | tee -a "$outfile"
    else
        echo "❌ Host is down" | tee -a "$outfile"
        exit 1
    fi
}

# ---------- Module 10: Shell Functions + 09: IO Redirection ----------
function save_summary() {
    echo "[*] Scan completed at $(date)" >> "$outfile"
    echo "📄 Output saved to '$outfile'"
}

# ----------------- Run the Tool -----------------
banner
ping_check
resolve_hostname
port_scan
save_summary
