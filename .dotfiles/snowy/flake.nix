{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    codine = {
      url = "path:./codine";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
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
    flake-utils,
    nixpkgs,
    nuka,
    ...
  }: let
    eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
  in
    eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      shell = shell-packages:
        pkgs.mkShell {
          buildInputs = with pkgs; [bashInteractive];
          packages = shell-packages;
        };
      default-packages = with pkgs; [bat eza fd micro zoxide];
      full-packages = with pkgs; [tokei];
      ocaml-packages = with pkgs; [ocaml ocamlformat] ++ (with pkgs.ocamlPackages; [dune_3 odoc utop ocaml-lsp]);
      rust-packages = with pkgs; [cargo];
      js-packages = with pkgs; [bun biome];
      nix-packages = with pkgs; [alejandra];
      nvim-packages = [nuka.packages.${system}.default];
      c-packages = with pkgs; [gdb rr];
      vs-packages = with pkgs; [codine.packages.${system}.default];
      vlang-packages = with pkgs; [vlang];
      zig-packages = with pkgs; [zig zls];
      # Package-sets
      basic = default-packages;
      default = default-packages ++ c-packages ++ js-packages ++ nix-packages ++ rust-packages ++ [nuka.packages.${system}.default];
      full = default ++ full-packages ++ ocaml-packages ++ vlang-packages ++ zig-packages;
    in {
      devShells = {
        basic = shell basic;
        default = shell default;
        full = shell full;
        vscodium = shell (default ++ vs-packages);
        vscodium-full = shell (full ++ vs-packages);
        nvim = shell (default ++ nvim-packages);
        nvim-full = shell (full ++ nvim-packages);
      };
    });
}
