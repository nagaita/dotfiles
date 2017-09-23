#!/bin/bash

set -eu

ln -sfv "$(pwd)/dot.Xmodmap" "$HOME/.Xmodmap"
ln -sfv "$(pwd)/dot.peco" "$HOME/.peco"
ln -sfv "$(pwd)/dot.tmux.conf" "$HOME/.tmux.conf"
ln -sfv "$(pwd)/dot.vim" "$HOME/.vim"
ln -sfv "$(pwd)/dot.vimrc" "$HOME/.vimrc"
ln -sfv "$(pwd)/dot.zshrc" "$HOME/.zshrc"
ln -sfv "$(pwd)/dot.zshenv" "$HOME/.zshenv"
ln -sfv "$(pwd)/dot.emacs.d" "$HOME/.emacs.d"
ln -sfv "$(pwd)/config.fish" "$HOME/.config/fish/"
ln -sfv "$(pwd)/dot.gitconfig" "$HOME/.gitconfig"
ln -sfv "$(pwd)/dot.bash_profile" "$HOME/.bash_profile"
