#!/usr/bin/env bash
# tui-shim draws its file picker and the folder badge in one palette file. This hook writes it, ~/.config/tui-shim/palette.md, from the ghostty
# theme Noctalia makes out of the wallpaper, so the picker follows the wallpaper too. tui-shim's own themes for micro, btop and yazi are never
# applied (`sync --no-theme`): those programs are coloured by Noctalia's templates.
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"
theme="$cfg/ghostty/themes/noctalia"; out="$cfg/tui-shim/palette.md"
[ -f "$theme" ] || exit 0
val() { sed -n "s/^$1 = #\([0-9a-fA-F]\{6\}\).*/\1/p" "$theme" | head -1; }
pal() { sed -n "s/^palette = $1=#\([0-9a-fA-F]\{6\}\).*/\1/p" "$theme" | head -1; }
mix() {   # mix <hex a> <hex b> <percent of b>
    local i v o=""
    for i in 0 2 4; do v=$(( (( 100 - $3 ) * 16#${1:i:2} + $3 * 16#${2:i:2}) / 100 )); o+=$(printf '%02X' "$v"); done
    printf '%s' "$o"
}
bg=$(val background); fg=$(val foreground); accent=$(val cursor-color); paper=$(val cursor-text); sel=$(val selection-background)
[ -n "$bg" ] && [ -n "$fg" ] && [ -n "$accent" ] || exit 0
[ -n "$paper" ] || paper=$fg; [ -n "$sel" ] || sel=$(mix "$bg" "$accent" 40)
dim=$(pal 8); [ -n "$dim" ] || dim=$(mix "$fg" "$bg" 40)
mkdir -p "$(dirname "$out")"
tmp=$(mktemp) || exit 0
{
    echo "# Simple Linux: palette for tui-shim, written by noctalia/hooks/colors.d/30-tui-shim.sh from the wallpaper colours"
    echo
    echo "| name | hex |"
    echo "|---|---|"
    row() { printf '| `%s` | `#%s` |\n' "$1" "$(echo "$2" | tr a-f A-F)"; }
    row bg "$bg";                       row bg_alt "$(mix "$bg" "$fg" 8)";   row bg_paper "$paper"
    row fg "$fg";                       row fg_dim "$dim";                   row accent "$accent"
    row secondary "$dim";               row khaki "$sel";                    row khaki_dark "$(mix "$sel" "$fg" 35)"
    row hills "$(mix "$bg" "$fg" 20)";  row hills_dark "$(mix "$bg" "$fg" 40)"
    row yellow "$(pal 3)";              row yellow_dark "$(mix "$(pal 3)" "$fg" 30)"
    echo
    echo "## ANSI"
    echo
    echo "| slot | normal | bright |"
    echo "|---|---|---|"
    n=0
    for name in black red green yellow blue magenta cyan white; do
        row_n=$(pal $n); row_b=$(pal $((n + 8)))
        printf '| `%s` | `#%s` | `#%s` |\n' "$name" "$(echo "$row_n" | tr a-f A-F)" "$(echo "${row_b:-$row_n}" | tr a-f A-F)"
        n=$((n + 1))
    done
} > "$tmp" && cat "$tmp" > "$out"
rm -f "$tmp"
exit 0
