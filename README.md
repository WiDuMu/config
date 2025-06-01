# Config
This is a set of dotfiles and nix configurations created for my personal use.

## Architecture
This set of dotfiles is strange by both dotfiles and nix's standards. This is due to the multitude of functions used in this repository. These indclude:
* A set of non-nix dotfiles.
* A standalone nix home-manager configuration
* A NixOS configuration for desktops
* A NixOS configuration for servers

## Usage
### Initialization
Clone this repo as a ***bare repository*** to your home directory.
```bash
git clone --bare git@github.com:WiDuMu/config.git ~/.cfg
```
Then checkout the head:
```bash
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
```
This should install all the dotfiles nessecary to use the configuration. After initial install, restart any `bash` shells and you should be able to use the alias `cfg` for git when working with config. This includes `cfg add`, `cfg commit`, etc, etc.

### Home-manager intialization
Install nix however do, with flakes enabled. Then run:
```
nix run home-manager switch
```
This repo should have the requisite symlinks to allow it to build with just that command

### NixOS
Set hostname to the desired hostname in the build setup. Link the `snowy` directory containing `flake.nix` to `/etc/nixos/`. Then run:
```bash
sudo nixos-rebuild switch
```

### Silverblue
To apply Nix to a silverblue based distro post-f42, follow the following guide: (https://gist.github.com/queeup/1666bc0a5558464817494037d612f094)
