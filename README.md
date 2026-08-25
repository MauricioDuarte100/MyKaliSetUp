# Kali-Clean: Minimalist & High-Performance i3wm Cyber Environment

Kali-Clean is a lightweight, ultra-fast tiling window manager environment based on **i3wm** for **Kali Linux**, tailored specifically for cybersecurity professionals, penetration testers, bug bounty hunters, and CTF players.

![Kali Clean Setup](.wallpaper/wallpaper.png)

---

## Overview & Key Features

- **Modern Alacritty (v0.13.0+ TOML)**: GPU-accelerated terminal emulator configured via native TOML format with dark high-contrast styling and custom font rendering.
- **Productive Zsh Suite**:
  - `zsh-autosuggestions`: Fast history-based command autosuggestions.
  - `zsh-syntax-highlighting`: Real-time fish-like syntax validation for commands.
  - `fzf-tab`: Interactive fuzzy completion menu on Tab key.
  - `history-substring-search`: Search historical commands by prefix using Up and Down arrows.
  - `sudo`: Press `ESC` twice to prepend `sudo` to the current line.
  - `extract`: Universal archive extractor supporting all major compression formats.
  - `colored-man-pages`: Colorized terminal manual pages.
- **Real-Time Target & VPN Indicators**: Live tracking of active target IP and VPN status across the status bar, tmux bar, and terminal prompt.
- **Tmux Master Configuration**: Mouse scrolling, Vim-style pane navigation, 50,000-line scrollback buffer, and X11 clipboard integration via `xclip`.
- **Interactive i3blocks Status Bar**: Click-to-copy functionality for VPN and Target IP with desktop notifications.
- **Scratchpad Floating Terminal**: Instant dropdown terminal available on demand from any workspace.
- **Desktop Environment Optimization**: Safe removal of heavy desktop environments (GNOME/XFCE) to reduce idle memory usage to under **350 MB RAM**.
- **Virtual Machine Clipboard Synchronization**: Built-in support for VMware, VirtualBox, and QEMU/KVM clipboard sharing.

---

## Installation Guide

### Prerequisites
Run the installer from a standard user account with `sudo` privileges. Do not run the installer using `sudo ./install.sh` directly.

