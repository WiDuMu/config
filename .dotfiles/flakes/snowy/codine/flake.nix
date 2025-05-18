{
  inputs = {
    nix-vscode-extensions = {
      #TODO: remove this pin when the nix-vscode repo fixes their latex extension.
      url = "github:nix-community/nix-vscode-extensions/5809c8500215e5a46ca2e3469daff8f2c0a80665";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        # pkgs = inputs.nixpkgs.legacyPackages.${system};
        pkgs = import inputs.nixpkgs {
          system = system;
          config.allowUnfree = true;
          # Hacky workaround for a bug in upstream nix-vscode-extensions issue #99
          overlays = [inputs.nix-vscode-extensions.overlays.default];
        };
        # Workaround pt.2
        extensions = pkgs;
        # inherit (pkgs) vscode-with-extensions vscodium;

        packages.default = pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscodium;
          vscodeExtensions = import extension.nix pkgs;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [packages.default pkgs.bashInteractive];
        };
      in {
        inherit packages devShells;
      }
    );
}
