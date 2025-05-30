{pkgs, ...}: {
  # Desktop-specific configurations

  imports = [
    ./default.nix
  ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
    ghostty
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.monaspace
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.space-mono
    noto-fonts
    roboto-flex
    ubuntu-sans
    eb-garamond
    quicksand
  ];

  programs.firefox.enable = true;

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
}
