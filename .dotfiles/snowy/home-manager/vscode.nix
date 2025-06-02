{pkgs, ...}: {
  programs.vscode = {
    package = pkgs.vscodium;
    enable = true;
    profiles.default = {
      extensions = import ../codine/extension.nix pkgs;
    };
  };
}
