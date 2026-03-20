#!/bin/sh
# Slyme OS — X session init

# Set cursor shape
xsetroot -cursor_name left_ptr &

# Set solid black background
xsetroot -solid "#030703" &

# Set DPI
xrandr --dpi 96 &

# Start slyme-ai if not already running
if ! pgrep -x slyme-ai > /dev/null; then
    slyme-ai &
fi

# Launch SLIWM (exec keeps PID, session ends when WM exits)
exec sliwm
