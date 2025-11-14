# Load the shell dotfiles, and then some:
# * ~/.exports can be used to configure exports from various files
# * ~/.path can be used to extend `$PATH` (potentially with exported vars).
for file in ~/.{exports,path,options,bashrc}; do
	[[ -r "$file" && -f "$file" ]] && source "$file" || echo "$file not found!";
done;
. "$HOME/.cargo/env"
