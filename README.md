# Thor Audio Fix for Armada
This installs the popular JamesDSP profile, converted for use on Linux with [JDSP4Linux.](https://github.com/Audio4Linux/JDSP4Linux)

## What the script does
- Installs the JamesDSP flatpak in user mode.
- Installs my converted version of the audio profile by [ItsRetroPup](https://github.com/ItsRetroPup/AYN-Thor-Tweaks) and places it in the presets folder
- Installs a default preset to use when speakers are not in use
- Installs a daemon and enables a service which both runs JamesDSP on boot, and switches between the profiles depending on if the speakers are in use or not.

You will not need to manually switch profiles, the daemon will handle it and automatically switch profiles when your speakers aren't used. ***Do not install DeckSP on top of this, and uninstall DeckSP if it is currently installed.***

## Install
Copy and paste this into your terminal:
``` sh -c "$(curl -fsSL https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/setup.sh)"```

## Uninstall
Copy and paste this into your terminal:
``` sh -c "$(curl -fsSL https://raw.githubusercontent.com/winghugs/thor-armada-audio-fix/refs/heads/main/uninstall.sh)"```

