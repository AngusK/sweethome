#!/bin/bash

################# Configurations #################
# Installation path
USER_BIN_INSTALL_PATH=${HOME}/local/bin
BACKUP_EXISTINGFILE=true
################# Configurations End #############


TIMESTAMP=$(date '+%Y-%m-%d-%H%M%S')

function _backup_if_exist() {
  local target_path=$1
  if [ -f "${target_path}" ]; then
    echo
    echo "${target_path} already exists!"
    sleep 1
    echo "Moving ${target_path} to ${target_path}.${TIMESTAMP}"
    echo
    sleep 1
    mv ${target_path} ${target_path}.${TIMESTAMP}
    echo "!!!!!!!!!!!!!!"
  fi
}

function _link() {
  # $1: src file
  # $2: dest
  local srcfile=$1
  local destfile=$2
  _backup_if_exist ${destfile}
  ln -s ${srcfile} ${destfile}
}

function _get_git_file() {
  # Echoes "0" if successful, "1" otherwise.
  #
  # $1: git account
  # $2: git repo
  # $3: file path
  # $4: output path
  local acct=$1
  local repo=$2
  local fpath=$3
  local output_path=$4
  _backup_if_exist ${output_path}
  curl -L https://github.com/${acct}/${repo}/raw/master/${fpath} \
    -o ${output_path}
}

function check_git() {
  echo "Not implemented yet."
}

function get_git_completion_bash() {
  _get_git_file \
    git \
    git \
    contrib/completion/git-completion.bash \
    ${HOME}/.git-completion.bash
}

function fzf_install() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}

function get_diff_so_fancy() {
  _get_git_file \
    so-fancy \
    diff-so-fancy \
    diff-so-fancy \
    ${USER_BIN_INSTALL_PATH}/diff-so-fancy
}

function get_dircolors() {
  _get_git_file \
    seebi \
    dircolors-solarized \
    dircolors.ansi-dark \
    $HOME/.dircolors
}

function get_ack() {
  curl -L https://beyondgrep.com/ack-2.24-single-file > ${USER_BIN_INSTALL_PATH}/ack && chmod 0755 ${USER_BIN_INSTALL_PATH}/ack
}

function get_bazel() {
  echo "Not implemented yet."
}

function build_home() {
  get_git_completion_bash
  fzf_install
  get_diff_so_fancy
  get_dircolors
  get_ack
  . config_git.sh

  _link _tmux.config ~/.tmux.config
  _link _vimrc ~/.vimrc
  _link _mybashrc ~/.bashrc
}
