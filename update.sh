#!/bin/sh

function backup(){
  #echo "$1"
  NOW=`date +%Y%m%d_%H-%M-%S`
  BACKUP_DIR=${HOME}/dotfiles/backup/${NOW}
  mkdir ${BACKUP_DIR}
  for backup_file in "$1"; do
    BACKUP_FILE_PATH=${HOME}/${backup_file}
    if [[ -e ${BACKUP_FILE_PATH} ]]; then
      mv ${BACKUP_FILE_PATH} ${BACKUP_DIR}/
    fi
  done
  return 0
}

function install(){
  # neobundle insatll
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
  sh ./install.sh
  return 0
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
create_symbolic_links

echo "Done!!"
exit 0
