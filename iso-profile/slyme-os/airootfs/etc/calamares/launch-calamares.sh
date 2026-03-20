#!/usr/bin/env bash
# Launch Calamares installer with sudo (needs root for partitioning)
if [ "$EUID" -ne 0 ]; then
    exec sudo -E calamares -D8
else
    exec calamares -D8
fi
