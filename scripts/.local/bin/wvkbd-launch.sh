#!/usr/bin/env bash
# Launches wvkbd-mobintl with DMS colors
# Restarts when dms-colors.json changes via systemd path unit

if [ -z "$NIRI_SOCKET" ]; then
    exit 0
fi

get_wvkbd_colors() {
    local json="$HOME/.cache/DankMaterialShell/dms-colors.json"
    local fallback="--bg 000000d9 --fg 000000b3 --fg-sp 000000b3 --text ffffff --text-sp ffffff"
    if [ ! -f "$json" ]; then
        echo "$fallback"
        return
    fi
    local result
    result=$(python3 - <<EOF
import json, sys
try:
    with open("$json") as f:
        d = json.load(f)
    c = d["colors"]["dark"]
    def hex_alpha(color, alpha):
        return color.lstrip("#") + alpha
    bg    = hex_alpha(c["surface_container"], "d9")
    fg    = hex_alpha(c["primary"], "ff")
    fg_sp = hex_alpha(c["secondary_container"], "ff")
    print(f"--bg {bg} --fg {fg} --fg-sp {fg_sp} --text {c['on_primary'].lstrip('#')} --text-sp {c['on_secondary_container'].lstrip('#')}")
except Exception:
    sys.exit(1)
EOF
)
    if [ $? -ne 0 ] || [ -z "$result" ]; then
        echo "$fallback"
        return
    fi
    echo "$result"
}

exec wvkbd-mobintl $(get_wvkbd_colors) -L 350 -H 500 -R 8 --hidden
