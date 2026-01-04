#!/usr/bin/env bash

# Config file for boostrap script.

config_dir="$(systemd-path user-configuration)"

# Associative array containing globs linking source folders to their corresponding target folders.
# All source paths will be interpreted relative to $DOTFILES_ROOT, and all destination paths
# relative to the root folder.
#
# If a glob is specified as a source path, all matched files will be linked to the root of target
# (ignoring intermediate directories).
# Otherwise, the target file/folder will be linked directly.
#
# Paths will be matched in reverse alphabetical order (longest first),
# and only the first match will be executed.
declare -A sources_to_targets=(
    # Git config files go in their own dir
    # TODO: Make this 100% XDG-compliant
    ["links/git/.gitconfig"]="$config_dir/git/config"
    ["links/git/.gitignore"]="$config_dir/git/ignore"
    ["links/git/**"]="$config_dir/git"
    ["links/env/**"]="$config_dir/env"
    ["links/**"]="$HOME"
    # Move `gh` specific settings into corresponding folder;
    # dump everything else in XDG_CONFIG_HOME directly
    ["config/gh/**"]="$config_dir/gh"
    ["config/**"]="$config_dir"
)

# Array containing keys of sources_to_targets, sorted in reverse alphabetical order.
declare -a sources_order
# shellcheck disable=SC2034
# (we use this in bootstrap.sh)
readarray -t sources_order <<< "$(printf "%s\n" "${!sources_to_targets[@]}" | \
    sort --stable --reverse)"
