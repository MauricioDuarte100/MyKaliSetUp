# 🛡️ Kali-Clean: Minimalist & High-Performance Cyber i3wm Environment

Un entorno de trabajo minimalista, ultra-ligero y de alto rendimiento basado en **i3wm** para **Kali Linux**, inspirado en el flujo de trabajo de **xct** (HackTheBox Omniscient) y optimizado específicamente para profesionales de **Ciberseguridad, Pentesting, Bug Bounty y CTF Solving**.

![Kali Clean Setup](.wallpaper/wallpaper.png)

---

## ⚡ Características Principales (xct Edition)

- **Alacritty TOML (v0.13.0+)**: Configuración moderna de alto rendimiento con aceleración GPU, desenfoque sutil y paleta oscura Cyber Dark.
- **Suite Completa de Plugins Zsh**:
  - `zsh-autosuggestions`: Autocompletado predictivo inteligente basado en historial.
  - `zsh-syntax-highlighting`: Resaltado de sintaxis en tiempo real para comandos.
  - `fzf-tab`: Menú interactivo enriquecido con `fzf` al presionar `Tab`.
  - `history-substring-search`: Búsqueda instantánea en el historial con flechas `Arriba` y `Abajo`.
  - `sudo`: Pulsa `ESC` dos veces para anteponer `sudo` al comando actual.
  - `extract`: Descompresor universal para cualquier formato de archivo comprimido.
  - `colored-man-pages`: Páginas de manual con colores de sintaxis legibles.
- **Prompt Hacker en Tiempo Real**:
  - Muestra automáticamente el **Target IP** (`🎯 10.10.11.X`) y el **VPN IP** (`🔒 10.10.14.X`), rama Git y ruta activa.
- **Tmux Master Setup (`.tmux.conf`)**:
  - Soporte completo de ratón (selección, cambio de paneles, scroll de 50.000 líneas).
  - Navegación rápida estilo Vim (`Alt + h/j/k/l` para cambiar paneles).
  - División intuitiva (`Prefix + |` vertical, `Prefix + -` horizontal).
  - Modo copia Vi integrado directamente con el portapapeles de X11 (`xclip`).
  - Barra de estado personalizada con indicador de Target y VPN en tiempo real.
- **Barra i3blocks Interactiva (Click-to-Copy)**:
  - 🎯 **Target IP**: Clic izquierdo para copiar al portapapeles con notificación visual (`notify-send`). Clic derecho para cambiar el Target con Rofi.
  - 🔒 **VPN Status**: Detección automática de OpenVPN (`tun0`) y WireGuard (`wg0`). Clic izquierdo para copiar tu IP de VPN.
- **Scratchpad Terminal Desplegable (`Mod + u`)**: Terminal flotante instantánea desde cualquier workspace para cálculos rápidos o payloads.
- **Rofi Power Menu (`Mod + Shift + e`)**: Menú visual interactivo para Bloquear, Cerrar sesión, Reiniciar o Apagar.
- **Gestión Limpia de Entornos (GNOME/XFCE)**: El instalador permite desinstalar entornos pesados de forma segura, reduciendo el consumo de memoria a menos de **~350 MB de RAM en reposo**.
- **Portapapeles en Máquinas Virtuales**: Sincronización instantánea para VMware, VirtualBox y QEMU/KVM.

---

## 🚀 Instalación Rápida

Ejecuta el instalador desde tu usuario estándar (el script solicitará permisos de `sudo` cuando sea necesario):

```bash
git clone https://github.com/MauricioDuarte100/MyKaliSetUp.git
cd MyKaliSetUp
chmod +x install.sh
./install.sh
```

Al finalizar la instalación, reinicia el sistema:

```bash
sudo reboot
```

> **Personalización:** Ejecuta `lxappearance` para activar el tema visual **Arc-Dark** y el set de iconos **Papirus-Dark**.

---

## ⌨️ Atajos de Teclado (Cheat Sheet)

> La tecla **`Mod`** está configurada por defecto como **`Super`** (Tecla Windows).

### 🪟 Aplicaciones & Sistema
| Atajo | Acción |
| :--- | :--- |
| **`Mod + Return`** | Abrir Terminal principal (**Alacritty**) |
| **`Mod + u`** | 🚀 Desplegar / Ocultar **Terminal Scratchpad Flotante** |
| **`Mod + d`** | Lanzador de Comandos (**Rofi Run**) |
| **`Mod + Shift + d`** | Lanzador de Aplicaciones (**Rofi Drun**) |
| **`Mod + w`** | Abrir Navegador (**Firefox**) |
| **`Mod + f`** | Gestor de Archivos (**Thunar**) |
| **`Mod + Shift + q`** | Cerrar Ventana Enfocada |
| **`Mod + Shift + r`** | Reiniciar i3 (Recargar cambios al instante) |
| **`Mod + Shift + c`** | Recargar Configuración de i3 |
| **`Mod + Shift + e`** | 🛑 **Menú de Apagado / Salida (Rofi Power Menu)** |
| **`Mod + Shift + Escape`** | Bloquear Pantalla (**i3lock**) |

