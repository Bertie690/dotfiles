# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{bashrc,exports,path,prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset $file;
