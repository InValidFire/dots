# dots

## disclaimer
These dotfiles are... unstable, still being put together, still hashing out how I want it to work, whatever you want to call it. Do not install unless you're 100% sure what everything does.

# Installation
That said, here's installation:

```sh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare <git-repo-url> $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no
```
