# apps/

Starting configuration for programs whose colours Noctalia generates. Noctalia's own hooks (`apply.sh`, one per template) only
*edit* an existing config file of the program to select the generated theme; on a fresh system there is none, the hook reports
"no config file found" and the program keeps its default colours. These files are copied into `~/.config` so the hooks have
something to edit. Which templates run is `[theme.templates]` in `noctalia/config.toml`.

## Hooks

`noctalia/config.toml` `[hooks]`: `started` picks a random wallpaper from `~/Pictures/Wallpapers` at every start (the palette follows),
`colors_changed` runs `noctalia/hooks/colors.d/*.sh` after every palette change: the place for a program that has no Noctalia template.
Templates that are on: ghostty, btop, GTK 3/4 (built in), micro, tmux, fastfetch, GIMP (community, fetched from api.noctalia.dev on the first
run). Left out because they need more than a config file: Neovim (lazy.nvim), Telegram (the theme is chosen in its settings), Zen (a
profile that exists), LibreOffice (builds an extension).
