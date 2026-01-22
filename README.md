# Kali-Clean

After cloning the repo just run `./install.sh` from a non-root user. This updates kali and installs a lot of stuff.

## Installation

```bash
./install.sh
```

After the script is done reboot and select i3 (top right corner) on the login screen. Then open a terminal (`Mod+Return`) run `lxappearance` and select ark-dark theme and change the icons to whatever you like (I used papyrus).

## Features & Optimizations

- **Modern Compositor**: Switched to **Picom** for better performance and transparency without glitches.
- **Hardware Controls**: Volume and Brightness controls using `brightnessctl` (works on modern hardware).
- **Notifications**: Integrated `Dunst` for system notifications.
- **Clean Config**: Optimized i3 config with variables for easy color customization.
- **Window Rules**: Common apps like `Pavucontrol` and `Arandr` open in floating mode automatically.

## Keybindings Cheat Sheet

| Keybinding | Action |
| :--- | :--- |
| **Apps** | |
| `Mod+Return` | Open Terminal (Alacritty) |
| `Mod+d` | **Open Apps Menu** (Rofi Drun) |
| `Mod+Shift+d` | Open Command Runner (Rofi Run) |
| `Mod+w` | Open Firefox |
| `Mod+f` | Open File Manager (Thunar) |
| **System** | |
| `Mod+q` | Kill Focused Window |
| `Mod+Shift+q` | Kill Focused Window (Alternative) |
| `Mod+Shift+c` | Reload i3 Config |
| `Mod+Shift+r` | Restart i3 |
| `Mod+Shift+e` | Exit i3 |
| **Screenshots** | |
| `Print` | **Screenshot GUI** (Select & Copy to Clipboard) |
| `Scroll Lock` | Screenshot GUI (Alternative) |
| `Mod+P` | Screenshot GUI (Alternative) |
| **Hacking Tools** | |
| `Mod+Shift+b` | Open Burp Suite |
| `Mod+Shift+w` | Open Wireshark |
| **Window Mgmt** | |
| `Mod+Shift+Space` | Toggle Floating Mode |
| `Mod+Space` | Focus Toggle (Tiling/Floating) |
| `Mod+r` | Resize Mode |

> **Note**: `Mod` key is set to `Super` (Windows Key) by default. Screenshots are copied to the clipboard automatically upon selection.




