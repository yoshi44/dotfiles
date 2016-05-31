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

  # vim update
  brew install macvim --with-override-system-vim
  # neovim
  brew install neovim/neovim/neovim

  # powerline install
  brew uninstall ricty
  brew tap sanemat/font
  brew install --vim-powerline ricty
  RICTY_DIR=/usr/local/Cellar/ricty
  if [[ -e ${RICTY_DIR} ]]; then
    cp -f ${RICTY_DIR}/3.*/share/fonts/Ricty*.ttf ${HOME}/Library/Fonts/ && fc-cache -vf
  fi
  return 0
}

function install(){
  # neobundle insatll
  #curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > ${HOME}/install.sh && sh ${HOME}/install.sh && rm ${HOME}/install.sh
  INSTALLER_PATH=${HOME}/dotfiles/installer.sh
  DEIN_INSTALL_DIR=${HOME}/.vim/dein && mkdir -p ${DEIN_INSTALL_DIR}
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${INSTALLER_PATH} && sh ${INSTALLER_PATH} ${DEIN_INSTALL_DIR} && rm ${INSTALLER_PATH}
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
  # neovim 
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  ln -s ${HOME}/dotfiles/vim $XDG_CONFIG_HOME/nvim
  ln -s ${HOME}/dotfiles/vim/vimrc $XDG_CONFIG_HOME/nvim/init.vim

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
