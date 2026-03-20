# Contributing to Slyme OS

## Building the ISO

Requirements: Arch Linux host machine, `archiso` installed.
```bash
sudo pacman -S archiso
git clone https://github.com/slyme-os/slyme-os
cd slyme-os

# Download Ollama binary (excluded from repo due to size)
curl -fL "https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64" \
  -o iso-profile/slyme-os/airootfs/usr/local/bin/ollama
chmod +x iso-profile/slyme-os/airootfs/usr/local/bin/ollama

# Build SLIWM (source in sliwm/)
cd sliwm && make && cp sliwm ../iso-profile/slyme-os/airootfs/usr/local/bin/
cd ..

# Build the ISO
sudo mkarchiso -v -w /tmp/slyme-work -o ./output ./iso-profile/slyme-os
```

## What needs help right now
- Testing on real hardware (report your GPU + results in Issues)
- slyme-index: semantic file search daemon
- slyme-clip: AI clipboard manager
- slyme.nvim: Neovim plugin suite
- Voice input via Whisper

## Reporting bugs
Open an issue with your hardware info: `inxi -Fxz`
