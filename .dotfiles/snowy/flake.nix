{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    codine = {
      url = "path:./codine";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nuka.url = "path:./nuka/";
  };

  outputs = {
    self,
    codine,
    nixpkgs,
    nuka,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: let
      shell = shell-packages:
        pkgs.mkShell {
          buildInputs = with pkgs; [bashInteractive];
          packages = shell-packages;
        };
      default-packages = with pkgs; [bat eza fd rust-parallel zoxide];
      ocaml-packages = with pkgs; [ocaml ocamlformat] ++ (with pkgs.ocamlPackages; [dune_3 odoc utop ocaml-lsp]);
      rust-packages = with pkgs; [cargo];
      js-packages = with pkgs; [bun biome];
      nix-packages = with pkgs; [alejandra];
      c-packages = with pkgs; [gdb];
      vs-packages = with pkgs; [codine.packages.x86_64-linux.default];
    in {
      basic = shell default-packages;
      default = shell (default-packages ++ c-packages ++ js-packages ++ rust-packages ++ [nuka.packages.${system}.default]);
      full = shell (default-packages ++ c-packages ++ js-packages ++ nix-packages ++ rust-packages ++ ocaml-packages ++ [nuka.packages.x86_64-linux.default]);
      vscodium = shell (default-packages ++ vs-packages ++ js-packages ++ nix-packages ++ rust-packages);
      vscodium-ocaml = shell (default-packages ++ vs-packages ++ js-packages ++ nix-packages ++ ocaml-packages ++ rust-packages);
    });
  };
}