### 🎯 Herramientas de Ciberseguridad & CTF
| Atajo | Acción |
| :--- | :--- |
| **`Mod + c`** | 📋 **Copiar Target IP al portapapeles** (con notificación) |
| **`Mod + Shift + t`** | 🎯 Establecer **Target IP** (Prompt visual con Rofi) |
| **`Mod + Shift + x`** | ❌ Limpiar **Target IP** de la barra |
| **`Mod + Shift + b`** | Abrir **Burp Suite** (Auto-asignado a Workspace 3) |
| **`Mod + Shift + w`** | Abrir **Wireshark** (Auto-asignado a Workspace 3) |
| **`Mod + P`** | Captura de pantalla interactiva (**Flameshot**) |
| **`Print`** | Captura de pantalla completa (`~/Pictures/Screenshots`) |

### 📐 Espacios de Trabajo Preconfigurados
* **Workspace 1 (`1:Terminals`)**: Alacritty / Tmux
* **Workspace 2 (`2:Web`)**: Firefox / Chromium
* **Workspace 3 (`3:Proxies`)**: Burp Suite / Wireshark / OWASP ZAP
* **Workspace 4 (`4:Reverse`)**: Ghidra / IDA / Binary Ninja / GDB
* **Workspace 5 (`5:Notes`)**: Obsidian / CherryTree / Notetaking

---

## 💻 Tmux Cheat Sheet (CTF & Pentesting)

| Atajo | Acción |
| :--- | :--- |
| **`Alt + h / j / k / l`** | Cambiar de panel (Navegación estilo Vim sin prefijo) |
| **`Ctrl + b` luego `\|`** | Dividir panel **verticalmente** |
| **`Ctrl + b` luego `-`** | Dividir panel **horizontalmente** |
| **`Ctrl + b` luego `y`** | Alternar **sincronización de paneles** (escribe en todos a la vez) |
| **`Ctrl + b` luego `[`** | Entrar en **Modo Copia Vi** (`v` para seleccionar, `y` para copiar a X11) |
| **`Ctrl + b` luego `r`** | Recargar configuración de Tmux |
| **Arrastrar con el ratón** | Seleccionar texto y copiar automáticamente al portapapeles |

---

## 🛠️ Comandos de Terminal Útiles (Zsh & Bash)

- **`settar <IP>`**: Establece la IP objetivo y la copia automáticamente al portapapeles.
- **`cptar`**: Copia la IP objetivo al portapapeles en cualquier momento.
- **`cleartar`**: Limpia la IP objetivo actual.
- **`target`**: Muestra la IP objetivo configurada.
- **`cpvpn`**: Copia la IP de tu VPN activa (`tun0` / `wg0`) al portapapeles.
- **`vpn`**: Muestra la IP de tu túnel VPN.
- **`myip`**: Muestra tus IPs Local, VPN y Pública de forma instantánea.
- **`revshell <IP> <PORT> [tipo]`**: Genera comandos de reverse shells listos para usar (`bash`, `nc`, `python`, `powershell`).
- **`mktarget <Nombre>`**: Genera automáticamente la estructura de carpetas para una máquina CTF (`nmap`, `exploits`, `content`, `loot`, `scripts`).
- **`ports`**: Muestra los puertos y servicios locales escuchando en el sistema (`ss -tulpn`).
- **`b64e <texto>` / `b64d <texto>`**: Codifica y decodifica Base64 al instante.
- **`urle <texto>` / `urld <texto>`**: URL-encode / URL-decode rápido.
- **`http-server [puerto]`**: Inicia un servidor web HTTP de Python en el directorio actual (puerto 80 por defecto).
- **`extract <archivo>`**: Descomprime automáticamente cualquier tipo de archivo comprimido (`.tar.gz`, `.zip`, `.7z`, `.tar.bz2`, etc.).

---

## 🎨 Personalización del Fondo de Pantalla

Para cambiar el fondo de pantalla por una imagen personalizada:

1. Coloca tu imagen en `~/.wallpaper/wallpaper.png` (o edita `~/.fehbg`).
2. Aplica el cambio ejecutando:
   ```bash
   sh ~/.fehbg
   ```
3. Generar esquemas de colores automáticos con `pywal`:
   ```bash
   wal -i ~/.wallpaper/wallpaper.png
   ```

---

## 📜 Licencia

Distribuido bajo la Licencia MIT. ¡Libre para usar, modificar y compartir en tus auditorías y laboratorios de hacking!
