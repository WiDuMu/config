{ config, pkgs, ... }:

{
  imports =
    [
      ../../nixos-modules/default.nix
      ../../nixos-modules/jellyfin.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "iris"; # Define your hostname.

 services.tailscale.extraSetFlags = ["--advertise-exit-node"];

  # # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.aurora = {
  #   isNormalUser = true;
  #   description = "aurora";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   openssh.authorizedKeys.keys = [
  #   	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9l0Em3K1Zcs0f1c0pw3ZovL4Vg0GhOUgfWLZPsNx/W aurora"
  #   ];
  #   packages = with pkgs; [];
  # };

}
