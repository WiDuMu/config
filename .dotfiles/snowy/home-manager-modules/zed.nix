module-inputs @ {
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    package =
      if (module-inputs ? osConfig)
      then pkgs.zed-editor
      else config.lib.nixGL.wrap pkgs.zed-editor;
    extensions = ["biome" "catppuccin-icons" "kdl" "github-theme" "symbols" "nix" "toml" "rust"];
    userSettings = lib.importJSON ./zed-settings.json;
    userKeymaps = lib.importJSON ./zed-keymaps.json;
    extraPackages = with pkgs; [
      alejandra
      biome
      nixd
      rust-analyzer
    ];
  };
}
