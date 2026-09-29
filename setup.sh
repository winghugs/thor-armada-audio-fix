#!/bin/bash
set -e

# root check
if [ $(id -u) -eq 0 ]
  then echo "Please do not run this script as root, try again without sudo."
  exit
fi

echo "**** WARNING ****"
echo "This script is specifically meant to install the JamesDSP speaker profile used by projects OTPTweaks/ThorTune."
echo "Do not install this on any device other than the AYN Thor, if you do, your speakers will sound awful."
read -n 1 -s -r -p "Press any key to continue, or CTRL+C to quit"
echo
echo "Installing Thor speaker fix..."

CURRENT_DIR="$(pwd)"
PRESET_DIR="$HOME/.var/app/me.timschneeberger.jdsp4linux/config/jamesdsp/presets/"
SYSTEMD_CONFIG="$HOME/.config/systemd/user/"

# install jamesDSP as a user
flatpak --user install me.timschneeberger.jdsp4linux -y

# setup folders
mkdir -p "$PRESET_DIR"
mkdir -p "$SYSTEMD_CONFIG"

# put the files where they need to be
cd "$PRESET_DIR"
wget -q --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/thor.conf
wget -q --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/default.default.conf
cd "$SYSTEMD_CONFIG"
wget -q --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/jamesdsp-auto.service
cd "$CURRENT_DIR"

# add and start service
systemctl --user daemon-reload
systemctl --user enable --now jamesdsp-auto

echo "Mission Complete!"
