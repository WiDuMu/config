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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    flake-utils,
    home-manager,
    nixpkgs,
    nuka,
    ...
  }: let
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    # Function that creates outputs for each system
    eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
  in
    eachDefaultSystem (system: let
      # Packages for each system
      pkgs = import nixpkgs {
        inherit system;
        allowUnfree = true;
      };
      # Make a dev shell given a list of packages
      shell = shell-packages:
        pkgs.mkShell {
          buildInputs = with pkgs; [bashInteractive];
          packages = shell-packages;
        };
      # Lists of packages for dev shells
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
      # Composite package sets
      basic = default-packages;
      default = default-packages ++ c-packages ++ js-packages ++ nix-packages ++ rust-packages ++ [nuka.packages.${system}.default];
      full = default ++ full-packages ++ ocaml-packages ++ vlang-packages ++ zig-packages;
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = {
        basic = shell basic;
        default = shell default;
        full = shell full;
        vscodium = shell (default ++ vs-packages);
        vscodium-full = shell (full ++ vs-packages);
        nvim = shell (default ++ nvim-packages);
        nvim-full = shell (full ++ nvim-packages);
      };
      # Home-manager configuration
      packages.homeConfigurations."aurora" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          {
            home.packages = nvim-packages ++ vs-packages;
          }
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    });
}
