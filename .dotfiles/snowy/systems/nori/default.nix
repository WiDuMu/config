# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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

  # environment.etc."nextcloud-admin-pass".text = "YourNextCloudIsASheep";
  # services.nextcloud = {
  # 	enable = true;
  # 	hostName = "nori";
  # 	extraApps = {
  # 	    inherit (config.services.nextcloud.package.packages.apps) onlyoffice;
  # 	};
  # 	config.adminpassFile = "/etc/nextcloud-admin-pass";
  # 	config.dbtype = "sqlite";
  # };

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
