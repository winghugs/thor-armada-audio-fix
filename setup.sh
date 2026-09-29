#!/bin/bash
set -Ee

# root check
if [ $(id -u) -eq 0 ]
  then echo "Please do not run this script as root, try again without sudo."
  exit
fi

# don't continue if something fails
error_handler() {
    local exit_code="$?"
    echo ""
    echo "Script failed with exit code $exit_code."
    echo "Something went wrong. Check the output for errors."
}

trap error_handler ERR

echo "This line will never be reached because of set -e"

echo "**** WARNING ****"
echo "This script is specifically meant to install the JamesDSP speaker profile used by projects OTPTweaks/ThorTune."
echo "Do not install this on any device other than the AYN Thor, if you do, your speakers will sound awful."
read -n 1 -s -r -p "Press any key to continue, or CTRL+C to quit"
echo
echo "Installing Thor speaker fix..."

CURRENT_DIR="$(pwd)"
PRESET_DIR="$HOME/.var/app/me.timschneeberger.jdsp4linux/config/jamesdsp/presets/"
SYSTEMD_CONFIG="$HOME/.config/systemd/user/"
DAEMON_FOLDER="$HOME/.config/jdspthorfix/"

# install jamesDSP as a user
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak --user install me.timschneeberger.jdsp4linux -y

# setup folders
mkdir -p "$PRESET_DIR"
mkdir -p "$SYSTEMD_CONFIG"
mkdir -p "$DAEMON_FOLDER"

# put the files where they need to be
cd "$PRESET_DIR"
wget --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/thor.conf
wget --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/default.default.conf
cd "$SYSTEMD_CONFIG"
wget --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/jamesdsp-auto.service
cd "$DAEMON_FOLDER"
wget --show-progress https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/speaker_daemon.sh
chmod +x speaker_daemon.sh
cd "$CURRENT_DIR"

# add and start service
systemctl --user daemon-reload
systemctl --user enable --now jamesdsp-auto
