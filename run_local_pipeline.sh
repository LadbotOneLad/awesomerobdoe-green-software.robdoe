#!/usr/bin/env bash
set -e

echo "[*] ATOM-TRUTH | GENESIS Pipeline Initialized..."
echo "[*] Working Directory: $(pwd)"

# 1. Run local security and vulnerability scan matching CI parameters
if command -v trivy &> /dev/null; then
    echo "[*] Running Trivy filesystem vulnerability scan..."
    trivy fs --format sarif --output trivy-results.sarif .
    echo "[+] Generated: trivy-results.sarif"
else
    echo "[!] Trivy not found in PATH. Skipping local security scan generation."
fi

# 2. Execute local bridge check or daemon sync if available
if [ -f "ollama_bridge.py" ]; then
    echo "[*] Checking Ollama bridge status..."
    python3 ollama_bridge.py --check || echo "[!] Ollama bridge check returned non-zero."
fi

# 3. Verify repository state and sync permissions
if [ -f "robrootauthcli.js" ]; then
    echo "[*] Running root authority verification CLI..."
    node robrootauthcli.js --verify || echo "[!] CLI verification bypassed or completed with warnings."
fi

echo "[+] Pipeline alignment routine complete."
