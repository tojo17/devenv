``` bash
. <(curl --fail --show-error --silent --location -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/toshichi/devenv/master/install.sh)
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

- `OpenSSH Authentication Agent` のサービスを有効
- https://github.com/rupor-github/wsl-ssh-agent をダウンロード
- Task Scheduler に新しいタスクを追加、条件はユーザーログオン、目標プログラムは上の exe、引数は `-socket C:\Users\toshichi\ssh-agent.sock` (自分のユーザー名にして)
    - referring to `sshagent.xml`
- 上のタスクを一回実行
- WSL の .bashrc などに `export SSH_AUTH_SOCK=/mnt/c/Users/toshichi/ssh-agent.sock` を追加
- WSL を立ち上げ直り、ssh-add -l を実行、キーが出たら成功

参考： [https://qiita.com/slotport/items/e1d5a5dbd3aa7c6a2a24#wsl1wsl2-の-ssh-agent](https://qiita.com/slotport/items/e1d5a5dbd3aa7c6a2a24#wsl1wsl2-%E3%81%AE-ssh-agent)

