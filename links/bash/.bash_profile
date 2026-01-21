#! /usr/bin/env bash

# Load the shell dotfiles, and then some:
# * ~/.exports can be used to configure exports from various files
# * ~/.path can be used to extend `$PATH` (potentially with exported vars).
for file in "$(systemd-path user-configuration)"/env/{.exports,.path,.options} "$(systemd-path user)/.bashrc"; do
    if [[ -r "$file" && -f "$file" ]]; then
        source "$file" || echo "Error launching $file!" >&2
    else
        echo "$file not found!"
    fi
done;

# Load local (untracked) customizations if present
if [[ -r "$(systemd-path user-configuration)"/env/.local && -f "$(systemd-path user-configuration)"/env/.local ]]; then
    source "$(systemd-path user-configuration)"/env/.local || echo "Error launching local configs!" >&2
fi
