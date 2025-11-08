# .bashrc

# Exit if not running interactively
[[ $- == *i* ]] || return

# Ensure user-specific directories are included in PATH for local binaries
[[ ":$PATH:" == ∗":$HOME/.local/bin:"* ]] || PATH="$HOME/.local/bin:$PATH"
[[ ":$PATH:" == ∗":$HOME/bin:"* ]] || PATH="$HOME/bin:$PATH"
export PATH

shopt -s autocd  # Enable navigation by typing directory names
shopt -s checkwinsize  # Update LINES and COLUMNS variables after each command to reflect the current terminal window size

eval "$(starship init bash)" # Use starship prompt

# Source all configuration files in ~/.bashrc.d for modular shell settings.
shopt -s nullglob
if [ -d "$HOME/.bashrc.d" ]; then
  for rc in "$HOME/.bashrc.d"/*; do
    [ -f "$rc" ] && [ -r "$rc" ] && source "$rc"
  done
  unset rc
fi
