
alias shutdown='sudo shutdown now -h'

alias emacs='emacs -nw'

#this works around the issue of sudo not inheriting bash aliases by resolving the alias before calling sudo and retains the path allowing scripts to be run
alias sudo='sudo -s PATH="$PATH" '
