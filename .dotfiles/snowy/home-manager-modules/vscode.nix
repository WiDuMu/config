{pkgs, ...}: {
  programs.vscodium = {
    enable = true;
    profiles.default = {
      extensions = import ../shared/extension.nix pkgs;
    };
  };
  home.shellAliases = {
    # snowyedit = "code $SNOWY";
  };
}
