{
  lib,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.zed-editor = {
        enable = true;
        extensions = ["catppuccin-icons" "kdl" "github-theme" "symbols" "nix" "toml" "rust"];
        userSettings = lib.importJSON ./zed-settings.json;
        userKeymaps = lib.importJSON ./zed-keymaps.json;
        extraPackages = with pkgs; [
          alejandra
          nixd
          rust-analyzer
        ];
      };
    }
  ];
}
