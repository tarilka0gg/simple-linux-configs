#!/usr/bin/env bash
# Starts Noctalia. The wallpaper is chosen first and written to the config as the default one, so Noctalia's first render is already the
# palette of that wallpaper: no flash of the built-in theme, no second render when the wallpaper changes after the start.
# A different wallpaper from ~/Pictures/Wallpapers (sub-folders included) on every start; a wallpaper the user set himself stays (Noctalia
# remembers it, and what it remembers wins over this default).
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/noctalia/config.toml"
dir="$HOME/Pictures/Wallpapers"
# The hooks of Noctalia's templates only edit a program's config that already exists. A system without these starting configs (an
# older image, a home made by hand) would keep the program's default colours for ever: make the one that matters most.
gh="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
if ! grep -qE '^config-file *= *\?themes/noctalia' "$gh" 2>/dev/null; then
    mkdir -p "$(dirname "$gh")"
    grep -qE '^theme *= *noctalia' "$gh" 2>/dev/null || sed -i -E '/^theme *=/d' "$gh" 2>/dev/null
    grep -qE '^theme *= *noctalia' "$gh" 2>/dev/null || echo 'theme = noctalia' >> "$gh"
    echo 'config-file = ?themes/noctalia' >> "$gh"
fi
pick=$(find -L "$dir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null | shuf -n 1)
if [ -n "$pick" ] && [ -f "$cfg" ]; then
    python3 - "$cfg" "$pick" <<'PY'
import re, sys
cfg, pick = sys.argv[1:3]
text = open(cfg).read()
m = re.search(r'(?ms)^\[wallpaper\.default\]\n(.*?)(?=^\[|\Z)', text)
line = 'path = "%s"\n' % pick.replace('\\', '\\\\').replace('"', '\\"')
if m:
    body = m.group(1)
    body = re.sub(r'(?m)^path\s*=[^\n]*\n', line, body, count=1) if re.search(r'(?m)^path\s*=', body) else line + body
    text = text[:m.start(1)] + body + text[m.end(1):]
else:
    text += '\n[wallpaper.default]\n' + line
open(cfg, 'w').write(text)
PY
fi
exec noctalia
