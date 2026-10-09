#!/usr/bin/env bash
# Noctalia "colors_changed" hook: runs after the palette was regenerated and the templates were written. Every script in colors.d/
# (in name order) is run, a failing one does not stop the others: this is where something that has no Noctalia template goes (reload
# a program, recolour a prompt, ...). The generated files are under ~/.config/<program>/ (see the templates in config.toml).
dir="${XDG_CONFIG_HOME:-$HOME/.config}/noctalia/hooks/colors.d"
for script in "$dir"/*.sh; do
    [ -f "$script" ] || continue
    bash "$script" || echo "colors.d: $(basename "$script") failed" >&2
done
exit 0
