# 🏛️ agony's dotfiles

Welcome to my personal Arch Linux configuration repository, managed on a HP Victus. This setup is built
around modern Wayland tools, translucent windows everywhere, and one keybind that re-themes the whole
desktop from the wallpaper.

### 📦 What's Inside:
*   **Window Manager:** `niri`: scrollable tiling, rounded corners, one opacity for every window
*   **Bar / Panels:** [`flowbar`](https://github.com/noturbob/Flowbar): my own GTK4 bar. `waybar/` is kept as the previous setup.
*   **Theme Switcher:** [`themely`](https://github.com/noturbob/themely): wallpaper → accent → every app, with a circular reveal animation
*   **Terminal:** `kitty`, translucent, with a powerline bash prompt that follows the theme
*   **Application Launcher:** `fuzzel`
*   **Notifications:** `mako`
*   **Shell:** `bash` (`bash/.bashrc`)
*   **Multiplexer:** [`slat`](https://github.com/noturbob/slat): my own terminal multiplexer, recoloured live by themely
*   **System Info:** `fastfetch`
*   **Editor:** `vim`
*   **Theme & Extras:** `gtk-3.0`, util `scripts/`, Spotify Wayland flags, a VLC launcher override

### 🎨 Theming

Everything is colored by [themely](https://github.com/noturbob/themely). Press **Mod+Shift+T**, pick a
wallpaper, and these recolor, mostly live:
*   niri borders and window opacity, kitty and the prompt, flowbar, mako, fuzzel
*   VS Code / Antigravity, Vesktop, GTK and KDE apps
*   Firefox and Zen (Pywalfox), btop, slat and Spotify (spicetify)

The configs here hold `>>> themely … <<< themely` marker blocks. themely rewrites only the lines between
them, so everything outside is hand-written. Themes live in `themely/themes/`, and `themely/current`
points at the active one.

### ⌨️ Keybinds

| Keys | Action |
|---|---|
| `Mod+Shift+T` | Theme switcher |
| `Mod+T` | kitty |
| `Mod+D` | fuzzel |
| `Mod+Slash` | Toggle flowbar |
| `Alt+F` / `Alt+D` / `Alt+S` | Firefox / Discord (Vesktop) / Spotify |
| `Super+Alt+L` | Lock (swaylock) |
| `Mod+O`, `Mod+Tab` | Overview |
| `Mod+Shift+/` | All hotkeys |

### 🔗 Layout

The repo lives at `/conf`. Each config is symlinked into place:

| In this repo | Linked from |
|---|---|
| `niri/` | `~/.config/niri` |
| `flowbar/` | `~/.config/flowbar` |
| `mako/` | `~/.config/mako` |
| `gtk-3.0/` | `~/.config/gtk-3.0` |
| `themely/` | `~/.config/themely` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `fuzzel/fuzzel.ini` | `~/.config/fuzzel/fuzzel.ini` |
| `slat/config.toml` | `~/.config/slat/config.toml` |
| `bash/.bashrc` | `~/.bashrc` |
| `spotify/spotify-flags.conf` | `~/.config/spotify-flags.conf` |
| `applications/vlc.desktop` | `~/.local/share/applications/vlc.desktop` |

### 🛠️ Setting it up on a fresh install

```sh
sudo git clone https://github.com/noturbob/Arch-Linux-Dotfiles /conf && sudo chown -R "$USER": /conf

# packages
sudo pacman -S niri kitty fuzzel mako swaybg swaylock fastfetch quickshell \
               python-gobject imagemagick plasma-integration qt5ct
uv tool install pywalfox          # Firefox/Zen theming
yay -S spicetify-cli              # Spotify theming

# links
for d in niri flowbar mako gtk-3.0 themely; do ln -sfn /conf/$d ~/.config/$d; done
mkdir -p ~/.config/kitty ~/.config/fuzzel ~/.config/slat ~/.local/share/applications
ln -sf /conf/kitty/kitty.conf           ~/.config/kitty/kitty.conf
ln -sf /conf/fuzzel/fuzzel.ini          ~/.config/fuzzel/fuzzel.ini
ln -sf /conf/slat/config.toml           ~/.config/slat/config.toml
ln -sf /conf/bash/.bashrc               ~/.bashrc
ln -sf /conf/spotify/spotify-flags.conf ~/.config/spotify-flags.conf
ln -sf /conf/applications/vlc.desktop   ~/.local/share/applications/vlc.desktop
```

Then install [flowbar](https://github.com/noturbob/Flowbar) and [themely](https://github.com/noturbob/themely)
by following their READMEs. The themely README also covers the one-time steps for Vesktop, Pywalfox and
spicetify.

**Wallpapers aren't committed** (`wallpapers/` and the theme wallpapers are gitignored). After cloning,
put each theme's image back:

```sh
cp ~/Pictures/some-wall.jpg /conf/themely/themes/nebula/wallpaper
themely apply nebula
```

You can also create themes from scratch: `themely save --name "Name" --wallpaper <image>`.
