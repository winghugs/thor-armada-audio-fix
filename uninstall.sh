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

echo "Uninstalling speaker fix"

PRESET_DIR="$HOME/.var/app/me.timschneeberger.jdsp4linux/config/jamesdsp/presets/"
SYSTEMD_CONFIG="$HOME/.config/systemd/user/"

# disable the service
systemctl --user stop jamesdsp-auto || true
systemctl --user disable jamesdsp-auto || true

# kill all the downloaded files
rm "$PRESET_DIR/thor.conf"
rm "$PRESET_DIR/default.default.conf"
rm "$SYSTEMD_CONFIG/jamesdsp-auto.service"

# add and start service
systemctl --user daemon-reload

echo "Mission Complete! Please restart your Thor."
