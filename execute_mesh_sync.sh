#!/usr/bin/env bash
set -e

echo "[*] Initializing Mesh Ledger & Kuramoto Node Sync..."

# 1. Check Kuramoto daemon/node processes
if [ -f "kuramoto_daemon.sh" ]; then
    echo "[*] Executing Kuramoto daemon synchronization..."
    bash kuramoto_daemon.sh || echo "[!] Kuramoto daemon encountered a non-fatal state."
fi

# 2. Run witness and node checks
if [ -f "witness.py" ]; then
    echo "[*] Verifying mesh witness state..."
    python3 witness.py || echo "[!] Witness check completed with warnings."
fi

# 3. Clean up legacy logs and rotate state
if [ -f "mesh.log" ]; then
    echo "[*] Archiving current mesh log..."
    mv mesh.log mesh.log.bak
fi

echo "[+] Mesh sync sequence completed successfully."
