#!/usr/bin/env bash
# fastfetch's snake keeps its default look (the terminal's white and light black) and takes only 10% of the wallpaper's accent colour.
# Noctalia's own fastfetch template recolours everything at full strength, so it is off (config.toml); this hook does the mixing from
# the ghostty theme file Noctalia writes: palette 7 / 8 (the default tones) + 10% of cursor-color (the accent).
# Eyes (black) and tongue (red) are named colours in the config and are never touched.
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"
theme="$cfg/ghostty/themes/noctalia"; conf="$cfg/fastfetch/config.jsonc"
[ -f "$theme" ] && [ -f "$conf" ] && command -v jq >/dev/null || exit 0
jq empty "$conf" 2>/dev/null || exit 0      # strict JSON only (the file has no comments on purpose)
pal() { sed -n "s/^palette = $1=#\([0-9a-fA-F]\{6\}\).*/\1/p" "$theme" | head -1; }
accent=$(sed -n 's/^cursor-color = #\([0-9a-fA-F]\{6\}\).*/\1/p' "$theme" | head -1)
base1=$(pal 7); base2=$(pal 8)
[ -n "$accent" ] && [ -n "$base1" ] && [ -n "$base2" ] || exit 0
mix() {   # mix <base hex> <accent hex>: 90% base + 10% accent; fastfetch 2.66 drops a colour whose SGR string is 16 chars long, so the smallest channel is nudged to 99 when all three are 100+
    local c r g b i v out=""
    for i in 0 2 4; do
        v=$(( (9 * 16#${1:i:2} + 16#${2:i:2}) / 10 )); c+=" $v"
    done
    set -- $c; r=$1; g=$2; b=$3
    if [ "$r" -ge 100 ] && [ "$g" -ge 100 ] && [ "$b" -ge 100 ]; then
        if [ "$r" -le "$g" ] && [ "$r" -le "$b" ]; then r=99; elif [ "$g" -le "$b" ]; then g=99; else b=99; fi
    fi
    printf '#%02x%02x%02x' "$r" "$g" "$b"
}
c1=$(mix "$base1" "$accent"); c2=$(mix "$base2" "$accent")
tmp=$(mktemp) && jq --arg c1 "$c1" --arg c2 "$c2" \
    '.logo.color["1"]=$c1 | .logo.color["2"]=$c2 | .display.color.keys=$c1 | .display.color.title=$c2' "$conf" > "$tmp" \
    && cat "$tmp" > "$conf"
rm -f "$tmp"
