``` bash
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/toshichi/devenv/master/install.sh)"
```

## Useful plugins

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

### wsl-ssh-agent

Create a scheduled task referring to `sshagent.xml`
