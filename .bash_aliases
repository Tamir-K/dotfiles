alias cls="clear"
alias ipconfig='ip addr show | awk '\''/^[0-9]+: / {print "Interface " $2} /inet / {print "  IPv4 Address: " $2} /inet6 / {print "  IPv6 Address: " $2}'\'''
alias ..="cd .."

# Git alias for dotfiles management
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME' 
