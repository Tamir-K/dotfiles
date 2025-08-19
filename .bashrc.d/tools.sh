# tools.sh

# Exit if not running interactively
[[ $- == *i* ]] || return

# Tool initializations
eval "$(fzf --bash)" # Set up fzf key bindings and fuzzy completion
eval "$(zoxide init bash)" # Zoxide integration
