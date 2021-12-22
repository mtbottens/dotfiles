#!/bin/zsh

if [[ -f ~/.zshrc ]]; then
  if [[ ! -f ~/.zshrc-local ]]; then
    echo "Backing up existing .zshrc file to: ~/.zshrc-local, this should still be loaded"
    mv ~/.zshrc ~/.zshrc-local
  else
    echo "A .zshrc and .zshrc-local file already exists. Please delete one to continue"
    exit 1
  fi
fi

# Install Oh My Zsh if it is not already installed
if [[ ! -d ~/.oh-my-zsh ]]; then
  echo "Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install powerlevel10k if it is not already installed
if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  echo "Installing powerlevel10k theme"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "Symlinking dotfiles into home directory"
for file in ~/dotfiles/dotfiles/*(DN); do
  NEW_PATH=$(echo $file | sed "s/dotfiles\/dotfiles\///")

  if [[ ! -L $NEW_PATH ]]; then
    if [[ -f $NEW_PATH ]]; then
      echo "$NEW_PATH exists and is not a proper symlink, renaming file to $NEW_PATH.backup"
      mv $NEW_PATH $NEW_PATH.backup
    else  
      ln -s $file $NEW_PATH
    fi
  fi
done
