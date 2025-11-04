# aliases.sh

# Exit if not running interactively
[[ $- == *i* ]] || return

# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Package management aliases
alias dnfi='sudo dnf install $(dnf repoquery --queryformat="%{name}\n" | fzf --multi --preview="dnf info {}" --preview-window=60%)'
alias dnfr='sudo dnf remove $(dnf repoquery --installed --queryformat="%{name}\n" | fzf --multi --preview="dnf info {}" --preview-window=60%)'
alias dnfu='sudo dnf update'

# Podman aliases
alias d='podman'
alias dc='d compose'
alias dps='d ps'

# More aliases
alias ..='cd ..'
alias cls='clear'
alias ipconfig='ip addr show'
alias arp='ip neigh show'
