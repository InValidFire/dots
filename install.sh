# WIP:
# - set up way to run this from github via curl piping into bash
# - automatically install and set KDE dracula theme

# install dots via git
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare git@github.com:InValidFire/dots.git $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no

# update system
apt-get -qq update
apt-get upgrade -qq --yes --force-yes

# install required stuff
apt-get -qq --yes --force-yes install alacritty  # terminal
apt-get -qq --yes --force-yes install xonsh  # shell
apt-get -qq --yes --force-yes install tmux  # terminal multiplexer

# wsl stuff
if [ -z "${WSL_DISTRO_NAME}" ]; then
	IS_WSL = false
else
snap install bitwarden  # bitwarden :)
snap connect bitwarden:password-manager-service

# set shell to xonsh
chsh -s /usr/bin/xonsh $USER

# install vim-plug
apt-get -qq update && apt-get -qq --yes --force-yes install curl
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# run DE dependent setup script
if [[ $DESKTOP_SESSION == "plasma" ]]; then
		source ~/sh/plasma_setup.sh
fi
