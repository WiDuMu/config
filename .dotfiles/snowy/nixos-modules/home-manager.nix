# NixOS specific home-manager configurations
{
  pkgs,
  inputs,
  ...
}: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hmbak";
  home-manager.extraSpecialArgs = {
    inherit inputs pkgs;
    system = pkgs.system;
  };
  home-manager.users.aurora = {imports = [../aurora.nix];};
}
