(
set -euo pipefail

DEVEV_DIR="${DEVEV_DIR:-$HOME/devenv}"

# pull latest (only if already cloned)
if [ -d "$DEVEV_DIR/.git" ]; then
    git -C "$DEVEV_DIR" pull
fi

# generate rc file
SCRIPT_DIR="$DEVEV_DIR/template"

# if bash
RC_FILE=""
OUTFILE=""
if [ -n "$BASH_VERSION" ]; then
    echo "bash detected"
    RC_FILE="$SCRIPT_DIR/rc_bash.sh"
    OUTFILE="$HOME/.devbashrc"
fi
# if zsh
if [ -n "$ZSH_VERSION" ]; then
    echo "zsh detected"
    RC_FILE="$SCRIPT_DIR/rc_zsh.sh"
    OUTFILE="$HOME/.devzshrc"
fi

# if OUTFILE is not set, exit
if [ -z "$OUTFILE" ]; then
    echo "Shell not supported or not detected"
    exit 1
fi


echo "Generating $OUTFILE"
cat "$RC_FILE" > "$OUTFILE"
echo "" >> "$OUTFILE"
cat "$SCRIPT_DIR/aliases.sh" >> "$OUTFILE"
echo "" >> "$OUTFILE"
# check if WSL
if [ -r /proc/version ] && grep -iq microsoft /proc/version; then
    echo "WSL detected"
    # get windows home path
    win_home_win="$(powershell.exe -NoProfile -NonInteractive -Command "\$Env:UserProfile" | tr -d '\r' | tr -d '\n')"
    WIN_HOME="$(wslpath "$win_home_win")"
    echo "Windows home path: $WIN_HOME"
    # replace {[win_home]} with $WIN_HOME for wsl.sh, and append to $OUTFILE
    # Escape sed replacement chars in path (\, &, delimiter)
    win_home_sed="$(printf '%s' "$WIN_HOME" | sed 's/[&|\\]/\\&/g')"
    sed "s|{\[win_home\]}|$win_home_sed|g" "$SCRIPT_DIR/wsl.sh" >> "$OUTFILE"
fi

# pull update for all plugins if exists
mkdir -p "$HOME/devenv-plugins"
for plugin_dir in "$HOME"/devenv-plugins/*; do
    [ -e "$plugin_dir" ] || continue
    # check if git repo
    if [ -d "$plugin_dir/.git" ]; then
        git -C "$plugin_dir" pull || echo "Warning: failed to update $(basename "$plugin_dir")"
    else
        echo "$(basename "$plugin_dir") is not a git repo, skipping"
    fi
done
)