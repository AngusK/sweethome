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
