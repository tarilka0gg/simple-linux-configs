#!/usr/bin/env bash
# Noctalia "started" hook. On the very first start the palette is rendered before Noctalia has fetched the community templates
# (micro, tmux, fastfetch, ...), so those programs would keep their colours until the next palette change. Once a template of the list
# has arrived, apply the templates again for the same palette (the wallpaper does not change). Nothing to do on later starts.
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
[ -f "$cfg/tmux/themes/noctalia.conf" ] && exit 0
for _ in $(seq 1 36); do
    if [ -f "$state/community-templates/tmux/template.toml" ]; then
        sleep 5
        noctalia msg templates-apply >/dev/null 2>&1
        exit 0
    fi
    sleep 5
done
exit 0
