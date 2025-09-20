{pkgs, ...}: {
  programs.vscode = {
    package = pkgs.vscode;
    # package = pkgs.vscodium;
    enable = true;
    profiles.default = {
      extensions = import ../shared/extension.nix pkgs;
    };
  };
  home.shellAliases = {
    snowyedit = "code $SNOWY";
  };
}