### Step-by-Step Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/MauricioDuarte100/MyKaliSetUp.git
   cd MyKaliSetUp
   ```

2. **Grant execution permissions and run the installer**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Reboot the system**:
   ```bash
   sudo reboot
   ```

4. **Post-Installation Appearance Setup**:
   Once logged in, open a terminal (`Mod + Return`), launch `lxappearance`, and select:
   - **Widget Theme**: `Arc-Dark`
   - **Icon Theme**: `Papirus-Dark`

---

## Workspace Architecture

Applications are organized across predefined dedicated workspaces:

| Workspace | Name | Assigned Applications |
| :--- | :--- | :--- |
| **1** | `1:Terminals` | Alacritty, Tmux, Shell Sessions |
| **2** | `2:Web` | Firefox, Chromium, Web Reconnaissance |
| **3** | `3:Proxies` | Burp Suite, OWASP ZAP, Wireshark |
| **4** | `4:Reverse` | Ghidra, IDA Pro, Binary Ninja, GDB |
| **5** | `5:Notes` | Obsidian, CherryTree, Documentation |

---

## Keybindings Reference

> The default modifier key (**`Mod`**) is bound to the **`Super`** key (Windows Key).

### System & Window Management

| Shortcut | Function |
| :--- | :--- |
| **`Mod + Return`** | Open Terminal (Alacritty) |
| **`Mod + u`** | Toggle Scratchpad Floating Terminal |
| **`Mod + d`** | Open Command Launcher (Rofi Run) |
| **`Mod + Shift + d`** | Open Application Launcher (Rofi Drun) |
| **`Mod + w`** | Open Web Browser (Firefox) |
| **`Mod + f`** | Open File Manager (Thunar) |
| **`Mod + Shift + q`** | Close Focused Window |
| **`Mod + Shift + r`** | Restart i3wm in place |
| **`Mod + Shift + c`** | Reload i3wm configuration |
| **`Mod + Shift + e`** | Open Power / Session Menu (Rofi) |
| **`Mod + Shift + Escape`** | Lock Screen (i3lock) |

### Cybersecurity & CTF Tools

| Shortcut | Function |
| :--- | :--- |
| **`Mod + c`** | Copy current Target IP to clipboard |
| **`Mod + Shift + t`** | Set Target IP via GUI prompt (Rofi) |
| **`Mod + Shift + x`** | Clear active Target IP |
| **`Mod + Shift + b`** | Launch Burp Suite (Workspace 3) |
| **`Mod + Shift + w`** | Launch Wireshark (Workspace 3) |
| **`Mod + P`** | Interactive Screenshot (Flameshot) |
| **`Print`** | Full-Screen Screenshot (`~/Pictures/Screenshots`) |

### Navigation & Layout Controls

| Shortcut | Function |
| :--- | :--- |
| **`Mod + j / k / l / ;`** | Move focus (Left / Down / Up / Right) |
| **`Mod + Left / Down / Up / Right`** | Move focus using arrow keys |
| **`Mod + Shift + [j/k/l/;]`** | Move focused container in specified direction |
| **`Mod + h`** | Split container horizontally |
| **`Mod + v`** | Split container vertically |
| **`Mod + Shift + f`** | Toggle fullscreen mode |
| **`Mod + Shift + Space`** | Toggle floating mode for focused window |
| **`Mod + Space`** | Toggle focus between tiling and floating windows |
| **`Mod + 1 .. 0`** | Switch to Workspace 1 through 10 |
| **`Mod + Shift + 1 .. 0`** | Move container to Workspace 1 through 10 |
| **`Mod + r`** | Enter Resize mode (`Escape` or `Return` to exit) |

---

## Interactive Status Bar (i3blocks)

The top status bar provides real-time diagnostic information and interactive controls:

- **Target Block**:
  - **Left Click**: Copies the Target IP directly to the system clipboard and displays a desktop notification.
  - **Right Click**: Opens the Rofi prompt to set a new Target IP or clear it.
- **VPN Block**:
  - Automatically monitors `tun0` (OpenVPN) and `wg0` (WireGuard) interfaces.
  - **Left Click**: Copies the active VPN IP address to the clipboard.

---

## Tmux Terminal Multiplexer

A pre-configured `.tmux.conf` file is included, optimized for multi-pane hacking sessions:

| Shortcut | Function |
| :--- | :--- |
| **`Alt + h / j / k / l`** | Navigate between panes without prefix |
| **`Ctrl + b` then `\|`** | Split pane vertically |
| **`Ctrl + b` then `-`** | Split pane horizontally |
| **`Ctrl + b` then `y`** | Toggle pane synchronization (send input to all panes simultaneously) |
| **`Ctrl + b` then `[`** | Enter Vi copy mode (`v` to select, `y` to copy to X11 clipboard) |
| **`Ctrl + b` then `r`** | Reload Tmux configuration file |
| **Mouse Click & Drag** | Select and copy text directly to the system clipboard |

---

## Offensive Shell Commands & Aliases

The environment includes specialized productivity functions available in Zsh and Bash:

- **`settar <IP>`**: Sets the global Target IP, copies it to the clipboard, and refreshes status bars.
- **`cptar`**: Copies the active Target IP to the clipboard.
- **`cleartar`**: Clears the active Target IP.
- **`target`**: Displays the active Target IP in the terminal.
- **`cpvpn`**: Copies the active VPN IP address to the clipboard.
- **`vpn`**: Displays the current VPN interface IP address.
- **`myip`**: Outputs local, VPN, and public IP addresses.
- **`revshell <IP> <PORT> [type]`**: Generates reverse shell payloads (supports `bash`, `nc`, `python`, and `powershell`).
- **`mktarget <Name>`**: Generates structured CTF working directories (`nmap`, `exploits`, `content`, `loot`, `scripts`).
- **`ports`**: Lists all active listening TCP/UDP sockets with process identification (`ss -tulpn`).
- **`b64e <string>` / `b64d <string>`**: Fast Base64 encoding and decoding.
- **`urle <string>` / `urld <string>`**: Fast URL encoding and decoding.
- **`http-server [port]`**: Starts a Python HTTP server in the current directory (default port: 80).
- **`extract <file>`**: Universal archive extraction command.

---

## Customization

### Changing Wallpaper
1. Copy your desired wallpaper image to `~/.wallpaper/wallpaper.png`.
2. Reload the wallpaper:
   ```bash
   sh ~/.fehbg
   ```
3. To generate a dynamic color scheme using `pywal`:
   ```bash
   wal -i ~/.wallpaper/wallpaper.png
   ```

---

## License

Distributed under the MIT License. Free for personal, academic, and professional penetration testing use.
