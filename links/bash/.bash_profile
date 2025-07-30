# Load the shell dotfiles, and then some:
# * ~/.exports can be used to configure exports from various files
# * ~/.path can be used to extend `$PATH` (potentially with exported vars).
for file in ~/.{exports,path,aliases}; do
	[[ -r "$file" && -f "$file" ]] && source "$file" || echo "$file not found!";
done;

# Only run .bashrc if not in VS Code integrated terminal (since that specifically runs .bashrc`
# and not .profile, we have to run the latter from the former)
[[ "$TERM_PROGRAM" != "vscode" &&  -r ~/.bashrc && -f ~/.bashrc ]] && source ~/.bashrc;
