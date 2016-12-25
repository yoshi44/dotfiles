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

  brew install neovim/neovim/neovim

  # python
  brew link xz
  brew install python3
  pip3 install neovim
  pip3 install --upgrade neovim
  pip install --upgrade pip

  # vim update
  brew reinstall macvim

  # powerline install
  brew tap sanemat/font
  brew uninstall ricty
  brew install --vim-powerline ricty
  RICTY_DIR=/usr/local/Cellar/ricty
  if [[ -e ${RICTY_DIR} ]]; then
    cp -f ${RICTY_DIR}/*/share/fonts/Ricty*.ttf ${HOME}/Library/Fonts/ && fc-cache -vf
  fi

  brew doctor
  return 0
}

function install(){
  INSTALLER_PATH=${HOME}/dotfiles/installer.sh
  DEIN_INSTALL_DIR=${HOME}/.vim/dein && mkdir -p ${DEIN_INSTALL_DIR}
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${INSTALLER_PATH} && sh ${INSTALLER_PATH} ${DEIN_INSTALL_DIR} && rm ${INSTALLER_PATH}
  brew_install
  return 0
}

function set_zsh(){
  chsh -s $(which zsh)
  if [[ ! -e ${HOME}/.zplug ]]; then
    cd ${HOME} && curl -sL zplug.sh/installer | zsh
  fi
}

function create_symbolic_links(){
  # setting symbolic link
  # neovim
  XDG_CONFIG_HOME=${HOME}/.config && mkdir -p ${XDG_CONFIG_HOME}
  ln -s ${HOME}/dotfiles/vim/vim ${XDG_CONFIG_HOME}/nvim
  ln -s ${HOME}/dotfiles/vim/vimrc ${XDG_CONFIG_HOME}/nvim/init.vim

  ln -s ${HOME}/dotfiles/vim/vimrc ${HOME}/.vimrc
  ln -s ${HOME}/dotfiles/vim/gvimrc ${HOME}/.gvimrc
  ln -s ${HOME}/dotfiles/zsh/zprofile ${HOME}/.zprofile
  ln -sf ${HOME}/dotfiles/zsh/zshrc ${HOME}/.zshrc

  # git
  ln -sf ${HOME}/dotfiles/git/gitconfig ${HOME}/.gitconfig
  ln -s ${HOME}/dotfiles/git/gitmessage.txt ${HOME}/.gitmessage.txt
  return 0
}

echo "HOME===[${HOME}]"
readonly BACKUP_FILES=(".vimrc" ".zprofile" ".zshrc")
backup "${BACKUP_FILES[*]}"
install
create_symbolic_links
set_zsh

echo "Done!!"
exit 0
