# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# processing for all platforms
if [[ -t 1 ]]; then
    bind '"\C-h": backward-kill-word'
    bind '"\e[3;5~": kill-word'
    bind '"\e[1~": beginning-of-line'  # \e[1~ is often used for Home key
    bind '"\e[4~": end-of-line'        # \e[4~ is often used for End key
    bind '"\e[3~": delete-char'
fi