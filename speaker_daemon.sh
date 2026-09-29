#!/bin/bash

SPEAKER_PRESET="thor"
DEFAULT_PRESET="decksp.default"
FLATPAK_ID="me.timschneeberger.jdsp4linux"

LAST_STATE=""
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/run/user/$(id -u)


jamesdsp_check() {
    if ! pgrep -f "jdsp4linux" > /dev/null; then
        echo "JamesDSP not running. Launching..."
	flatpak --user run $FLATPAK_ID --tray &
	sleep 2
    fi
}

jamesdsp_check

update_preset() {
    jamesdsp_check
   
    CURRENT_SINK=$(pactl get-default-sink)

    if [[ "$CURRENT_SINK" == "alsa_output.platform-sound.HiFi__Speaker__sink"  ]]; then
        STATE="SPEAKERS"
    else
        STATE="HEADPHONES"
    fi

    if [ "$STATE" != "$LAST_STATE" ]; then
        if [ "$STATE" == "SPEAKERS" ]; then
            flatpak run me.timschneeberger.jdsp4linux --load-preset "$SPEAKER_PRESET"
        else
            flatpak run me.timschneeberger.jdsp4linux --load-preset "$DEFAULT_PRESET"
        fi
        LAST_STATE="$STATE"
    fi
}

update_preset

pactl subscribe | while read -r line; do
    if echo "$line" | grep -qE "Event '(change|new)' on (server|sink)"; then
        update_preset
    fi
done
