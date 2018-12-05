#!/bin/bash

# Installation path
USER_BIN_INSTALL_PATH=${HOME}/local/bin

function check_git() {
}

function get_git_completion_bash() {
  curl -L wget https://github.com/git/git/raw/master/contrib/completion/git-completion.bash \
    -o ${HOME}/.git-completion.bash
}

function fzf_install() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}

function get_diff_so_fancy() {
  curl -L https://github.com/so-fancy/diff-so-fancy/raw/master/diff-so-fancy \
    -o ${USER_BIN_INSTALL_PATH}/diff-so-fancy
}

function get_bazel() {
}
