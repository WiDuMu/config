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
    nuka = {
      url = "path:./nuka/";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
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
      vlang-packages = with pkgs; [vlang];
      # Package-sets
      basic = default-packages;
      default = default-packages ++ c-packages ++ js-packages ++ rust-packages ++ vlang-packages ++ [nuka.packages.x86_64-linux.default];
      full = default ++ ocaml-packages;
    in {
      basic = shell default-packages;
      default = shell default;
      full = shell full;
      vscodium = shell default ++ vs-packages;
      vscodium-ocaml = shell full ++ vs-packages;
    });
  };
}
