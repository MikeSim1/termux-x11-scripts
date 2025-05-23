#!/bin/bash

echo "Ensure termux-x11-nightly is installed."
echo "You may need to download the apk direct from termux-x11 github."
echo "The apk you want will be named something similar to app-universal-debug.apk"

cd ~

pkg update
pkg upgrade
pkg install x11-repo

# TODO: Check termux-x11 installed. Look for Android package com.termux.x11?

pkg install pulseaudio
pkg install xfce4
pkg install virglrenderer-android
pkg install firefox

echo "Done updating and installing packages."
echo "Adding script to setup and start xfce4 desktop."

# TODO: Check if file exists before continuing
tee -a startxfce4_termux.sh << EOF
#!/data/data/com.termux/files/usr/bin/bash

# Kill open X11 processes
kill -9 $(pgrep -f "termux.x11") 2>/dev/null

# Start virgl_renderer for GPU acceleration if possible
virgl_test_server_android &

# Enable PulseAudio over Network
#pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

# Prepare termux-x11 session
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 >/dev/null &

# Wait a bit until termux-x11 gets started.
sleep 3

# Launch Termux X11 main activity
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1

# Set audio server
#export PULSE_SERVER=127.0.0.1

# Run XFCE4 Desktop
env DISPLAY=:0 dbus-launch --exit-with-session xfce4-session & > /dev/null 2>&1

exit 0
EOF
