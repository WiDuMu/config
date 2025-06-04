{
  programs.micro = {
    enable = true;
    settings = {
      softwrap = true;
    };
  };
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
  home.shellAliases = {
    m = "micro";
  };
  catppuccin.micro.transparent = true;
}
