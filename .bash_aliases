
alias shutdown='sudo /sbin/shutdown'

alias emacs='emacs -nw'

# this works around the issue of sudo not inheriting bash aliases by resolving the alias before calling sudo and retains the path allowing scripts to be run
alias sudo='sudo -s PATH="$PATH" '

# fast cd ups/whatever
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias prev='cd -'

# home aliases
alias home='cd ~'
alias bin='cd ~/bin'

alias mkdir="mkdir -pv"

# requires thefuck
alias frick="fuck"

# safety first
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# confirmation
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# continue
alias wget='wget -c'