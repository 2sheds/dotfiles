# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#umask 002

# check for interactive mode
[[ $- == *i* ]] || return 0
### or ###
# If not running interactively, don't do anything
#[ -z "$PS1" ] && return
### or ###
#case $- in
#    *i*) ;;
#      *) return;;
#esac

export CLICOLOR=1
#export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33'
export LSCOLORS=ExFxBxDxCxegedabagacad
export EDITOR=vi
export GIT_EDITOR=vi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Set our bash prompt according to the branch/status of the current git
# repository.
#
# Forked from http://gist.github.com/31934
# http://gist.github.com/70150
#

        RED="\[\033[0;31m\]"
      GREEN="\[\033[0;32m\]"
     YELLOW="\[\033[0;33m\]"
       BLUE="\[\033[0;34m\]"
       TEAL="\[\033[0;36m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
  LIGHT_RED="\[\033[1;31m\]"
 LIGHT_TEAL="\[\033[1;36m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 COLOR_NONE="\[\e[0m\]"

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/mysql/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/mysql/bin
    export PATH
fi

function is_git_repository {
  git branch > /dev/null 2>&1
}

function parse_git_branch {
  # Only display git info if we're inside a git repository.
  is_git_repository || return 1

  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes not staged for commit:" ]]; then
    state="${RED}"
  elif [[ ${git_status} =~ "Changes to be committed:" ]]; then
    state="${YELLOW}"
  else
    state="${GREEN}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="Your branch is (.*) of"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  fi
  diverge_pattern="Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="On branch ([^${IFS}]+)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi

  # Display the prompt.
  echo "${state}(${branch})${remote}${COLOR_NONE} "
}

_DOLLAR_CHAR="${_DOLLAR_CHAR-$}"
_USER_CHAR="${_USER_CHAR-^}"

function prompt_symbol () {
  # Set color of dollar prompt based on return value of previous command.
  if test $1 -eq 0; then
      echo ${_DOLLAR_CHAR}
  else
      echo "${RED}${_DOLLAR_CHAR}${COLOR_NONE}"
  fi
}

function prompt_func () {
  last_return_value=$?
  #PS1="\u@\h \w $(parse_git_branch)$(prompt_symbol $last_return_value) "
  #PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\033[00m\]$(parse_git_branch)$(prompt_symbol $last_return_value) "
  #PS1='\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ '
  user=$USER
  # set a fancy prompt (non-color, unless we know we "want" color)
  case "$TERM" in
    xterm*|rxvt*) 
      color_prompt=yes; 
      PS1="\[\e]0;\u@\h: \w\a\]";
      ;;
    *)
      PS1='';
      ;;
  esac

  # uncomment for a colored prompt, if the terminal has the capability; turned
  # off by default to not distract the user: the focus in a terminal window
  # should be on the output of commands, not on the prompt
  #force_color_prompt=yes

  if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
  fi
  if [ "$color_prompt" = yes ]; then
    #PS1="$PS1$RED[$YELLOW$(date "+%H:%M:%S")$RED]$COLOR_NONE \[\033[36m\]\u\[\033[m\]@\[\033[1;32m\]\h$COLOR_NONE:$YELLOW\w$COLOR_NONE \[\033[00m\]$(parse_git_branch)$(prompt_symbol $last_return_value) "
    PS1="$PS1$RED[$YELLOW$(date "+%H:%M:%S")$RED]$COLOR_NONE $LIGHT_TEAL\u$COLOR_NONE@$LIGHT_GREEN\h$COLOR_NONE:$YELLOW\w$COLOR_NONE $COLOR_NONE$(parse_git_branch)$(prompt_symbol $last_return_value) "
  else
    PS1="$PS1[$(date "+%H:%M:%S")] \u@\h:\w $(parse_git_branch)$(prompt_symbol $last_return_value) "
  fi
  if [ -n "$(type -t __git_ps1)" ] && [ "$(type -t __git_ps1)" = function ] && [ "$(type -t __drush_ps1)" ] && [ "$(type -t __drush_ps1)" = function ]; then
    PS1="$PS1$(__drush_ps1 '[%s]')"
  fi
  unset color_prompt force_color_promp
}

PROMPT_COMMAND=prompt_func
  # bash calls this command to determine the prompt, each time

# look for any unattached screen sessions and automatically attach to the first one found http://tlug.dnho.net/?q=node/239
#if [ $SSH_TTY ] && [ ! $WINDOW ]; then
#  SCREENLIST=`screen -ls | grep 'Attached'`
#  if [ $? -eq "0" ]; then
#    echo -e "Screen is already running and attached:\n ${SCREENLIST}"
#  else
#    screen -U -R
#  fi
#fi
