{...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
  };
}
