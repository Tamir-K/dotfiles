# .bashrc

# Exit if not running interactively
if ! [[ $- == *i* ]]; then
    return
fi

# Ensure user-specific directories are included in PATH for local binaries
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
      PATH="$HOME/.local/bin:$HOME/bin:$PATH" 
fi
export PATH

shopt -s checkwinsize  # Update LINES and COLUMNS variables after each command to reflect the current terminal window size

eval '$(starship init bash)' # Use starship prompt

# Source all configuration files in ~/.bashrc.d for modular shell settings.
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi 
    done
fi
unset rc
