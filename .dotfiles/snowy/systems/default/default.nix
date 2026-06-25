{pkgs, inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    ../../nixos-modules/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "default";
}
