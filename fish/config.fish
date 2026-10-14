# Simple Linux: the author's fish setup, with his machine-specific parts left out.
# Prompt: tide (functions/, conf.d/tide-config.fish). Plugins: fisher, tide, sponge, autopair (see fish_plugins).
# Every tool is checked first, so a system without it just keeps the plain command.

set -gx EDITOR micro

if status is-interactive
    set fish_greeting

    # Clearing the scrollback too, and the typos of it
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"

    if command -q eza
        alias ls 'eza --icons --group-directories-first'
        alias ll 'eza -la --icons --group-directories-first --git'
        alias lt 'eza --tree --icons --level=2'
    end
    command -q micro; and alias nano micro
    command -q dust; and alias du dust
    command -q gping; and alias ping gping
    command -q doas; and alias sudo doas
    command -q hyperfine; and alias bench hyperfine
    command -q cbonsai; and alias bonsai 'cbonsai -l'

    command -q zoxide; and zoxide init fish | source
    command -q fzf; and fzf --fish | source

    # fastfetch on the first prompt, cleared again when the first command is typed
    if command -q fastfetch
        # tui-shim (when installed): micro and nvim get the file-picker badge, TUI apps get launcher entries. Once per user, in the background.
        if command -q tui-shim; and not test -e ~/.config/tui-shim/setup-done
            mkdir -p ~/.config/tui-shim
            tui-shim shims install >/dev/null 2>&1
            contains -- ~/.local/bin $PATH; or set -gx PATH ~/.local/bin $PATH   # the shims have to come before /usr/bin
            fish -c 'tui-shim sync --no-theme --offline >/dev/null 2>&1; touch ~/.config/tui-shim/setup-done' &
            disown
        end
        # fastfetch measures the terminal when it starts, and a new window is still being sized by the compositor: wait until the width
        # has stayed the same for three reads (at most 2 s), or the logo and the title come out wrapped and cut off
        set -l fetch_w 0
        set -l fetch_same 0
        for fetch_i in (seq 40)
            set -l fetch_n (tput cols 2>/dev/null)
            if test "$fetch_n" = "$fetch_w"
                set fetch_same (math $fetch_same + 1)
            else
                set fetch_same 0
                set fetch_w $fetch_n
            end
            test $fetch_same -ge 3; and break
            sleep 0.05
        end
        # the big logo needs a roomy window; in a smaller one use the compact braille snake
        set -l fetch_logo ~/.config/fastfetch/simple-linux.txt
        if test (tput cols 2>/dev/null) -lt 100; or test (tput lines 2>/dev/null) -lt 32
            set fetch_logo ~/.config/fastfetch/simple-linux-small.txt
        end
        fastfetch --logo $fetch_logo
        function clear_after_fetch --on-event fish_preexec
            clear
            functions --erase clear_after_fetch
        end
    end
end
