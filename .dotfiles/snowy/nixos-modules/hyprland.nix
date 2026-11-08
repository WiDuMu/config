{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # inputs.hyprland.nixosModules.default
  ];

  #   programs.kitty.enable = true;

  programs.hyprland = {
    enable = true;
  }; # enable Hyprland

  home-manager.sharedModules = [
    {
      programs.kitty.enable = true;
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        #         systemdIntegration = true;
        extraConfig = builtins.readFile ./hyprland.lua;
        plugins = [
          # pkgs.waybar
        ];
      };

      # programs.waybar = {
      #   enable = true;
      #   settings = {
      #     mainBar = {
      #       layer = "top";
      #       position = "top";
      #       height = 30;
      #     };
      #   };
      # };
    }
  ];
  # programs.eww.enable = true;

  environment.systemPackages = with pkgs; [
    # ... other packages
    kitty # required for the default Hyprland config
    hyprpicker
    hyprlauncher
    hyprcursor
    hyprpaper
    noctalia
  ];
}
