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
    devShells = forEachSupportedSystem ({pkgs}:
    let
      default-packages = with pkgs; [ bat eza fd rust-parallel zoxide ];
      ocaml-packages = with pkgs; [ ocaml ocamlformat ] ++ (with pkgs.ocamlPackages; [ dune_3 udoc utop ocaml-lsp ]);
      rust-packages = with pkgs; [ cargo ];
      js-packages = with pkgs; [ bun biome ];
      c-packages = with pkgs; [ gdb ];
    in {
      default = pkgs.mkShell {
        packages = with pkgs;
          [ ocaml ocamlformat cargo clang gdb bun ]
          ++ (with pkgs.ocamlPackages; [ dune_3 odoc utop ocaml-lsp ])
          ++ (with pkgs.vimPlugins; [  ])
          ++ ( [ nuka.packages.x86_64-linux.default ] );
      };
      basic = pkgs.mkShell {
        packages = with pkgs; [ fd rust-parallel zoxide eza bat ];
      };
    });
  };
}
