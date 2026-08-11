#!/usr/bin/env bash
set -e

echo "[*] STACKING ALL LAYERS: Initializing Master Concurrency Sequence..."

# 1. Execute local pipeline alignment
if [ -f "run_local_pipeline.sh" ]; then
    echo "[*] Layer 1: Running local pipeline..."
    bash run_local_pipeline.sh
fi

# 2. Execute mesh ledger sync
if [ -f "execute_mesh_sync.sh" ]; then
    echo "[*] Layer 2: Engaging mesh ledger..."
    bash execute_mesh_sync.sh
fi

# 3. Verify integration endpoints
if [ -f "verify_integration_layer.sh" ]; then
    echo "[*] Layer 3: Verifying integration..."
    bash verify_integration_layer.sh
fi

# 4. Run mass remediation
if [ -f "execute_mass_remediation.sh" ]; then
    echo "[*] Layer 4: Executing mass remediation..."
    bash execute_mass_remediation.sh
fi

# 5. Trigger autonomous swarm
if [ -f "trigger_autonomous_swarm.sh" ]; then
    echo "[*] Layer 5: Launching autonomous swarm..."
    bash trigger_autonomous_swarm.sh
fi

echo "[+] ALL LAYERS STACKED AND LOCKED."
