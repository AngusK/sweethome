#!/bin/fish

################# Configurations #################
# Installation path
set -l USER_BIN_INSTALL_PATH $HOME/local/bin
set -l BACKUP_EXISTINGFILE true
################# Configurations End #############


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

function setup_nvim
  _backup_and_copy $PWD/nvim_config $HOME/.config/nvim
  _backup_if_exist $HOME/.local/share/nvim
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  # Execute commands to install plugins.
  nvim /tmp/dummyfile "+:PlugInstall" "+:UpdateRemotePlugins" "+:q!" "+:q!"  
  echo "********************************************"
  echo "* Please install yapf through pip or conda *"
  echo "********************************************"
end

function build_home
  mkdir -p $USER_BIN_INSTALL_PATH
  get_curl
  get_locales_data
  get_fdfind
  fzf_install
  get_diff_so_fancy
  get_dircolors
  get_ack
  config_git

  setup_nvim
  _backup_and_copy $PWD/_tmux.conf ~/.tmux.conf
  _backup_and_copy $PWD/_vimrc ~/.vimrc
  _backup_and_copy $PWD/_mybashrc ~/.bashrc
end