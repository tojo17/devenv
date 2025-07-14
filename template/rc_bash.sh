# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    # Validate dircolors file before evaluating it
    if [ -f ~/.dircolors ]; then
        # Check if file is readable and not empty
        if [ -r ~/.dircolors ] && [ -s ~/.dircolors ]; then
            # Check if file contains any suspicious content
            if ! grep -q "[;&|]" ~/.dircolors; then
                eval "$(dircolors -b ~/.dircolors)" || echo "Warning: Failed to eval dircolors from ~/.dircolors"
            else
                echo "Warning: Skipping ~/.dircolors due to suspicious content"
                eval "$(dircolors -b)"
            fi
        else
            echo "Warning: ~/.dircolors exists but is not readable or is empty"
            eval "$(dircolors -b)"
        fi
    else
        eval "$(dircolors -b)"
    fi
    
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# processing for all platforms
if [[ $- == *i* ]] && [[ -t 1 ]]; then # if running interactively
    bind '"\C-h": backward-kill-word'
    bind '"\e[3;5~": kill-word'
    bind '"\e[1~": beginning-of-line'  # \e[1~ is often used for Home key
    bind '"\e[4~": end-of-line'        # \e[4~ is often used for End key
    bind '"\e[3~": delete-char'
fi