# tools.sh

# Exit if not running interactively
if ! [[ $- == *i* ]]; then
    return
fi

# Tool initializations
eval "$(fzf --bash)" # Set up fzf key bindings and fuzzy completion
eval "$(zoxide init bash)" # Zoxide integration
