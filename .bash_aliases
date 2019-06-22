#alias cp="rsync -ah --progress"
alias apt-upgrade="sudo apt-get update && sudo apt-get upgrade"
alias cfg='`which git` --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cfg-update='`which git` --git-dir=$HOME/.cfg/ --work-tree=$HOME submodule update --recursive --remote'
if [ -x /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git
  __git_complete cfg __git_main
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

