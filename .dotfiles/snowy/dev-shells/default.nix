# Lists of packages for dev shells
{pkgs, ...}: let
  # Make a dev shell given a list of packages
  mkShell = shell-packages:
    pkgs.mkShell {
      buildInputs = with pkgs; [bashInteractive];
      packages = shell-packages;
    };
  # Make a set of dev shells given an attribute set of package lists.
  mkShells = builtins.mapAttrs (name: packages: (mkShell packages));
  # Make a set of dev shells given an attribute set of package lists, adding a package to each, suffixing the shells
  mkShellsPlusPackage = suffix: package:
    pkgs.lib.attrsets.mapAttrs' (name: packages: {
      name = "${name}${suffix}";
      value = mkShell (packages ++ [package]);
    });
  # VSCodium packages
  codium = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = import ../shared/extension.nix pkgs;
  };
  shellPackages = (import ./shellpkgs.nix) pkgs;
in
  (mkShells shellPackages)
  // (mkShellsPlusPackage "-code" codium shellPackages)
