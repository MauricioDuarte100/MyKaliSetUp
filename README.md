# Kali-Clean

After cloning the repo just run `./install.sh` from a non-root user. This updates kali and installs a lot of stuff.

## Installation

```bash
./install.sh
```

After the script is done reboot and select i3 (top right corner) on the login screen. Then open a terminal (`Mod+Return`) run `lxappearance` and select ark-dark theme and change the icons to whatever you like (I used papyrus).

## Features & Optimizations

- **Clean Config**: Optimized i3 config with variables for easy color customization.
- **Media Keys**: Volume and brightness controls work out of the box.
- **Window Rules**: Common apps like `Pavucontrol` and `Arandr` open in floating mode automatically.
- **Better Keybindings**: Logical grouping of keybindings for easier memorization.

## Keybindings Cheat Sheet

| Keybinding | Action |
| :--- | :--- |
| `Mod+Return` | Open Terminal (Alacritty) |
| `Mod+d` | Open Application Launcher (Rofi Run) |
| `Mod+Shift+d` | Open Application Launcher (Rofi Drun) |
| `Mod+w` | Open Firefox |
| `Mod+f` | Open File Manager (Thunar) |
| `Mod+Shift+q` | Kill Focused Window |
| `Mod+Shift+c` | Reload i3 Config |
| `Mod+Shift+r` | Restart i3 |
| `Mod+Shift+e` | Exit i3 |
| `Mod+P` | Screenshot (GUI) |
| `Print` | Full Screenshot (Saved to Pictures) |
| `Mod+Shift+Space` | Toggle Floating Mode |
| `Mod+Space` | Focus Toggle (Tiling/Floating) |
| `Mod+r` | Resize Mode |

> **Note**: `Mod` key is set to `Super` (Windows Key) by default.




