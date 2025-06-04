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