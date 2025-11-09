# .bashrc

# Exit if not running interactively
[[ $- == *i* ]] || return

# Ensure user-specific directories are included in PATH for local binaries
[[ ":$PATH:" == ∗":$HOME/.local/bin:"* ]] || PATH="$HOME/.local/bin:$PATH"
[[ ":$PATH:" == ∗":$HOME/bin:"* ]] || PATH="$HOME/bin:$PATH"
export PATH

# Shell options
shopt -s autocd # Enable navigation by typing directory names
shopt -s checkwinsize # Update LINES and COLUMNS variables after each command to reflect the current terminal window size

# Tool integrations
eval "$(starship init bash)" # starship prompt
eval "$(fzf --bash)" # fzf key bindings
eval "$(zoxide init bash)" # zoxide

# History settings
shopt -s histappend # Append to the history file, don't overwrite it
HISTCONTROL=ignoreboth # Don't put duplicate lines or lines starting with space in the history. 
HISTSIZE=1000
HISTFILESIZE=2000

# Enable color support of ls and grep
if command -v dircolors > /dev/null; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# grep aliases
alias egrep='grep -E'
alias fgrep='grep -F'

# ls aliases
alias l='ls -F'
alias la='ls -AF'
alias ll='ls -lAF'

# Git alias for dotfiles management
alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Package management aliases
alias dnfi='sudo dnf install $(dnf repoquery --queryformat="%{name}\n" | fzf --multi --preview="dnf info {}" --preview-window=60%)'
alias dnfr='sudo dnf remove $(dnf repoquery --installed --queryformat="%{name}\n" | fzf --multi --preview="dnf info {}" --preview-window=60%)'
alias dnfu='sudo dnf update'

# Podman aliases
alias d='podman'
alias dc='d compose'
alias dps='d ps'

# More aliases
alias cls='clear'
alias ipconfig='ip addr show'
alias arp='ip neigh show'
