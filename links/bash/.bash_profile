#! /usr/bin/env bash

if command -v systemd-path >/dev/null 2>&1; then
    config_dir="$(systemd-path user-configuration)"
else
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
fi

# Load the shell dotfiles, and then some:
# * ~/.exports can be used to configure exports from various files
# * ~/.path can be used to extend `$PATH` (potentially with exported vars).
for file in "$config_dir"/env/{.exports,.path,.options} "$HOME/.bashrc"; do
    if [[ -r "$file" && -f "$file" ]]; then
        source "$file" || echo "Error launching $file!" >&2
    else
        echo "$file not found!"
    fi
done;
