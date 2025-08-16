# history.sh

# Exit if not running interactively
if ! [[ $- == *i* ]]; then
    return
fi

# History settings
shopt -s histappend # Append to the history file, don't overwrite it
HISTCONTROL=ignoreboth # Don't put duplicate lines or lines starting with space in the history.
HISTSIZE=1000
HISTFILESIZE=2000
