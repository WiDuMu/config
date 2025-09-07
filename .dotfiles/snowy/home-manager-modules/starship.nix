{pkgs, ...}: {
  # Starship prompt
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
