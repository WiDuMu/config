# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Alias a command if it does not exist
conditional_alias() {
    if ! command -v "$1" &> /dev/null
    then
        alias "$1"="$2"
    fi
}

# Alias a command if another exists. Used for nix integration
alias_if_command() {
	if command -v "$1" &> /dev/null
	    then
	        alias "$2"="$3"
	    fi
}

export EDITOR=/usr/bin/nano
# User's own aliases
alias a="distrobox-enter arch"
conditional_alias "fucking" "sudo"
conditional_alias "micro" "flatpak run io.github.zyedidia.micro --"
conditional_alias "paru" "a -- paru"
alias m="micro"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cfg='config'
alias develop=":"
alias dev="develop"
alias_if_command "nix" "develop" "nix develop ~/.dotfiles/snowy/"
alias d="develop"
alias codev="develop -c code"


