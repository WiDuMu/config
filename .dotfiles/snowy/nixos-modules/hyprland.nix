{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
  }; # enable Hyprland

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemdIntegration = true;
        plugins = [
          pkgs.waybar
        ];
      };
    }
  ];
  # programs.waybar = {
  #   enable = true;
  # };
  # programs.eww.enable = true;

  environment.systemPackages = with pkgs; [
    # ... other packages
    kitty # required for the default Hyprland config
    hyprpicker
    hyprcursor
    hyprpaper
    eww
  ];
}
