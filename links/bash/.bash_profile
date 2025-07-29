# If already initialized, do nothing.
[ -z "$PROFILE_INITIALIZED" ] && return

export PROFILE_INITIALIZED=true

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.

echo "apple"

for file in ~/.{bashrc,exports,path,prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset $file;
