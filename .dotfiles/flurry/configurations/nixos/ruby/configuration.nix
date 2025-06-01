# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
  ];

  boot.initrd.luks.devices."luks-428b0b52-a19f-4fe6-9504-a450cad5e581".device = "/dev/disk/by-uuid/428b0b52-a19f-4fe6-9504-a450cad5e581";
  networking.hostName = "ruby";

  users.users.aurora = {
    isNormalUser = true;
    description = "aurora";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9l0Em3K1Zcs0f1c0pw3ZovL4Vg0GhOUgfWLZPsNx/W aurora"
    ];
  };

  # Leave this at the install value
  # If changing read `man configuration.nix` or https://nixos.org/nixos/options.html
  system.stateVersion = "24.11";
}
