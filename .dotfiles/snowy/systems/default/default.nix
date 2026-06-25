{pkgs, inputs, ...}: {
  imports = [
    disko.nixosModules.disko
    ../../nixos-modules/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "default";
}
