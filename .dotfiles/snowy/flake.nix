{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
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
    flake-utils,
    home-manager,
    nixgl,
    nixpkgs,
    nix-vscode-extensions,
    ...
  }: let
    eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
    input-packages = [];
    opkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          nix-vscode-extensions.overlays.default
          inputs.nix-minecraft.overlay
        ];
      };
    defaultHomeManager = system: [
      inputs.nvf.homeManagerModules.default
      ./home.nix
    ];
    defaultNixOS = system: [
      home-manager.nixosModules.home-manager
      {
        nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmbak";
        home-manager.extraSpecialArgs = {
          inherit inputs input-packages system;
        };
        home-manager.users.aurora = {imports = defaultHomeManager system;};
      }
      inputs.sops-nix.nixosModules.sops
    ];
    mkNixOS = system: pkgs: modules: (nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs;
      };
      modules = modules ++ (defaultNixOS system);
    });
    mkNoHMNixOS = system: pkgs: modules: (nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs;
      };
      modules = modules ++ [ inputs.sops-nix.nixosModules.sops ];
    });
  in
    eachDefaultSystem (system: let
      pkgs = opkgs system;
      mkHome = home-packages: (home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs input-packages system;
        };

        modules =
          [
          	inputs.sops-nix.homeManagerModules.sops
            ./shared/nix.nix
            {
              home.packages = home-packages ++ [];
            }
          ]
          ++ (defaultHomeManager system);
      });
      # Used for systems with dedicated GPUs
      mkDesktop = home-packages: (mkHome (home-packages ++ []));
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = (import ./dev-shells) pkgs;
      # Standalone home-manager configuration
      packages.homeConfigurations."aurora" = mkHome [];
      packages.homeConfigurations."aurora@zara" = mkDesktop [pkgs.ollama];
    })
    # NixOS configurations
    # x86_64-linux systems
    // (let
      system = "x86_64-linux";
      pkgs = opkgs system;
    in {
      nixosConfigurations.ruby = mkNixOS system pkgs [./systems/ruby];
      nixosConfigurations.anna = mkNixOS system pkgs [./systems/anna];
      nixosConfigurations.nori = mkNoHMNixOS system pkgs [./systems/nori];
      nixosConfigurations.iris = mkNoHMNixOS system pkgs [./systems/iris];
    });
}
