#!/bin/bash

# pull latest
git -C ~/devenv pull
# generate rc file
SCRIPT_DIR=~/devenv/template

# if bash
if [ -n "$BASH_VERSION" ]; then
    echo "bash detected"
    RC_FILE=$SCRIPT_DIR/rc_bash.sh
    OUTFILE=~/.devbashrc
fi
# if zsh
if [ -n "$ZSH_VERSION" ]; then
    echo "zsh detected"
    RC_FILE=$SCRIPT_DIR/rc_zsh.sh
    OUTFILE=~/.devzshrc
fi

echo "Generating $OUTFILE"
cat $RC_FILE >| $OUTFILE
echo "" >> $OUTFILE
cat $SCRIPT_DIR/aliases.sh >> $OUTFILE
echo "" >> $OUTFILE
# check if WSL
if grep -iq Microsoft /proc/version; then
    echo "WSL detected"
    # get windows home path
    WIN_HOME="$(wslpath $(powershell.exe -NoProfile -NonInteractive -Command "\$Env:UserProfile" | tr -d '\r'))" 
    echo "Windows home path: $WIN_HOME"
    # replace {[win_home]} with $WIN_HOME for wsl.sh, and append to $OUTFILE
    sed "s|{\[win_home\]}|$WIN_HOME|g" $SCRIPT_DIR/wsl.sh >> $OUTFILE
fi
