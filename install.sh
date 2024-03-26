#!/bin/bash

# on error exit
set -e

# git should be already installed
git clone https://github.com/toshichi/devenv.git ~/devenv

# run update.sh to generate rc file
source ~/devenv/update.sh

# add rc.sh to current shell rc
# if bash
if [ -n "$BASH_VERSION" ]; then
    echo "source ~/devenv/rc.sh" >> ~/.bashrc
    echo "added source ~/devenv/rc.sh to ~/.bashrc"
fi
# if zsh
if [ -n "$ZSH_VERSION" ]; then
    echo "source ~/devenv/rc.sh" >> ~/.zshrc
    echo "added source ~/devenv/rc.sh to ~/.zshrc"
fi
