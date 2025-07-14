HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
bindkey -e

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

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
if [[ $- == *i* ]] && [[ -o interactive ]]; then # if running interactively
    bindkey '^H' backward-kill-word
    bindkey '^[[3;5~' kill-word
    bindkey  "^[[H"   beginning-of-line
    bindkey  "^[[F"   end-of-line
    bindkey  "^[[3~"  delete-char
    bindkey "^[[1;5C" forward-word   # Ctrl + → 
    bindkey "^[[1;5D" backward-word  # Ctrl + ←
fi