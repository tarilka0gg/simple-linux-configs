# apps/

Starting configuration for programs whose colours Noctalia generates. Noctalia's own hooks (`apply.sh`, one per template) only
*edit* an existing config file of the program to select the generated theme; on a fresh system there is none, the hook reports
"no config file found" and the program keeps its default colours. These files are copied into `~/.config` so the hooks have
something to edit. Which templates run is `[theme.templates]` in `noctalia/config.toml`.

## Which programs follow the wallpaper

| Program | How | Needs |
|---|---|---|
| niri (ring, border) | built-in template `niri` | nothing |
| ghostty, btop | built-in templates | the starting configs in `apps/` |
| GTK 3/4 (Thunar, GParted, GIMP's window) | built-in `gtk3`/`gtk4`; the hook switches the theme to `adw-gtk3` | `x11-themes/adw-gtk3` |
| Qt programs (VLC, qt6ct-aware apps) | built-in `qt` and `kcolorscheme`; niri sets `QT_QPA_PLATFORMTHEME=qt6ct`, `hooks/start.sh` writes `qt6ct.conf` pointing at Noctalia's colour file | `gui-apps/qt6ct` |
| yazi, fuzzel | community templates; their hooks create `theme.toml` / `fuzzel.ini` themselves | `app-misc/yazi`, `gui-apps/fuzzel` |
| micro, tmux, fastfetch, GIMP | community templates | tmux and fastfetch: `apps/` |
| Neovim | community template writes `nvim/lua/matugen.lua`; its hook adds the base16 plugin only to a lazy.nvim setup | lazy.nvim |
| Zen | community template writes `userChrome.css`/`userContent.css` into a Zen profile; `hooks/start.sh` applies it again at every start, so it takes effect once Zen has been started once and restarted | a Zen profile |
| Telegram | the template writes `~/.config/telegram-desktop/themes/noctalia.tdesktop-theme`; choosing it is a step in Telegram's own settings (Chat settings, Choose from file) that cannot be scripted | one click |

Left out: LibreOffice (its template builds an extension).

## Hooks

`noctalia/config.toml` `[hooks]`: `started` picks a random wallpaper from `~/Pictures/Wallpapers` at every start (the palette follows),
`colors_changed` runs `noctalia/hooks/colors.d/*.sh` after every palette change: the place for a program that has no Noctalia template.
Templates that are on: ghostty, btop, GTK 3/4 (built in), micro, tmux, fastfetch, GIMP (community, fetched from api.noctalia.dev on the first
run). Left out because they need more than a config file: Neovim (lazy.nvim), Telegram (the theme is chosen in its settings), Zen (a
profile that exists), LibreOffice (builds an extension).
