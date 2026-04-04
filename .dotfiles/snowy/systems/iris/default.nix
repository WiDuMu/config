# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

 services.tailscale.extraSetFlags = ["--advertise-exit-node"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aurora = {
    isNormalUser = true;
    description = "aurora";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
    	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9l0Em3K1Zcs0f1c0pw3ZovL4Vg0GhOUgfWLZPsNx/W aurora"
    ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    micro
  ];

}
