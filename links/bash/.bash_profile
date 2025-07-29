# If already initialized, do nothing.
[ -n "$PROFILE_INITIALIZED" ] && return

export PROFILE_INITIALIZED=true

# Load the shell dotfiles, and then some:
# * ~/.exports can be used to configure exports from various files
# * ~/.path can be used to extend `$PATH` (potentially with exported vars).
for file in ~/.{bashrc,exports,path,prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset $file;
