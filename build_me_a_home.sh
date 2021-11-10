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

function _backup_and_copy() {
  # $1: src file
  # $2: dest
  local srcfile=$1
  local destfile=$2
  _backup_if_exist ${destfile}
  cp ${srcfile} ${destfile}
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
  local target_path=${USER_BIN_INSTALL_PATH}/diff-so-fancy
  curl -L \
    https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
    > ${target_path} && chmod 0755 ${target_path}
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

function get_fdfind() {
  sudo apt-get install fd-find
}

function get_locales_data() {
  sudo apt-get install locales-all
}

function get_curl() {
  sudo apt-get install curl
}

function config_git() {
  git config --global push.default 'simple'

  git config --global core.editor vim
  git config --global core.whitespace 'fix,-indent-with-non-tab,trailing-space,cr-at-eol'
  git config --global core.excludesfile '~/.gitignore'
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

  git config --global alias.au 'add --update'
  git config --global alias.b 'branch -vv'
  git config --global alias.ba 'branch -vv -a'
  git config --global alias.ci 'commit'
  git config --global alias.ca 'commit --amend --no-edit'
  git config --global alias.co 'checkout'
  git config --global alias.st 'status'
  git config --global alias.stb 'status -s -b'
  git config --global alias.fe 'fetch -p'
}

function build_home() {
  mkdir -p ${USER_BIN_INSTALL_PATH}
  get_curl
  get_locales_data
  get_git_completion_bash
  get_fdfind
  fzf_install
  get_diff_so_fancy
  get_dircolors
  get_ack
  config_git

  _backup_and_copy $PWD/_tmux.conf ~/.tmux.conf
  _backup_and_copy $PWD/_vimrc ~/.vimrc
  _backup_and_copy $PWD/_mybashrc ~/.bashrc
}
