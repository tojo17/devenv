# Dev Environment Quick Setup

This applies some rc and aliases to bash or zsh.  
If using WSL, it also sets up wsl-ssh-agent and sync ssh keys with Windows.  
You should install git before running this script. No zsh or zsh plugins are installed.

## Install

``` bash
. <(curl --fail --show-error --silent --location -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/toshichi/devenv/master/install.sh)
```

## What this script does

- Make a `.devzshrc` or a `.devbashrc` in your home directory with commands from:
  - `rc_bash.sh`
    - color settings
    - key bindings
  - or `rc_zsh.sh`
    - default history / auto complete settings
    - color settings
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

You can install them with `install_plugins.zsh` or manually.

- Japanese font: [Explex NF](https://github.com/yuru7/Explex)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
- [extract](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract)
  - This is a part of oh-my-zsh, but you can install it separately.
  - You still need to clone the whole oh-my-zsh to make it easier to update.
- ~~[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)~~
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- [zsh-z](https://github.com/agkozak/zsh-z)
- [thefuck](https://github.com/nvbn/thefuck)
  - `pip install thefuck` should be run manually


## Other memo

### SSH and git in WSL

The flow of authentication goes as:

`ssh key file` -> `windows ssh-agent` -> `WSL ssh-agent` -> `ssh client` -> `git client`

For each of them we have several options, and we can mix them.  
We will discuss them from the end of the flow to the beginning.

#### 1. Clients

About the clients under WSL, we have the following options:
- Windows OpenSSH client + Windows git client
  - Set alias by
    ``` bash
    # ssh binaries
    alias ssh-add='ssh-add.exe'
    alias ssh='ssh.exe'
    alias scp='scp.exe'
    alias sftp='sftp.exe'
    # git binary
    alias git='git.exe'
    ```
  - Should work well but git.exe uses config file from Windows, so the new line character may cause trouble.
- Windows OpenSSH client + WSL git client (**<--Used by this script**)
  - Set the aliases of ssh binaries as above, but no need to set git alias
  - Set WSL git to use Windows ssh.exe by `git config --global core.sshcommand "ssh.exe"`
    - This may cause git pull to fail, so you may need to update Windows OpenSSH client to the latest preview version by `winget install "openssh preview"` (PowerShell)
  - WSL git uses WSL's config file, separate from Windows git, so you can have different settings for each.
- Windows OpenSSH client + WSL git client via WSL ssh client
  - *Need to pass keys to WSL's ssh client(see below)
  - Set the aliases of ssh binaries as above, but no need to set git alias
  - No need to set `core.sshcommand` in git config
  - Mostly this has no benefit over the above option, only when WSL ssh client fails to work with some ssh servers but fine with git.
- WSL OpenSSH client + WSL git client
  - *Need to pass keys to WSL's ssh client(see below)
  - No need to set aliases
  - This makes WSL binaries independent from Windows binaries, only when you have trouble calling Windows binaries from WSL.

#### 2. Pass the keys & WSL's ssh-agent

We also need ssh-agent to pass keys to ssh clients.   
If you use only Windows OpenSSH client, you can skip this section.  
If you choosed to use WSL's ssh client in the above section, we need to make ssh-agent work in WSL:
- Copy key files from Windows to WSL, and use WSL's ssh-agent
  - Use `rsync -avq --delete --chmod=600 {[win_home]}/.ssh ~` in WSL to sync keys(and `~/.ssh/config` if you have)
  - No advice for WSL's ssh-agent, you should make it work by yourself.
  - (But if you choose `Windows OpenSSH client + WSL git client via WSL ssh client`, copying files is enough. You don't need a WSL ssh-agent as it uses Windows's)
  - This makes WSL's keys independent from Windows keys, only when you have trouble with Windows keys.
- Or proxy Windows ssh-agent to WSL
  - Use `wsl-ssh-agent` to pass keys to WSL's ssh client(WSL1 only), or other solutions.
  - This requires the following windows ssh-agent step.
  - <details>

    <summary>About wsl-ssh-agent</summary>

    This is an alternative to make ssh keys work in WSL.

    - Download https://github.com/rupor-github/wsl-ssh-agent
    - Add new task with Task Scheduler
      - Condition: User Login
      - Target: The exe file above
      - Param: `-socket C:\Users\toshichi\ssh-agent.sock` (Use your own user name)
      - referring to `sshagent.xml`
    - Run the task manually for the first time
    - `export SSH_AUTH_SOCK={[win_home]}/ssh-agent.sock` in `.bashrc` or `.zshrc`

    Ref: [混沌を極めるWindowsのssh-agent事情](https://qiita.com/slotport/items/e1d5a5dbd3aa7c6a2a24#wsl1wsl2-%E3%81%AE-ssh-agent)

    </details>

#### 3. Windows's ssh-agent

If we use ssh.exe, we shoule make ssh-agent work in Windows:
- Use Windows OpenSSH agent by enabling `OpenSSH Authentication Agent` service
- Or use password manager's ssh-agent, like Bitwarden, KeePassXC or 1Password

#### 4. Test

After install everything, try `ssh-add -l` in WSL.

### zsh

If your zsh comes with your OS, you may want to run `zsh-newuser-install` or when it don't work:
``` bash
autoload -Uz zsh-newuser-install; zsh-newuser-install -f
```

This is not necessary if you are OK with the default settings.