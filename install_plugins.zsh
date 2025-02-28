# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/devenv-plugins/powerlevel10k
# only start when attached to a terminal to avoid errors
echo '[[ -t 1 ]] && source ~/devenv-plugins/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/devenv-plugins/zsh-autosuggestions
echo 'source ~/devenv-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc

# extract
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/devenv-plugins/oh-my-zsh
echo 'source ~/devenv-plugins/oh-my-zsh/plugins/extract/extract.plugin.zsh' >> ~/.zshrc

# fast-syntax-highlighting
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/devenv-plugins/fast-syntax-highlighting
echo "source ~/devenv-plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> ~/.zshrc

# zsh-z
git clone --depth=1 https://github.com/agkozak/zsh-z.git ~/devenv-plugins/zsh-z
echo "source ~/devenv-plugins/zsh-z/zsh-z.plugin.zsh" >> ~/.zshrc

# thefuck
# pip install thefuck
echo "eval \$(thefuck --alias)" >> ~/.zshrc