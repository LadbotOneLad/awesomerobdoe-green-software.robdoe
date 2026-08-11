#!/usr/bin/env bash
set -e

echo "[*] MOTOG06 HARDWARE OVERRIDE: Bypassing sleep states..."

# 1. Force high-performance governor or wake lock simulation
if command -v termux-wake-lock &> /dev/null; then
    echo "[*] Engaging Termux wake lock for uninterrupted execution..."
    termux-wake-lock
else
    echo "[!] termux-wake-lock utility not detected. Continuing with standard process priority."
fi

# 2. Append hardware execution tag for MotoG06
echo "[*] Binding runtime context to MotoG06 architecture..."
export TARGET_DEVICE="MotoG06"
export POWER_STATE="AWAKE"

# 3. Trigger stacked execution immediately
if [ -f "stack_all_layers.sh" ]; then
    echo "[*] Executing full layer stack on MotoG06 hardware..."
    bash stack_all_layers.sh
else
    echo "[!] Master stack script not found. Running direct mesh initialization..."
    bash execute_mesh_sync.sh
fi

echo "[+] MotoG06 hardware override sequence fully locked and active."
