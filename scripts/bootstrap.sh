#!/usr/bin/env bash
#
# bootstrap creates symlinks to necessary files inside various directories.
# Sourced from https://github.com/holman/dotfiles/blob/master/script/bootstrap
# with a bit of tweaking

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
set -e
echo ''

# Paths to directories

SYMLINK_DIR=$DOTFILES_ROOT/links              # Will be linked straight into home dir
CONFIG_DIR=$DOTFILES_ROOT/config              # Config file source directories
CONFIG_DEST=.$HOME/.config     # Destination for config files
MAX_DEPTH=2                    # Maximum recursion depth for subdirectories

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
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

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")) - please select a response.\n\
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
      success "Removed $dst."
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "Moved $dst to ${dst}.backup."
    fi

    if [ "$skip" == "true" ]
    then
      success "Skipped linking $src."
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$src" "$dst"
    success "Symlinked $src to $dst!"
  fi
}

symlink_dotfiles () {
  info "Symlinking dotfiles from $SYMLINK_DIR into $HOME..."

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$SYMLINK_DIR" -maxdepth $MAX_DEPTH)
  do
    dst="$HOME/$(basename "$src")"
    link_file "$src" "$dst"
  done
}

symlink_configs () {
  info "Symlinking config from $CONFIG_DIR into $CONFIG_DEST..."

  local overwrite_all=false backup_all=false skip_all=false

  # regex to extract
  local regex="$CONFIG_DIR/(*)"

  for file in $(find -H "$CONFIG_DIR" -maxdepth $MAX_DEPTH)
  do
    if  [[ $file =~ $regex ]]
    then
    dst="$CONFIG_DEST"/"${BASH_REMATCH[1]}"
    link_file "$src" "$dst"
  done
}

# Install any dependencies listed inside packages
install_dependencies () {
  info 'Installing packages...'
  sh -c ./install_deps.sh
}

symlink_dotfiles
symlink_configs
install_dependencies