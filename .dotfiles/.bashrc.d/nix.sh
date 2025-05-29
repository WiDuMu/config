export SNOWY_FLAKE="$HOME/.dotfiles/snowy"
develop() {
    VERSION=$1
	shift 1
    nix develop "$SNOWY_FLAKE#$VERSION" "$@"
    unset VERSION
}
snowy-update() {
    nix flake update --flake "$SNOWY_FLAKE"
}
alias_if_command "develop" "d" "develop"
alias_if_command "develop" "dev" "develop"
alias_if_command "develop" "codev" "develop vscodium -c codium"
