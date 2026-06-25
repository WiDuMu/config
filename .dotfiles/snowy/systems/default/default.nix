{pkgs, ...}: {
  imports = [
    ../../nixos-modules/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "default";
}
