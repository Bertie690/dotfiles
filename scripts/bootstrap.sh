#!/usr/bin/env bash
#
# bootstrap creates symlinks to necessary files inside various directories.
# Sourced from https://github.com/holman/dotfiles/blob/master/script/bootstrap
# with a bit of tweaking

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
set -e
echo $DOTFILES_ROOT

# Paths to directories

SYMLINK_DIR=$DOTFILES_ROOT/links              # Will be linked straight into home dir
CONFIG_DIR=$DOTFILES_ROOT/config              # Config file source directories
CONFIG_DEST=$HOME/.config                    # Destination for config files
MAX_DEPTH=2                                   # Maximum recursion depth for subdirectories

blue () {
  printf "\033[00;34m$1\033[0m"
}

red () {
  printf "\e[31m$1\e[0m"
}

info () {
  printf "[$(blue ...)] $1\n"
}

success () {
  printf "\033[2K[ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # Skip files that are already linked
      if [ "$(readlink $dst)" == "$src" ]
      then
        info "Skipping $(blue $src); already linked to target"
        skip=skipped;
      else

        user "File already exists: $(red $dst) ($(basename "$(blue $src)")) - please select a response.\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    # Use global overrides if provided (or else individual overrides)
    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "Removed $(red $dst)."
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "Moved $(red $dst) to ${dst}.backup."
    fi

    if [ "$skip" == "true" ]
    then
      success "Skipped linking $(blue $src)."
    fi
  fi

  if [ "$skip" != "true" -a "$skip" != "skipped" ]  # "false" or empty
  then
    ln -s "$src" "$dst"
    success "Symlinked $src to $dst!"
  fi
}

symlink_dotfiles () {
  info "Symlinking dotfiles from $(blue $SYMLINK_DIR) into $(blue $HOME)..."

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$SYMLINK_DIR" -maxdepth $MAX_DEPTH -type f)
  do
    dst="$HOME/$(basename "$src")"
    link_file "$src" "$dst"
  done
}

symlink_configs () {
  info "\nSymlinking config files from $(blue $CONFIG_DIR) into $(blue $CONFIG_DEST)...\n"

  local overwrite_all=false backup_all=false skip_all=false

  # regex to extract the path after the config dir and directly link
  local regex="$CONFIG_DIR/(.*)"

  for src in $(find -H "$CONFIG_DIR" -maxdepth $MAX_DEPTH -type f)
  do
    if [[ $src =~ $regex ]]
    then
      dst="$CONFIG_DEST"/"${BASH_REMATCH[1]}"
      link_file "$src" "$dst"
    fi
  done

  unset $overwrite_all $backup_all $skip_all
}

# Install any dependencies listed inside packages
install_dependencies () {
  info 'Installing packages...'
  sh -c $DOTFILES_ROOT/scripts/install_deps.sh
}

symlink_dotfiles
symlink_configs
install_dependencies
success "DONE"!