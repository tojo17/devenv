# on error exit
(
    set -e

    TARGET_DIR="${TARGET_DIR:-$HOME/devenv}"

    # git should be already installed
    git -C "$TARGET_DIR" pull || git clone https://github.com/toshichi/devenv.git "$TARGET_DIR"

    # run update.sh to generate rc file
    # shellcheck disable=SC1090
    source "$TARGET_DIR/update.sh"

    # add rc.sh to current shell rc
    # if bash
    if [ -n "$BASH_VERSION" ]; then
        touch "$HOME/.bashrc"
        if ! grep -Fqx "source ~/.devbashrc" "$HOME/.bashrc"; then
            echo "source ~/.devbashrc" >> "$HOME/.bashrc"
            echo "added source ~/.devbashrc to ~/.bashrc"
        else
            echo "source ~/.devbashrc already present in ~/.bashrc"
        fi
    fi
    # if zsh
    if [ -n "$ZSH_VERSION" ]; then
        touch "$HOME/.zshrc"
        if ! grep -Fqx "source ~/.devzshrc" "$HOME/.zshrc"; then
            echo "source ~/.devzshrc" >> "$HOME/.zshrc"
            echo "added source ~/.devzshrc to ~/.zshrc"
        else
            echo "source ~/.devzshrc already present in ~/.zshrc"
        fi
    fi
    # if WSL
    # if grep -iq Microsoft /proc/version; then
    #     echo "Set WSL git to use Windows ssh.exe"
    #     git config --global core.sshcommand "ssh.exe"
    #     echo "Remove with 'git config --global --unset core.sshcommand' if you have different choice"
    # fi
)
