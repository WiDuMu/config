{
  description = "A Nix-flake-based development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [ ocaml ocamlformat cargo clang lldb gdb neovim bun ] ++
            (with pkgs.ocamlPackages; [ dune_3 odoc utop ocaml-lsp ]);
        };
      });
    };
}
