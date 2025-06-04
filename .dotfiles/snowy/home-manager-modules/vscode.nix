{pkgs, ...}: {
  programs.vscode = {
    package = pkgs.vscodium;
    enable = true;
    profiles.default = {
      extensions = import ../shared/extension.nix pkgs;
    };
  };
}
