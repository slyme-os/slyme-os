<div align="center">

```
 ███████╗██╗  ██╗   ██╗███╗   ███╗███████╗      ██████╗ ███████╗
 ██╔════╝██║  ╚██╗ ██╔╝████╗ ████║██╔════╝     ██╔═══██╗██╔════╝
 ███████╗██║   ╚████╔╝ ██╔████╔██║█████╗       ██║   ██║███████╗
 ╚════██║██║    ╚██╔╝  ██║╚██╔╝██║██╔══╝       ██║   ██║╚════██║
 ███████║███████╗██║   ██║ ╚═╝ ██║███████╗     ╚██████╔╝███████║
 ╚══════╝╚══════╝╚═╝   ╚═╝     ╚═╝╚══════╝      ╚═════╝ ╚══════╝
```

**AI-Native Linux. Local. Private. Yours.**

[![Version](https://img.shields.io/badge/version-0.9.9--beta-39ff14?style=flat-square&labelColor=030703)](https://github.com/slyme-os/slyme-os/releases)
[![Kernel](https://img.shields.io/badge/kernel-linux--zen-39ff14?style=flat-square&labelColor=030703)](https://github.com/zen-kernel/zen-kernel)
[![Base](https://img.shields.io/badge/base-Arch%20Linux-39ff14?style=flat-square&labelColor=030703)](https://archlinux.org)
[![AI](https://img.shields.io/badge/AI-100%25%20local-39ff14?style=flat-square&labelColor=030703)](https://ollama.com)
[![License](https://img.shields.io/badge/license-MIT-39ff14?style=flat-square&labelColor=030703)](LICENSE)
[![ISO](https://img.shields.io/badge/ISO-1.6GB-39ff14?style=flat-square&labelColor=030703)](https://github.com/slyme-os/slyme-os/releases)

[Download ISO](#-download) · [Features](#-features) · [Install](#-installation) · [Architecture](#-architecture) · [Roadmap](#-roadmap)

</div>

---

## What is Slyme OS?

Slyme OS is a custom Arch Linux distribution where **AI is a system primitive, not an app**.

Most "AI-powered" tools bolt a chatbot onto an existing system. Slyme OS is architected differently — a unified AI daemon (`slyme-ai`) runs as a systemd service at boot, exposes a Unix socket, and every component of the OS talks to it. The shell, the window manager, the file system, the editor, the clipboard — all AI-aware, all local, all private.

```
$ !! find all python files modified today larger than 10kb
→ find . -name "*.py" -newer $TODAY -size +10k 2>/dev/null
[confirm? y/N] y
./src/daemon.py  ./lib/context.py

$ slime "why is my build failing"
▸ Based on your recent commands and the error in your clipboard,
  the issue is a missing libxft dependency. Run: sudo pacman -S libxft

$ slyme-status
● ollama daemon     online
● slyme-ai daemon   online  (mistral:7b · phi3:mini)
● NetworkManager    online
```

**No cloud. No API keys. No accounts. No data leaves your machine.**

---

## ✦ Features

### Core System
| Component | Details |
|---|---|
| **Base** | Arch Linux via archiso |
| **Kernel** | linux-zen (low-latency, AI inference optimized) |
| **Window Manager** | SLIWM — custom DWM fork, keyboard-driven tiling |
| **Terminal** | Kitty |
| **Shell** | zsh with slyme-shell AI hooks |
| **Editor** | Neovim (LazyVim config + slyme.nvim planned) |
| **Launcher** | dmenu |
| **Init** | systemd |
| **Boot** | GRUB (UEFI) + Syslinux (BIOS) |

### The AI Stack

**`slyme-ai` — The AI Daemon**

The architectural core. A Python systemd service running at boot, exposing `/run/slyme-ai.sock`. Every OS component gets AI via this single socket — swap models, change routing, add features without touching dependent tools.

```
┌─────────────────────────────────────────┐
│  slime · shell hooks · nvim · WM · ...  │  ← OS components
└──────────────────┬──────────────────────┘
                   │ Unix socket
         ┌─────────▼──────────┐
         │    slyme-ai daemon  │  ← single AI middleware
         │  /run/slyme-ai.sock │
         └─────────┬──────────┘
                   │
         ┌─────────▼──────────┐
         │       Ollama        │  ← local inference
         │  127.0.0.1:11434   │
         └────────────────────┘
```

- **Dual model routing** — `phi3:mini` (~80ms) for shell, `mistral:7b` for deep queries
- **System context injection** — every AI call auto-enriched with cwd, clipboard, git branch, recent commands, focused window
- **Degraded mode** — if Ollama is unavailable, daemon stays alive and returns structured errors. Nothing crashes.
- **Thread-safe** — 16 concurrent clients supported

**`slime` — The AI Interface**

```bash
slime                     # interactive chat with conversation history
slime "what does awk do"  # single query
slime --shell             # natural language → shell commands
slime --explain "error"   # explain and fix errors
slime --context           # show what AI sees about your system
slime --status            # daemon health check
cat error.log | slime     # pipe mode
```

**`slyme-status`**

```bash
$ slyme-status
  SLYME OS  ·  v0.9.9  ·  slyme-os.github.io

  ● Ollama daemon      online
  ● slyme-ai daemon    online
  ● NetworkManager     online
  ● Ollama API         online

  Models loaded: phi3:mini mistral:7b-instruct

  install-slyme   — launch the Calamares installer
  ollama pull phi3:mini — download fast AI model
```

### Privacy & Philosophy

- **Zero telemetry** — no tracking, no analytics, no crash reports sent anywhere
- **100% local AI** — Ollama runs entirely on your hardware
- **No accounts** — nothing requires signing in to anything
- **Air-gap ready** — fully functional with no internet connection
- **Suckless core** — SLIWM and tools are minimal C, auditable source
- **Open source** — read, fork, patch, own everything

---

## 📥 Download

| File | Size | SHA256 |
|---|---|---|
| `slyme-os-0.9.9-x86_64.iso` | 1.6GB | *(see release page)* |

**[→ Download from GitHub Releases](https://github.com/slyme-os/slyme-os/releases/latest)**

Verify integrity before flashing:
```bash
sha256sum slyme-os-0.9.9-x86_64.iso
# compare with the hash on the release page
```

---

## 💻 Hardware Requirements

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64, 4 cores | 8+ cores, AVX2 |
| RAM | 8GB | 16GB+ |
| VRAM | 4GB `(phi3:mini)` | 8GB+ `(mistral:7b)` |
| Storage | 40GB SSD | 100GB NVMe |
| GPU | Optional — CPU mode works | NVIDIA RTX 30/40xx · AMD RX 6000/7000 |

**No GPU?** The installer detects your hardware and auto-selects the right model. `phi3:mini` runs on CPU-only systems — slower but fully functional and private.

---

## 🔧 Installation

### Option A — Install to disk (recommended)

1. **Flash the ISO to USB**
```bash
# Replace /dev/sdX with your USB device — check with lsblk first
sudo dd if=slyme-os-0.9.9-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

2. **Boot from USB**
   - Select "Slyme OS 0.9.9 — Boot Live Session" from the boot menu

3. **Live session boots automatically**
   - Autologin as `slyme` (password: `slyme`)
   - SLIWM launches automatically
   - Open a terminal and run:
```bash
install-slyme
```

4. **Calamares installer guides you through**
   - Choose language, keyboard, timezone
   - Partition your disk (automatic or manual)
   - Create your user account
   - Install — fully offline, no internet required

5. **First boot**
   - All services start automatically
   - If internet is available, `phi3:mini` downloads in the background (~2GB)
   - Run `slyme-status` to check everything is running

### Option B — Test in QEMU before installing

```bash
# Create a virtual disk
qemu-img create -f qcow2 slyme-test.qcow2 30G

# Boot (BIOS mode)
sudo qemu-system-x86_64 \
  -m 4096 -smp 4 \
  -cdrom slyme-os-0.9.9-x86_64.iso \
  -hda slyme-test.qcow2 \
  -boot d -vga virtio -display gtk \
  -enable-kvm -cpu host \
  -net nic -net user

# Boot (UEFI mode)
cp /usr/share/edk2/x64/OVMF_VARS.4m.fd /tmp/slyme-uefi-vars.fd
sudo qemu-system-x86_64 \
  -m 4096 -smp 4 \
  -cdrom slyme-os-0.9.9-x86_64.iso \
  -hda slyme-test.qcow2 \
  -boot d -vga virtio -display gtk \
  -enable-kvm -cpu host \
  -net nic -net user \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file=/tmp/slyme-uefi-vars.fd
```

---

## 🏗 Architecture

### Boot Flow

```
GRUB/Syslinux boot menu
        ↓
linux-zen kernel
        ↓
systemd (ollama.service + slyme-ai.service start)
        ↓
ASCII art splash on TTY
        ↓
autologin → slyme user (no password prompt)
        ↓
.zprofile detects TTY1 → startx
        ↓
.xinitrc → xsetroot + slyme-ai check + exec sliwm
        ↓
SLIWM — full AI-native environment
```

### Key File Locations

```
/usr/local/bin/
  sliwm            window manager binary
  dmenu            application launcher
  ollama           LLM runtime (39MB)
  slyme-ai         AI daemon wrapper
  slyme-session    X session launcher
  slyme-status     system status overview
  slime            live AI interface

/usr/local/lib/slyme-ai/
  slyme-ai.py      daemon (Unix socket server, 208 lines)
  first-boot.sh    pulls phi3:mini on first network boot

/etc/systemd/system/
  ollama.service
  slyme-ai.service
  slyme-first-boot.service
  getty@tty1.service.d/autologin.conf

/etc/calamares/
  settings.conf
  modules/         12 installer module configs

/etc/skel/
  .xinitrc         launches SLIWM
  .zshrc           shell config with AI hooks
  .zprofile        auto-starts X on TTY1
  .config/nvim/    Neovim config
```

### The `slime` Socket Protocol

Any script or tool can talk to the AI daemon:

```bash
# From shell
echo '{"action":"query","prompt":"explain git rebase"}' | \
  socat - UNIX-CONNECT:/run/slyme-ai.sock

# From Python
import socket, json
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect("/run/slyme-ai.sock")
sock.sendall(json.dumps({"action":"shell","input":"find large files"}).encode() + b"\n")
response = json.loads(sock.recv(4096))
```

Available actions: `ping` `query` `shell` `explain_error` `status`

---

## 🗺 Roadmap

### v0.9.9 — Current (Beta)
- [x] Bootable ISO (BIOS + UEFI)
- [x] SLIWM window manager
- [x] slyme-ai daemon with Unix socket API
- [x] slime AI interface (chat, shell, explain, pipe modes)
- [x] Ollama integration with degraded mode fallback
- [x] Calamares offline installer with Slyme OS branding
- [x] Autologin + auto-startx flow
- [x] First-boot model pull service
- [x] ASCII boot splash + slyme-status command

### v1.0.0 — Shell Intelligence
- [ ] `slyme-shell` — natural language commands with live ghost suggestions
- [ ] Auto error explanation on non-zero exit codes
- [ ] Session recap (`slyme-recap`) — plain English summary of your terminal session
- [ ] Shell history AI ranking by context relevance

### v1.1.0 — File System Intelligence
- [ ] `slyme-index` — background embedding daemon (nomic-embed-text)
- [ ] `slyme-find` — semantic natural language file search across home directory
- [ ] SQLite vector store for embeddings
- [ ] ranger/lf integration for AI file summaries on hover

### v1.2.0 — Editor & Clipboard
- [ ] `slyme.nvim` — full Neovim plugin (completion, inline errors, git commit, test writer, refactor)
- [ ] `slyme-clip` — persistent AI-indexed clipboard with semantic search
- [ ] `slyme-git` — AI git workflow (PR review, changelog, smart blame)

### v1.3.0 — System Intelligence
- [ ] `slyme-monitor` — TUI system monitor with AI metric interpretation
- [ ] `slyme-logs` — journalctl wrapper with AI summarization and error detection
- [ ] Whisper voice input — system-wide voice-to-text via local Whisper model
- [ ] SLIWM patches — context-aware workspace modes, smart window titling

### Long Term
- [ ] Apple Silicon support
- [ ] ARM64 ISO build
- [ ] Slyme Pro — curated model packs, premium dotfile configs
- [ ] Enterprise packaging — air-gapped corporate deployment

---

## 🤝 Contributing

Slyme OS is early and actively developed. Contributions welcome.

```bash
# Clone the repo
git clone https://github.com/slyme-os/slyme-os
cd slyme-os

# Read the architecture doc
cat ARCHITECTURE.md

# Build the ISO locally (requires Arch Linux host + archiso)
sudo pacman -S archiso
sudo mkarchiso -v -w /tmp/slyme-work -o ./output ./iso-profile/slyme-os
```

**Good first contributions:**
- Test on real hardware and report GPU compatibility
- Add your hardware to the compatibility wiki
- Improve slyme-ai.py with new socket actions
- Write documentation for any undocumented component
- Build a SLIWM config example and share it

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

**Bug reports:** [GitHub Issues](https://github.com/slyme-os/slyme-os/issues)
Use the Bug Report template and include `inxi -Fxz` output.

---

## 📁 Repository Structure

```
slyme-os/
├── iso-profile/slyme-os/     archiso build profile
│   ├── airootfs/             live environment overlay
│   │   ├── etc/              system config, services, calamares
│   │   ├── usr/local/        all slyme binaries and scripts
│   │   └── root/             customize_airootfs.sh (runs at build)
│   ├── packages.x86_64       package list (121 packages)
│   ├── pacman.conf           includes local calamares repo
│   ├── profiledef.sh         ISO identity and file permissions
│   └── local-repo/           calamares 3.4.0 pre-built package
├── slime/
│   └── src/slime.py          the slime AI interface application
├── sliwm/                    SLIWM window manager source
├── config/
│   ├── zshrc                 zsh configuration
│   └── nvim/                 Neovim configuration
└── slyme-ai/
    └── slyme-ai.py           AI daemon source
```

---

## 🔐 Security

- All AI inference is local — prompts never leave your machine
- No telemetry, analytics, or crash reporting of any kind
- Ollama API bound to `127.0.0.1` only — not exposed on network
- Unix socket at `/run/slyme-ai.sock` with `chmod 666` — local access only
- Live session uses passwordless sudo (expected for live ISO, removed on install)
- Verify ISO integrity with SHA256 before flashing (hash on release page)

Found a security issue? Email [slyme@tutamail.com](mailto:slyme@tutamail.com) privately before opening a public issue.

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

The suckless components (SLIWM, dmenu) are MIT/X11 licensed per their upstream.
Ollama is MIT licensed. Calamares is GPL-3.0.

---

<div align="center">

**Built for the terminal generation.**

[slyme-os.github.io](https://slyme-os.github.io) · [GitHub](https://github.com/slyme-os) · [slyme@tutamail.com](mailto:slyme@tutamail.com)

```
$ echo "Stay terminal. Stay free."
Stay terminal. Stay free.
```

</div>
