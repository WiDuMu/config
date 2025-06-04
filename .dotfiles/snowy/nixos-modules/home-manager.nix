# NixOS specific home-manager configurations
{
  pkgs,
  input-packages,
  system,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hmbak";
  home-manager.extraSpecialArgs = {
    inherit input-packages system;
  };
}
