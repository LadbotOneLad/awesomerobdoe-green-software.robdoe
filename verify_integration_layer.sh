#!/usr/bin/env bash
set -e

echo "[*] Scanning integration and bridge endpoints..."

# 1. Verify Node and NPM dependency alignment
if [ -f "package.json" ]; then
    echo "[*] Checking package dependencies..."
    npm ls --depth=0 || echo "[!] Some node dependencies require review or installation."
fi

# 2. Test Cloudflare / Edge tunnel routing status
if [ -d "cloudflare" ] || [ -f "cloudflared-termux" ]; then
    echo "[*] Checking Cloudflare tunnel configuration..."
    if command -v cloudflared &> /dev/null; then
        cloudflared tunnel info || echo "[!] Tunnel inactive or requires authentication."
    else
        echo "[!] Cloudflared binary not directly in PATH."
    fi
fi

# 3. Check Proxmark3 hardware bridge state if connected
if [ -d "proxmark3" ]; then
    echo "[*] Inspecting Proxmark3 workspace hooks..."
    if [ -S "/dev/ttyACM0" ] || [ -S "/dev/ttyUSB0" ]; then
        echo "[+] Serial hardware interface detected."
    else
        echo "[!] No active TTY serial interface found for hardware bridge."
    fi
fi

echo "[+] Integration layer audit complete."
