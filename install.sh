#!/bin/bash
# on error exit
(
    set -e

    # Determine script directory for relative paths
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    TARGET_DIR=~/devenv

    # git should be already installed
    git -C "$TARGET_DIR" pull || git clone https://github.com/toshichi/devenv.git "$TARGET_DIR"

    # run update.sh to generate rc file
    if [ -f "$TARGET_DIR/update.sh" ]; then
        source "$TARGET_DIR/update.sh"
    else
        echo "Error: update.sh not found in $TARGET_DIR"
        exit 1
    fi

    # add rc.sh to current shell rc
    # if bash
    if [ -n "$BASH_VERSION" ]; then
        if ! grep -q "source ~/.devbashrc" ~/.bashrc; then
            if ! echo "source ~/.devbashrc" >> ~/.bashrc; then
                echo "Error: Failed to update ~/.bashrc"
                exit 1
            fi
            echo "added source ~/.devbashrc to ~/.bashrc"
        else
            echo "~/.bashrc already contains reference to ~/.devbashrc"
        fi
    fi
    # if zsh
    if [ -n "$ZSH_VERSION" ]; then
        if ! grep -q "source ~/.devzshrc" ~/.zshrc; then
            if ! echo "source ~/.devzshrc" >> ~/.zshrc; then
                echo "Error: Failed to update ~/.zshrc"
                exit 1
            fi
            echo "added source ~/.devzshrc to ~/.zshrc"
        else
            echo "~/.zshrc already contains reference to ~/.devzshrc"
        fi
    fi
    # if WSL
    # if grep -iq Microsoft /proc/version; then
    #     echo "Set WSL git to use Windows ssh.exe"
    #     git config --global core.sshcommand "ssh.exe"
    #     echo "Remove with 'git config --global --unset core.sshcommand' if you have different choice"
    # fi
)
