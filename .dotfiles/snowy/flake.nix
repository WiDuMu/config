{
  description = "A Nix-flake-based set of devShells, home-manager configurations and nixos configs.";

  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/6b07c9fdf88e9c1e75e164e9ef387e29e0c2a613";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nvf = {
      url = "github:notashelf/nvf";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    home-manager,
    nixgl,
    nixpkgs,
    nix-vscode-extensions,
    ...
  }: (inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
    imports = [
      inputs.disko.flakeModules.default
      inputs.home-manager.flakeModules.home-manager
    ];

    systems = ["x86_64-linux" "aarch64-linux"];

    perSystem = {
      pkgs,
      system,
      ...
    }: {
      # Configure the pkgs instance.
      _module.args.pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          nix-vscode-extensions.overlays.default
          inputs.nix-minecraft.overlay
        ];
      };

      devShells = (import ./dev-shells) pkgs;

      formatter = pkgs.alejandra;

      legacyPackages.homeConfigurations."aurora" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs nixgl;

        };

        modules = [
        	./aurora.nix
        ];
      };


      legacyPackages.homeConfigurations."aurora@zara" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs nixgl;
        };

        modules = [
          {
          	home.packages = [ pkgs.ollama ];
          }
          ./aurora.nix
        ];
      };
    };

    flake.nixosConfigurations = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          nix-vscode-extensions.overlays.default
          inputs.nix-minecraft.overlay
        ];
      };
      mkSystem = name: (inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit pkgs;
        specialArgs = {inherit inputs;};
        modules = [./systems/${name}];
      });
    in {
      anna = mkSystem "anna";
      default = mkSystem "default";
      esme = mkSystem "esme";
      iris = mkSystem "iris";
      nori = mkSystem "nori";
      ruby = mkSystem "ruby";
    };

    flake.diskoConfigurations = {
      btrfs = import (./disko/luks-btrfs-subvolumes.nix);
    };
  }));
}
