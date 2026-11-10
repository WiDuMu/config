{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos-modules/default.nix
    ../../nixos-modules/minecraft.nix
  ];

  networking.hostName = "nori"; # Define your hostname.

  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraSetFlags = ["--advertise-exit-node"];
  };

  # Enable networking
  networking = {
    useDHCP = false;
    defaultGateway = "128.101.131.1";
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "128.101.131.202";
        prefixLength = 24;
      }
    ];
  };
}
