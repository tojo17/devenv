#!/bin/zsh
set -e

# Create plugins directory
PLUGINS_DIR=~/devenv-plugins
mkdir -p "$PLUGINS_DIR"

echo "Installing zsh plugins..."

# Function to safely add a line to zshrc if not already present
safe_append_zshrc() {
    local line="$1"
    local zshrc="$HOME/.zshrc"
    
    if [ ! -f "$zshrc" ]; then
        touch "$zshrc" || { echo "Error: Cannot create $zshrc"; exit 1; }
    fi
    
    if ! grep -q -F "$line" "$zshrc"; then
        echo "$line" >> "$zshrc" || { echo "Error: Cannot write to $zshrc"; exit 1; }
        echo "Added to ~/.zshrc: $line"
    else
        echo "Already in ~/.zshrc: $line"
    fi
}

# Function to safely clone a repository
safe_clone() {
    local repo="$1"
    local target="$2"
    
    if [ -d "$target" ]; then
        echo "$target already exists, updating instead..."
        if ! git -C "$target" pull; then
            echo "Warning: Failed to update $target"
        fi
    else
        echo "Cloning $repo to $target"
        if ! git clone --depth=1 "$repo" "$target"; then
            echo "Error: Failed to clone $repo"
            return 1
        fi
    fi
    
    # Verify the clone/update succeeded
    if [ ! -d "$target/.git" ]; then
        echo "Error: Repository not properly cloned to $target"
        return 1
    fi
    
    return 0
}

# powerlevel10k
if safe_clone "https://github.com/romkatv/powerlevel10k.git" "$PLUGINS_DIR/powerlevel10k"; then
    # only start when attached to a terminal to avoid errors
    safe_append_zshrc '[[ $- == *i* ]] && source ~/devenv-plugins/powerlevel10k/powerlevel10k.zsh-theme'
fi

# zsh-autosuggestions
if safe_clone "https://github.com/zsh-users/zsh-autosuggestions.git" "$PLUGINS_DIR/zsh-autosuggestions"; then
    safe_append_zshrc 'source ~/devenv-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
fi

# extract from oh-my-zsh
if safe_clone "https://github.com/ohmyzsh/ohmyzsh.git" "$PLUGINS_DIR/oh-my-zsh"; then
    if [ -f "$PLUGINS_DIR/oh-my-zsh/plugins/extract/extract.plugin.zsh" ]; then
        safe_append_zshrc 'source ~/devenv-plugins/oh-my-zsh/plugins/extract/extract.plugin.zsh'
    else
        echo "Error: extract plugin not found in oh-my-zsh"
    fi
fi

# fast-syntax-highlighting
if safe_clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$PLUGINS_DIR/fast-syntax-highlighting"; then
    safe_append_zshrc 'source ~/devenv-plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh'
fi

# zsh-z
if safe_clone "https://github.com/agkozak/zsh-z.git" "$PLUGINS_DIR/zsh-z"; then
    safe_append_zshrc 'source ~/devenv-plugins/zsh-z/zsh-z.plugin.zsh'
fi

# thefuck
# Check if thefuck is installed
if command -v thefuck >/dev/null 2>&1; then
    safe_append_zshrc 'eval $(thefuck --alias)'
    echo "thefuck integration added (make sure it's installed with 'pip install thefuck')"
else
    echo "Note: 'thefuck' command not found. Install it with: pip install thefuck"
fi

echo "\nAll plugins installed successfully!"
echo "Run 'source ~/.zshrc' to apply changes or restart your terminal"