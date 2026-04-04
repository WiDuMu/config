{pkgs, ...}: {
  # Default nixOS configuration for both desktop and headless devices

  imports = [
    ./users.nix
    ../shared/nix.nix
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
  };

  services.fail2ban.enable = true;

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Disable the X11 windowing system.
  services.xserver.enable = false;

  services.pulseaudio.enable = false;

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

  # ld fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libGL
    glfw
    libjpeg
    libpng
    libvpx
    libwebp
    openssl
    zlib
  ];

  environment.systemPackages = with pkgs; [
    bottom
    evil-helix
    fastfetch
    htop
    micro
    wget
    git
    podman-tui
    podman-compose
  ];

  environment.shellAliases = {
    cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    nrs = "sudo nixos-rebuild switch";
    rs = "sudo nixos-rebuild switch";
  };

  environment.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
    SNOWY = "/etc/nixos/";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  # Auto update
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "../";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "02:00";
    randomizedDelaySec = "60min";
  };

  nix.optimise = {
    automatic = true;
    dates = ["00:30"];
  };
}
