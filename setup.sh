#!/bin/bash

# Install Oh My Zsh if it is not already installed
if [ ! -d ~/.oh-my-zsh ]
then
  echo "Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install powerlevel10k if it is not already installed
if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]
then
  echo "Installing powerlevel10k theme"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "Symlinking dotfiles into home directory"
ln -s ~/dotfiles/dotfiles/* ~/