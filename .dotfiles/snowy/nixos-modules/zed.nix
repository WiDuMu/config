{
  lib,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    import ../home-manager-modules/zed.nix
  ];
}
