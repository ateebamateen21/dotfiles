#!/usr/bin/env bash

grim -g "$(slurp)" -t ppm - | satty --filename - --output-filename /tmp/satty.png
wl-copy < /tmp/satty.png
