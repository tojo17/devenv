# Dev Environment Quick Setup

This applies some rc and aliases to bash or zsh.  
If using WSL, it also sets up wsl-ssh-agent and sync ssh keys with Windows.  
You should install git before running this script. No zsh or zsh plugins are installed.

## Before Install

### zsh

If your zsh comes with your OS, you may want to run `zsh-newuser-install` or:
``` bash
autoload -Uz zsh-newuser-install; zsh-newuser-install -f
```

### WSL

- Enable Windows service `OpenSSH Authentication Agent`
- After install this script, try `ssh-add -l` in WSL

<details>

<summary>About wsl-ssh-agent</summary>

This is an alternative to make ssh keys work in WSL.

- Download https://github.com/rupor-github/wsl-ssh-agent
- Add new task with Task Scheduler
  - Condition: User Login
  - Target: The exe file above
  - Param: `-socket C:\Users\toshichi\ssh-agent.sock` (Use your own user name)
  - referring to `sshagent.xml`
- Run the task manually for the first time

Ref: [混沌を極めるWindowsのssh-agent事情](https://qiita.com/slotport/items/e1d5a5dbd3aa7c6a2a24#wsl1wsl2-%E3%81%AE-ssh-agent)

</details>


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
    - redirect `ssh`, `scp`, `ssh-add`, etc to Windows side ([Ref](https://medium.com/@wondrous_oxblood_cheetah_508/ssh-agent-on-windows-c74b90fb2e31))
    - add `cdw` command to cd to Windows path
- Create a `devenv-plugins` directory for you to put any plugins you want to auto update
  - when run `update.sh`, it will also update all plugins in this directory


## Install plugins

- This should be installed after running the script.
- You can install any plugins you want to auto update in `devenv-plugins` directory. Follow the manual update instructions of each plugin.
- If the plugin instructs to add something to `.zshrc` or `.bashrc`, do as instructed. Do not modify `.devzshrc` or `.devbashrc` directly, as they will be overwritten by the update script.

### Some useful plugins

- Japanese font: [Explex NF](https://github.com/yuru7/Explex)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

  ``` bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/devenv-plugins/powerlevel10k
  echo 'source ~/devenv-plugins/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
  ```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
- 



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