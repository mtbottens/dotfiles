#!/bin/zsh

backup_and_link() {
  local DESIRED_FILE=$1
  local BACKUP_FILE_NAME=$2
  local SYMLINK_SOURCE=$3

  # if file exists
  if [[ -f $DESIRED_FILE ]]; then
    # if file is already a symlink
    if [[ -L $DESIRED_FILE ]]; then
      echo "$DESIRED_FILE is already linked"
      return
    else
      if [[ -f $BACKUP_FILE_NAME ]]; then
        echo "$DESIRED_FILE and $BACKUP_FILE_NAME already exists, delete one to continue"
        return
      fi

      # backup file
      echo "Backing up $DESIRED_FILE to $BACKUP_FILE_NAME"
      mv $DESIRED_FILE $BACKUP_FILE_NAME
    fi
  fi

  # if symlink source is provided, symlink file
  if [[ -f $SYMLINK_SOURCE ]]; then
    echo "Linking $SYMLINK_SOURCE to $DESIRED_FILE"
    ln -s $SYMLINK_SOURCE $DESIRED_FILE
  fi
}

backup_and_link ~/.zshrc ~/.zshrc-local

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

  backup_and_link $NEW_PATH $NEW_PATH.backup $file
done
