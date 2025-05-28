if [ -d ~/.dotfiles/ ]; then
    alias config='GIT_SSH_COMMAND="$HOME/.dotfiles/gitconfig/WiDuMu-access-key" git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    alias cfg='config'
fi
