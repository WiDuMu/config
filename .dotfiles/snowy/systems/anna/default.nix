{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/home-manager.nix
  ];

  networking.hostName = "anna";
}
