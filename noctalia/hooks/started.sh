#!/usr/bin/env bash
# Noctalia "started" hook: a different wallpaper from ~/Pictures/Wallpapers (sub-folders included) on every start; the palette, and with
# it every program that has a template enabled, follows. Noctalia answers on its socket a moment before it applies wallpapers, so
# ask until the wallpaper it reports is a real file.
for _ in $(seq 1 60); do
    noctalia msg wallpaper-random >/dev/null 2>&1
    sleep 2
    wp=$(noctalia msg wallpaper-get 2>/dev/null | head -n1)
    [ -n "$wp" ] && [ -f "$wp" ] && exit 0
done
exit 0
