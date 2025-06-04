# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./ruby-hardware-configuration.nix
    ../../nixos-modules/desktop.nix
  ];

  boot.initrd.luks.devices."luks-428b0b52-a19f-4fe6-9504-a450cad5e581".device = "/dev/disk/by-uuid/428b0b52-a19f-4fe6-9504-a450cad5e581";
  networking.hostName = "ruby";

  # Leave this at the install value
  system.stateVersion = "24.11";
}
