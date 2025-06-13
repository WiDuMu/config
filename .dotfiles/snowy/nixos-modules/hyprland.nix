{pkgs, ...}: {
  programs.hyprland.enable = true; # enable Hyprland
  programs.waybar = {
    enable = true;
  };
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
