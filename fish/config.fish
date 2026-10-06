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
        fastfetch
        function clear_after_fetch --on-event fish_preexec
            clear
            functions --erase clear_after_fetch
        end
    end
end
