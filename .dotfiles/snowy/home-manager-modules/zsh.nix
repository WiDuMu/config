{config, ...}: {
  programs.zsh = {
    enable = false;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
  };
}
