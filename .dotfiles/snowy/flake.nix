{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nuka.url = "path:./nuka/";
  };

  outputs = { self, nixpkgs, nuka, ... }: let
    supportedSystems = [
      "x86_64-linux"
      # "aarch64-linux"
    ];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [ ocaml ocamlformat cargo clang gdb bun zoxide eza bat ]
          ++ (with pkgs.ocamlPackages; [ dune_3 odoc utop ocaml-lsp ])
          ++ (with pkgs.vimPlugins; [  ])
          ++ ( [ nuka.packages.x86_64-linux.default ] );
        shellHook = ''
          unalias micro &> /dev/null
          export FLAKE=true
          # export EDITOR=micro
          '';
      };
    });
  };
}
