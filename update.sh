#!/bin/bash

# generate rc file
SCRIPT_DIR=~/devenv/template
OUTFILE=~/.devrc.sh
echo "Generating $OUTFILE"
cat $SCRIPT_DIR/rc.sh > $OUTFILE
cat $SCRIPT_DIR/aliases.sh >> $OUTFILE
# check if WSL
if grep -q Microsoft /proc/version; then
    echo "WSL detected"
    # get windows home path
    WIN_HOME="$(wslpath $(powershell.exe -NoProfile -NonInteractive -Command "\$Env:UserProfile"))" 
    echo "Windows home path: $WIN_HOME"
    # replace {[win_home]} with $WIN_HOME for wsl.sh, and append to $OUTFILE
    sed "s/{\[win_home\]}/$WIN_HOME/g" $SCRIPT_DIR/wsl.sh >> $OUTFILE
fi