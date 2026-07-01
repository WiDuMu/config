{
  pkgs,
  inputs,
  ...
}: {
  # Desktop-specific configurations

  imports = [
    ./default.nix
    ./home-manager.nix
  ];

  # Not in home.nix because these are handled or not needed in a standalone hm
  # or server install
  home-manager.sharedModules = [
    {
      programs.mpv.enable = true;

      programs.ghostty = {
        enable = true;
        settings = {
          font-family = "MonaspiceAr Nerd Font";
          theme = "dark:3024 Night,light:3024 Day";
        };
      };

      home.packages = with pkgs; [
        apostrophe
        clang-tools
        cmake
        gapless
        gcc
        krita
        libreoffice
        protonvpn-gui
        python3
        qview
        trayscale
      ];
    }
  ];

  # services.syncthing = {
  #  enable = true;
  #   openDefaultPorts = true; # Open ports in the firewall for Syncthing
  #   dataDir = "/home/aurora";
  #   configDir = "/home/aurora/.config/syncthing";
  # };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    distrobox
    kdePackages.kate
  ];

  programs.partition-manager.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = false;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
}
