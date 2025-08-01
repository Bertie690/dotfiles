# Load the shell dotfiles, and then some:
# * ~/.exports can be used to configure exports from various files
# * ~/.path can be used to extend `$PATH` (potentially with exported vars).
for file in ~/.{exports,path,options}; do
	[[ -r "$file" && -f "$file" ]] && source "$file" || echo "$file not found!";
done;

# Only run .bashrc if not in VS Code integrated terminal (VS Code runs ~/.bashrc for each terminal shell)
[[ "$TERM_PROGRAM" != "vscode" && -r ~/.bashrc && -f ~/.bashrc ]] && source ~/.bashrc;
