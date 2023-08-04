#!/bin/fish

################# Configurations #################
# Installation path
set USER_BIN_INSTALL_PATH $HOME/local/bin
set BACKUP_EXISTINGFILE true
################# Configurations End #############

set SWEET_HOME_REPO_DIR (dirname (status --current-filename))
# if the directory is "not/from/the/root" by checking the leading '/' char,
# apppend the prefix by pwd: "/from/root/xxxxxx"
if not string match -r '^/' $SWEET_HOME_REPO_DIR > /dev/null; set SWEET_HOME_REPO_DIR (pwd)/$SWEET_HOME_REPO_DIR; end

function _log_info
    echo "--info:"(date '+%Y%m%d-%H%M%S')":$argv"
end

function _backup_if_exist --argument target_path
  # $1: file to backup if exist
  set -l backup_path $target_path.backup.(date '+%Y-%m-%d-%H%M%S')

  if test -e "$target_path"
    _log_info "$target_path already exists, moving to $backup_path"
    mv $target_path $backup_path
  end
end

function _backup_and_copy --argument srcfile destfile
  # $1: src file
  # $2: dest

  _backup_if_exist $destfile
  cp -r $srcfile $destfile
end

function _get_git_file --argument acct repo fpath output_path
  # Echoes "0" if successful, "1" otherwise.
  #
  # $1: git account
  # $2: git repo
  # $3: file path
  # $4: output path

  _backup_if_exist $output_path
  curl -L https://github.com/$acct/$repo/raw/master/$fpath \
    -o $output_path
end

function check_git
  _log_info "Not implemented yet."
end

function fzf_install
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  # --all will enable all options and will not prompt questions.
  ~/.fzf/install --all
end

function get_diff_so_fancy
  set -l target_path $USER_BIN_INSTALL_PATH/diff-so-fancy
  curl -L \
    https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
    > $target_path && chmod 0755 $target_path
end

function get_dircolors
  _get_git_file \
    seebi \
    dircolors-solarized \
    dircolors.ansi-dark \
    $HOME/.dircolors
end

function get_ack
  curl -L https://beyondgrep.com/ack-2.24-single-file > $USER_BIN_INSTALL_PATH/ack && chmod 0755 $USER_BIN_INSTALL_PATH/ack
end

function get_bazel
  _log_info "Not implemented yet."
end

# fd_find is for FZF.
function get_fdfind
  sudo apt-get install fd-find
end

function get_locales_data
  sudo apt-get install locales-all
end

function get_curl
  sudo apt-get install curl
end

function config_git
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
end

function install_nvim
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update
  sudo apt-get install neovim
end

function setup_nvim
  _backup_and_copy $SWEET_HOME_REPO_DIR/nvim_config $HOME/.config/nvim
  _backup_if_exist $HOME/.local/share/nvim
  #echo "********************************************"
  #echo "Please install yapf, pyright, and stylua:
  #echo ">pip install yapf
  #echo ">pip install pyright
  #echo ">cargo install stylua
end

function install_bazelisk
  # TODO: add machine type and other os support here.
  set BAZELISK_BIN $USER_BIN_INSTALL_PATH/bazel
  curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 -o $BAZELISK_BIN
  chmod 0755 $BAZELISK_BIN
end

function install_fundamental_package
  apt install software-properties-common
end


function build_home
  mkdir -p $USER_BIN_INSTALL_PATH
  install_fundamental_package
  get_curl
  get_locales_data
  get_fdfind
  fzf_install
  get_diff_so_fancy
  get_dircolors
  get_ack
  config_git

  install_nvim
  setup_nvim
  install_bazelisk

  _backup_and_copy $SWEET_HOME_REPO_DIR/_tmux.conf ~/.tmux.conf
  _backup_and_copy $SWEET_HOME_REPO_DIR/_vimrc ~/.vimrc
  _backup_and_copy $SWEET_HOME_REPO_DIR/fish_config ~/.config/fish
end
