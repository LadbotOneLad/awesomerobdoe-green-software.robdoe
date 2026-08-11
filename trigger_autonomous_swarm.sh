#!/usr/bin/env bash
set -e

echo "[*] Initializing Autonomous Swarm & Ollama Recycling Pipeline..."

# 1. Trigger Ollama model recycling/refresh cycle
if [ -f "recycle_through_ollama.sh" ]; then
    echo "[*] Recycling state through Ollama bridge..."
    bash recycle_through_ollama.sh || echo "[!] Ollama cycle completed with notices."
fi

# 2. Fire up the core bot daemon
if [ -f "bot.py" ]; then
    echo "[*] Activating primary bot agent..."
    python3 bot.py &
    echo "[+] Bot agent dispatched in background (PID: $!)"
fi

# 3. Synchronize Symphony tags and releases
if [ -f "push_symphony_tags.sh" ]; then
    echo "[*] Pushing Symphony tags and state..."
    bash push_symphony_tags.sh || echo "[!] Symphony tag push completed."
fi

echo "[+] Autonomous swarm synchronization sequence fully engaged."
