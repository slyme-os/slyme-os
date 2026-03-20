#!/usr/bin/env python3
"""
Slyme OS — AI Daemon (slyme-ai)
Middleware between OS components and local LLM via Ollama.
Exposes a Unix socket at /run/slyme-ai.sock
"""

import os
import sys
import json
import socket
import logging
import threading
import subprocess
import time
from pathlib import Path

# ── Config ────────────────────────────────────────────────────
SOCKET_PATH   = os.environ.get("SLYME_AI_SOCKET", "/run/slyme-ai.sock")
OLLAMA_HOST   = os.environ.get("OLLAMA_HOST", "127.0.0.1:11434")
OLLAMA_URL    = f"http://{OLLAMA_HOST}"
LOG_FILE      = "/var/log/slyme-ai.log"
DEFAULT_MODEL = "phi3:mini"        # fast path
DEEP_MODEL    = "mistral:7b-instruct"  # deep path
DEGRADED      = os.environ.get("SLYME_DEGRADED", "0") == "1"
VERSION       = "0.9.9"

# ── Logging ───────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="[slyme-ai] %(asctime)s %(levelname)s: %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(sys.stdout),
    ]
)
log = logging.getLogger("slyme-ai")

# ── Ollama health check ───────────────────────────────────────
def ollama_ready() -> bool:
    try:
        import urllib.request
        req = urllib.request.urlopen(f"{OLLAMA_URL}/api/version", timeout=3)
        return req.status == 200
    except Exception:
        return False

def wait_for_ollama(timeout: int = 30) -> bool:
    log.info(f"Waiting for Ollama at {OLLAMA_URL} (timeout={timeout}s)...")
    for i in range(timeout):
        if ollama_ready():
            log.info("Ollama is ready.")
            return True
        time.sleep(1)
    log.warning("Ollama not reachable — entering degraded mode.")
    return False

# ── Query Ollama ──────────────────────────────────────────────
def query_ollama(prompt: str, model: str = None, context: dict = None) -> str:
    if DEGRADED:
        return json.dumps({
            "status": "degraded",
            "message": "slyme-ai is running in degraded mode. Ollama is not available.",
            "hint": "Run: ollama serve — then: systemctl restart slyme-ai"
        })

    if model is None:
        model = DEFAULT_MODEL

    payload = {
        "model": model,
        "prompt": prompt,
        "stream": False,
        "context": context or {},
        "options": {"temperature": 0.3, "num_predict": 512}
    }

    try:
        import urllib.request, urllib.error
        data = json.dumps(payload).encode()
        req = urllib.request.Request(
            f"{OLLAMA_URL}/api/generate",
            data=data,
            headers={"Content-Type": "application/json"},
            method="POST"
        )
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read())
            return json.dumps({
                "status": "ok",
                "response": result.get("response", ""),
                "model": model
            })
    except Exception as e:
        log.error(f"Ollama query failed: {e}")
        return json.dumps({"status": "error", "message": str(e)})

# ── Unix socket server ────────────────────────────────────────
def handle_client(conn: socket.socket):
    try:
        data = b""
        while True:
            chunk = conn.recv(4096)
            if not chunk:
                break
            data += chunk
            if data.endswith(b"\n"):
                break

        request = json.loads(data.decode().strip())
        action  = request.get("action", "query")

        if action == "ping":
            response = json.dumps({
                "status": "ok",
                "version": VERSION,
                "degraded": DEGRADED,
                "ollama": ollama_ready()
            })

        elif action == "query":
            prompt  = request.get("prompt", "")
            model   = request.get("model", None)
            context = request.get("context", {})
            response = query_ollama(prompt, model, context)

        elif action == "shell":
            # Natural language → shell command
            prompt = (
                f"Convert this to a single bash command. "
                f"Reply with ONLY the command, no explanation, no markdown:\n{request.get('input', '')}"
            )
            response = query_ollama(prompt, DEFAULT_MODEL)

        elif action == "explain_error":
            # Explain a shell error
            prompt = (
                f"Explain this shell error briefly and suggest a fix:\n"
                f"Command: {request.get('command', '')}\n"
                f"Error: {request.get('error', '')}"
            )
            response = query_ollama(prompt, DEFAULT_MODEL)

        elif action == "status":
            response = json.dumps({
                "status": "ok",
                "version": VERSION,
                "degraded": DEGRADED,
                "ollama_ready": ollama_ready(),
                "socket": SOCKET_PATH,
                "default_model": DEFAULT_MODEL,
                "deep_model": DEEP_MODEL,
                "pid": os.getpid()
            })

        else:
            response = json.dumps({"status": "error", "message": f"Unknown action: {action}"})

        conn.sendall((response + "\n").encode())

    except json.JSONDecodeError as e:
        conn.sendall((json.dumps({"status": "error", "message": f"Invalid JSON: {e}"}) + "\n").encode())
    except Exception as e:
        log.error(f"Client handler error: {e}")
    finally:
        conn.close()

def run_server():
    # Remove stale socket
    if Path(SOCKET_PATH).exists():
        os.unlink(SOCKET_PATH)

    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server.bind(SOCKET_PATH)
    os.chmod(SOCKET_PATH, 0o666)
    server.listen(16)
    log.info(f"slyme-ai socket ready at {SOCKET_PATH}")

    while True:
        try:
            conn, _ = server.accept()
            t = threading.Thread(target=handle_client, args=(conn,), daemon=True)
            t.start()
        except KeyboardInterrupt:
            break
        except Exception as e:
            log.error(f"Server error: {e}")

# ── Entry point ───────────────────────────────────────────────
if __name__ == "__main__":
    log.info(f"slyme-ai v{VERSION} starting...")

    if not DEGRADED:
        ready = wait_for_ollama(timeout=30)
        if not ready:
            os.environ["SLYME_DEGRADED"] = "1"
            globals()["DEGRADED"] = True

    if DEGRADED:
        log.warning("="*50)
        log.warning("DEGRADED MODE — Ollama not available")
        log.warning("AI features disabled. Socket still active.")
        log.warning("Run 'ollama serve' to restore full function.")
        log.warning("="*50)
    else:
        log.info(f"Full mode — models: fast={DEFAULT_MODEL} deep={DEEP_MODEL}")

    run_server()
