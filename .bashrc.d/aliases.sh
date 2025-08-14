# aliases.sh

# Exit if not running interactively
if ! [[ $- == *i* ]]; then
    return
fi

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

# More aliases
alias cls='clear'
alias ipconfig='ip addr show | awk '\''/^[0-9]+: / {print "Interface " $2} /inet / {print "  IPv4 Address: " $2} /inet6 / {print "  IPv6 Address: " $2}'\'''
alias ..='cd ..'

# Git alias for dotfiles management
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
