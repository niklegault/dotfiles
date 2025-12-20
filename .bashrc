#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


format_path() {
    local p="${PWD/#$HOME/\~}"
    
    if [ "$p" = "~" ]; then
        echo "~"
    elif [[ "$p" == "~/"* ]]; then
        echo "~ | ${p#\~/}" | sed 's/\// | /g'
    else
        echo "${p#/}" | sed 's/\// | /g'
    fi
}

PROMPT_COMMAND='DIR_STR=$(format_path)'
export PS1="[\u@\h \${DIR_STR}]\$ "
cat ~/.cache/wal/sequences
