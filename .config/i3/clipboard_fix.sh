#!/bin/bash

# Fix clipboard synchronization across VM platforms (VMware, VirtualBox, QEMU/KVM)

# VMware
if command -v vmtoolsd >/dev/null 2>&1; then
    pkill -f "vmtoolsd -n vmusr" 2>/dev/null
    vmtoolsd -n vmusr &
fi

# VirtualBox
if command -v VBoxClient >/dev/null 2>&1; then
    pkill -f "VBoxClient --clipboard" 2>/dev/null
    VBoxClient --clipboard &
fi

# QEMU / KVM (SPICE)
if command -v spice-vdagent >/dev/null 2>&1; then
    pkill -f "spice-vdagent" 2>/dev/null
    spice-vdagent &
fi

# X11 primary selection sync (if autocutsel is installed)
if command -v autocutsel >/dev/null 2>&1; then
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
fi
