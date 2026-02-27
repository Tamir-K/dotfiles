# .bashrc

# Exit if not running interactively
[[ $- == *i* ]] || return

# Ensure user-specific directories are included in PATH for local binaries
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || PATH="$HOME/.local/bin:$PATH"
[[ ":$PATH:" == *":$HOME/bin:"* ]] || PATH="$HOME/bin:$PATH"
export PATH

# Shell options
shopt -s autocd # Enable navigation by typing directory names
shopt -s checkwinsize # Update LINES and COLUMNS variables after each command to reflect the current terminal window size

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

# Tool integrations
source /usr/share/bash-completion/bash_completion # bash-completion
eval "$(fzf --bash)" # fzf key bindings

# Prompt config - made using https://bash-prompt-generator.org/
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 "(%s)")'
PS1='\n\[\e[38;5;51;1m\]\w\[\e[0m\] ${PS1_CMD1}\n\[\e[92m\]\$\[\e[0m\] '

# Configure git-prompt options
# Based on https://www.glukhov.org/post/2025/12/adding-git-repo-details-to-bash-prompt/#method-1-using-gits-built-in-git-promptsh-script
GIT_PS1_SHOWDIRTYSTATE=1 # Show unstaged (*) and staged (+) changes
GIT_PS1_SHOWSTASHSTATE=1 # Show if there are stashed changes ($)
GIT_PS1_SHOWUNTRACKEDFILES=1 # Show if there are untracked files (%)
GIT_PS1_SHOWUPSTREAM="auto" # Show difference between HEAD and upstream
GIT_PS1_SHOWCOLORHINTS=1 # Enable colored hints (requires bash 4.0+)

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
alias apti='sudo apt install $(apt-cache pkgnames | fzf --multi --preview="apt show {}" --preview-window=67%)'
alias aptr="sudo apt remove \$(dpkg-query -W -f='\${Package}\n' | fzf --multi --preview='apt show {}' --preview-window=67%)"
alias aptu='sudo apt update && sudo apt upgrade -y'

# Podman aliases
alias d='podman'
alias dc='d compose'
alias dps='d ps'

# More aliases
alias py='python3'
alias cls='clear'
alias ipconfig='ip addr show'
alias arp='ip neigh show'
