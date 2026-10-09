#!/usr/bin/env bash
# Noctalia "started" hook: a different wallpaper from ~/Pictures/Wallpapers (sub-folders included) on every start; the palette, and with
# it every program that has a template enabled, follows. Noctalia answers on its socket a moment before it applies wallpapers, so
# ask until the wallpaper it reports is a real file.
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
for _ in $(seq 1 60); do
    noctalia msg wallpaper-random >/dev/null 2>&1
    sleep 2
    wp=$(noctalia msg wallpaper-get 2>/dev/null | head -n1)
    [ -n "$wp" ] && [ -f "$wp" ] && break
done
# On the first start the palette is rendered before Noctalia has fetched the community templates (micro, tmux, fastfetch, ...), so
# those programs would keep their colours until the next change of wallpaper. Once a template of the list has arrived, change the
# wallpaper once more: that renders them. (Nothing to do when they were rendered already, on every start after the first.)
if [ ! -f "$cfg/tmux/themes/noctalia.conf" ]; then
    for _ in $(seq 1 36); do
        if [ -f "$state/community-templates/tmux/template.toml" ]; then
            sleep 5
            noctalia msg wallpaper-random >/dev/null 2>&1
            break
        fi
        sleep 5
    done
fi
exit 0
