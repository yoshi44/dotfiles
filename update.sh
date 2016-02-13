#!/bin/sh

function backup(){
  NOW=`date +%Y%m%d_%H-%M-%S`
  BACKUP_DIR=${HOME}/dotfiles/backup/${NOW}
  mkdir ${BACKUP_DIR}
  mv ${HOME}/.vimrc ${BACKUP_DIR}/
  mv ${HOME}/.zprofile ${BACKUP_DIR}/
  mv ${HOME}/.zshrc ${BACKUP_DIR}/
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
backup
create_symbolic_links

echo "Done!!"
exit 0
