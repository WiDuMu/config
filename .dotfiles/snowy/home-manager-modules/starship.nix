{pkgs, ...}: {
  # Starship prompt
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
    enableZshIntegration = false;
    enableNushellIntegration = false;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
