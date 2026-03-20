#!/usr/bin/env bash
# Slyme OS — First boot model pull
# Runs once after install to pull the default model

LOG="/var/log/slyme-first-boot.log"
STAMP="/var/lib/ollama/.first-boot-done"

if [[ -f "$STAMP" ]]; then
    exit 0
fi

echo "[slyme-first-boot] Starting first-boot setup..." | tee -a "$LOG"

# Wait for network
for i in $(seq 1 20); do
    ping -c1 -W2 8.8.8.8 > /dev/null 2>&1 && break
    echo "[slyme-first-boot] Waiting for network... ($i/20)" | tee -a "$LOG"
    sleep 3
done

# Wait for Ollama
for i in $(seq 1 15); do
    curl -sf http://localhost:11434/api/version > /dev/null 2>&1 && break
    sleep 2
done

# Pull default model
if curl -sf http://localhost:11434/api/version > /dev/null 2>&1; then
    echo "[slyme-first-boot] Pulling phi3:mini (default fast model)..." | tee -a "$LOG"
    /usr/local/bin/ollama pull phi3:mini 2>&1 | tee -a "$LOG"
    echo "[slyme-first-boot] Done." | tee -a "$LOG"
else
    echo "[slyme-first-boot] Ollama not ready — skipping model pull." | tee -a "$LOG"
    echo "[slyme-first-boot] Run manually: ollama pull phi3:mini" | tee -a "$LOG"
fi

touch "$STAMP"
