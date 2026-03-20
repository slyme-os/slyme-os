# Slyme OS Architecture

## The Core Principle
AI is a system primitive, not an application.
Every OS component talks to the slyme-ai daemon via Unix socket.

## Component Map
See README.md for the full architecture diagram.

## Key Files
- `iso-profile/slyme-os/` — archiso build profile
- `slyme-ai/slyme-ai.py` — AI daemon source
- `slime/src/slime.py` — user-facing AI interface
- `sliwm/` — window manager source

## Building from Source
See CONTRIBUTING.md
