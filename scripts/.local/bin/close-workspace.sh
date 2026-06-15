#!/bin/bash

# /home/ateebamateen/dotfiles/scripts/close-workspace.sh

# get current workspace id
WS_ID=$(niri msg -j workspaces | jq '.[] | select(.is_focused == true) | .id')
# get all window ids on that workspace and close them
niri msg -j windows | jq ".[] | select(.workspace_id == $WS_ID) | .id" | while read id; do
    niri msg action close-window --id "$id"
done
