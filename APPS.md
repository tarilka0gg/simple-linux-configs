# apps/

Starting configuration for programs whose colours Noctalia generates. Noctalia's own hooks (`apply.sh`, one per template) only
*edit* an existing config file of the program to select the generated theme; on a fresh system there is none, the hook reports
"no config file found" and the program keeps its default colours. These files are copied into `~/.config` so the hooks have
something to edit. Which templates run is `[theme.templates]` in `noctalia/config.toml`.
