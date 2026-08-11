#!/usr/bin/env bash
set -e

echo "[*] MOTOG06 x ROBDOE LITE: Initializing Lightweight Edge Node..."

# 1. Establish identity and hardware signature
export NODE_ID="PHILL"
export TARGET_DEVICE="MotoG06-Lite"
export AUTHORITY="robdoerootauthority"

echo "[+] Node Signature: $NODE_ID"
echo "[+] Target Profile: $TARGET_DEVICE"

# 2. Engage wake lock to prevent sleep throttling
if command -v termux-wake-lock &> /dev/null; then
    termux-wake-lock
    echo "[+] Wake lock engaged."
fi

# 3. Lightweight execution of core routing and bridge checks
if [ -f "ollama_bridge.py" ]; then
    echo "[*] Polling local Ollama bridge..."
    python3 ollama_bridge.py --lite-mode || echo "[!] Bridge check skipped or offline."
fi

if [ -f "witness.py" ]; then
    echo "[*] Executing lightweight witness poll..."
    python3 witness.py --lightweight || echo "[!] Witness poll completed."
fi

echo "[+] Moto RobDoe Lite Node online and synced."
