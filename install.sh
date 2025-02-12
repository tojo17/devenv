# on error exit
(
    set -e

    TARGET_DIR=~/devenv

    # git should be already installed
    git -C "$TARGET_DIR" pull || git clone https://github.com/toshichi/devenv.git "$TARGET_DIR"

    # run update.sh to generate rc file
    source ~/devenv/update.sh

    # add rc.sh to current shell rc
    # if bash
    if [ -n "$BASH_VERSION" ]; then
        echo "source ~/.devbashrc" >> ~/.bashrc
        echo "added source ~/.devbashrc to ~/.bashrc"
    fi
    # if zsh
    if [ -n "$ZSH_VERSION" ]; then
        echo "source ~/.devzshrc" >> ~/.zshrc
        echo "added source ~/.devzshrc to ~/.zshrc"
    fi
    # if WSL
    if grep -iq Microsoft /proc/version; then
        echo "Set WSL git to use Windows ssh.exe"
        git config --global core.sshcommand "ssh.exe"
        echo "Remove with 'git config --global --unset core.sshcommand' if you have different choice"
    fi
)
