set -gx PATH "$HOME/local/bin" $PATH
set -gx XDG_DATA_HOME $HOME/.local/share

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8

# For FZF to respect .gitignore, use fd instead of find.
set -gx FZF_DEFAULT_COMMAND "fdfind --type f"


fish_vi_key_bindings

