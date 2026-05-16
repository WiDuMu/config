{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./ruby-hardware-configuration.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/home-manager.nix
  ];

  boot.initrd.luks.devices."luks-428b0b52-a19f-4fe6-9504-a450cad5e581".device = "/dev/disk/by-uuid/428b0b52-a19f-4fe6-9504-a450cad5e581";
  networking.hostName = "ruby";

}
