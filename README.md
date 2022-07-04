# dots

## disclaimer
Do not install unless you're 100% sure what everything does. You have been warned. :)

# Installation
```sh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare <git-repo-url> $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no
```
