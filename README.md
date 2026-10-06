# simple-linux-configs

The configs of [Simple Linux](https://github.com/tarilka0gg/simple-linux), installed by its installer into the new user's home: clean defaults for a handful of Wayland compositors (and one X11 WM),
all paired with [Noctalia](https://github.com/noctalia-dev/noctalia-shell) as
the shell/bar, and a login-shell template that launches whichever one you
picked.

## Layout

```
simple-linux-configs/
├── fish/                    # the author's fish: tide prompt, fisher, sponge, autopair (see below)
├── niri/config.kdl          # scrollable-tiling compositor
├── hyprland/hyprland.conf   # animated tiling compositor
├── sway/config               # i3-compatible tiling compositor
├── scroll/config              # Sway fork, PaperWM-style single scrolling layout
├── labwc/rc.xml                # stacking WM, Openbox-style config
├── mangowc/config.conf          # tiling compositor
├── triad/config.kdl              # layout manager running inside River (Nim)
├── dwl/config.h                    # suckless-style compositor — config.h, not a runtime file
└── bash_profile.tmpl                  # login-shell template, execs the chosen session on tty1
```

Every preset starts `xwayland-satellite` (X11 app support) and `noctalia`
(shell/bar) on its own — except `dwl`, which has no exec-on-startup
mechanism of its own and instead launches Noctalia via dwl's `-s`
startup-command flag from `bash_profile.tmpl`/`LAUNCH_CMD` (see the comment
at the top of `dwl/config.h`).

`noctalia/config.toml` is the shared shell config used by every WM/compositor
here — same file regardless of which one is running under it.

## Compositors

| | Kind | Config format |
|---|---|---|
| **niri** | scrollable-tiling (columns, no traditional workspaces grid) | KDL |
| **Hyprland** | animated tiling, most third-party plugin/ecosystem support | text |
| **Sway** | i3-compatible tiling | text |
| **Scroll** | Sway fork, single PaperWM-style scrolling layout (sway-syntax-compatible + its own binds) | text |
| **Labwc** | stacking WM, Openbox-style | XML |
| **MangoWC** | tiling | text |
| **Triad** | layout manager running *inside* River (Nim) — `triad session` starts River itself, no separate river config needed | KDL |
| **dwl** | suckless-style — config is a C header compiled into the binary, not read at runtime | C header |

## Keybindings

Same scheme across every compositor here *except* `dwl`, which keeps
suckless/dwm's own stock bindings (`Mod+P` to spawn, `Mod+J`/`K` to cycle
focus, `Mod+I`/`D` to grow/shrink master count, `Mod+H`/`L` to adjust the
split ratio) rather than being reconfigured to match — see `dwl/config.h`
directly for its actual binds. `Mod` = Super.

| Bind | Action |
|---|---|
| `Mod+Return` / `Mod+T` | open terminal (`ghostty`) |
| `Mod+Q` | close focused window |
| `Mod+F` | fullscreen |
| `Mod+D` / `Mod+A` | maximize column (niri) / toggle floating (others) |
| `Mod+Shift+E` | quit compositor |
| `Mod+←↓↑→` or `Mod+H/J/K/L` | move focus |
| `Mod+Shift+←↓↑→` | move window/column |
| `Mod+1`…`5` | switch workspace |
| `Mod+Shift+1`…`5` | move window to workspace |
| `Print` / `Mod+Shift+S` | screenshot (full) / region (via Noctalia) |
| `Mod+Space` | Noctalia control center |
| `Mod+S` | Noctalia launcher |
| `Mod+V` | Noctalia clipboard |
| `Mod+Comma` | Noctalia settings |
| `Mod+Alt+L` | lock session |
| `XF86Audio*` / `XF86MonBrightness*` | volume/brightness/media — routed through `noctalia msg ...` so the OSD stays in sync, not handled by the compositor directly |

## Install

Pick one, e.g. niri:

```bash
mkdir -p ~/.config/niri
cp niri/config.kdl ~/.config/niri/config.kdl
mkdir -p ~/.config/noctalia
cp noctalia/config.toml ~/.config/noctalia/config.toml
```

For `dwl`, copy `dwl/config.h` over dwl's own `config.def.h` as `config.h`
before `make clean install` — it's compiled in, not a runtime config file.

### `bash_profile.tmpl`

Template for `~/.bash_profile`: on tty1 login it execs `{{LAUNCH_CMD}}`
(replace with the actual launch command for whichever session you picked,
e.g. `niri-session` or `dwl -s noctalia`) instead of dropping to a shell.

```bash
sed 's/{{LAUNCH_CMD}}/niri-session/' bash_profile.tmpl > ~/.bash_profile
```

## Notes

- Each compositor's own wiki/docs are linked at the top of its config file.
- These are deliberately *clean defaults* — a starting point for a fresh
  install, not a fully personalized dotfiles dump.

## fish

`fish/` is copied to `~/.config/fish` of the new user when the system has fish (the Simple Linux stage does). It is the author's own setup
with his machine-specific parts left out (his local tools and paths, proxies and tokens are not in it; every alias checks that its tool exists):

- `conf.d/tide-config.fish`: his [tide](https://github.com/IlanCosman/tide) v6.1.1 prompt, the `tide_*` variables exported as globals, so the prompt is
  the same on a fresh home without running `tide configure` (which still works; variables set in this file win over its answers).
- `functions/`, `conf.d/_tide_init.fish`, `completions/`: tide, [fisher](https://github.com/jorgebucaran/fisher), [sponge](https://github.com/meaningful-ooo/sponge)
  and [autopair](https://github.com/jorgebucaran/autopair.fish), copied as they were installed (all MIT). `fish_plugins` lists them, so `fisher update` works.
- `config.fish`: no greeting, `eza`/`micro`/`dust`/`gping`/`doas` aliases, `zoxide` and `fzf` hooks, `fastfetch` on the first prompt; all guarded.

tide draws its icons with a **Nerd Font**. The Linux console (tty) cannot show them; use a terminal with one (for example ghostty with a Nerd Font) for the intended look.
