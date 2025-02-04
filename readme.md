# Dev Environment Quick Setup

This applies some rc and aliases to bash or zsh.  
If using WSL, it also sets up wsl-ssh-agent and sync ssh keys with Windows.  
You should install git before running this script. No zsh or zsh plugins are installed.

## Before Install

### WSL

#### wsl-ssh-agent

- Enable Windows service `OpenSSH Authentication Agent`
- Download https://github.com/rupor-github/wsl-ssh-agent
- Add new task with Task Scheduler
  - Condition: User Login
  - Target: The exe file above
  - Param: `-socket C:\Users\toshichi\ssh-agent.sock` (Use your own user name)
  - referring to `sshagent.xml`
- Run the task manually for the first time
- After install this script, try `ssh-add -l` in WSL

Ref: [混沌を極めるWindowsのssh-agent事情](https://qiita.com/slotport/items/e1d5a5dbd3aa7c6a2a24#wsl1wsl2-%E3%81%AE-ssh-agent)

## Install

``` bash
. <(curl --fail --show-error --silent --location -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/toshichi/devenv/master/install.sh)
```

## What this script does

- Make a `.devzshrc` or a `.devbashrc` in your home directory with commands from:
  - `rc_bash.sh` or `rc_zsh.sh`
    - key bindings
  - `aliases.sh`
    - some useful aliases
  - if WSL, `wsl.sh`
    - sync ssh keys with Windows
    - set up wsl-ssh-agent


## Useful plugins

This should be installed after running the script.

### `.zshrc`

``` bash
plugins=(
        git
        extract
        z
        zsh-syntax-highlighting
        zsh-autosuggestions
        thefuck
        zsh-autocomplete
)

eval "$(thefuck --alias)"
```

## WSL



