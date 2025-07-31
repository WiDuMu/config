{
  programs.micro = {
    enable = true;
    settings = {
      softwrap = true;
      colorscheme = "simple";
    };
  };
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
  home.shellAliases = {
    m = "micro";
  };
  # catppuccin.micro.transparent = true;
}
