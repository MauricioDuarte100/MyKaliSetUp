#!/bin/bash

# ==============================================================================
# SCRATCHPAD TERMINAL LAUNCHER / TOGGLER
# ==============================================================================

if ! i3-msg '[instance="scratchpad"] scratchpad show' 2>/dev/null | grep -q '"success":true'; then
    alacritty --class scratchpad,scratchpad &
fi
