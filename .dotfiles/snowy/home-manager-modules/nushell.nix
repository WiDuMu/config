{
  programs.nushell = {
    enable = false;
    settings = {
      show_banner = false;
      completions.external = {
        enable = true;
        max_results = 200;
      };
    };
    shellAliases = {
    };
  };
}
