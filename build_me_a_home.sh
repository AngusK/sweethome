#!/bin/bash

################# Configurations #################
# Installation path
USER_BIN_INSTALL_PATH=${HOME}/local/bin
BACKUP_EXISTINGFILE=true
################# Configurations End #############


TIMESTAMP=$(date '+%Y-%m-%d-%H%M%S')
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
  if [ -f "${output_path}" ]; then
    echo
    echo "${output_path} already exists!"
    sleep 1
    if [ "${BACKUP_EXISTINGFILE}" = false ]; then
      echo 1
      return
    fi
    echo "Moving ${output_path} to ${output_path}.${TIMESTAMP}"
    echo
    sleep 1
    mv ${output_path} ${output_path}.${TIMESTAMP}
    echo "!!!!!!!!!!!!!!"
  fi
  curl -L https://github.com/${acct}/${repo}/raw/master/${fpath} \
    -o ${output_path}
  echo 0
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

function get_bazel() {
  echo "Not implemented yet."
}
