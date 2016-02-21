#!/bin/sh

function backup(){
  #echo "$1"
  BACKUP_DIR=${HOME}/dotfiles/backup/`date +%Y%m%d_%H-%M-%S`
  mkdir ${BACKUP_DIR}
  for backup_file in $1; do
    BACKUP_FILE_PATH=${HOME}/${backup_file}
    if [[ -e ${BACKUP_FILE_PATH} ]]; then
      mv -v ${BACKUP_FILE_PATH} ${BACKUP_DIR}/
    fi
  done
  return 0
}

function brew_install(){
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update

  # powerline install
  brew uninstall ricty
  brew tap sanemat/font
  brew install --vim-powerline ricty
  cp -f /usr/local/Cellar/ricty/3.*/share/fonts/Ricty*.ttf ${HOME}/Library/Fonts/
  fc-cache -vf
  return 0
}

function install(){
  # neobundle insatll
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh && sh ./install.sh && rm install.sh

  brew_install
  return 0
}

function set_zsh(){
  chsh -s $(which zsh)
  if [[ ! -e ${HOME}/.zplug ]]; then
    git clone https://github.com/b4b4r07/zplug ${HOME}/.zplug
  fi
}

function create_symbolic_links(){
  # setting symbolic link
  ln -s ${HOME}/dotfiles/vim/vimrc ${HOME}/.vimrc
  ln -s ${HOME}/dotfiles/zsh/zprofile ${HOME}/.zprofile
  ln -s ${HOME}/dotfiles/zsh/zshrc ${HOME}/.zshrc
  return 0
}

echo "HOME===[${HOME}]"
readonly BACKUP_FILES=(".vimrc" ".zprofile" ".zshrc")
backup "${BACKUP_FILES[*]}"
install
set_zsh
create_symbolic_links

echo "Done!!"
exit 0
