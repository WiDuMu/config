{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/e54263b2980ec0f39f3148775045bd8f6e1fc567";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = inputs @ {
    self,
    flake-utils,
    home-manager,
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
          nix-vscode-extensions.overlays.default
        ];
      };
    defaultHomeManager = system: [
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
    ];
    mkNixOS = system: pkgs: modules: (nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = modules ++ (defaultNixOS system);
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
            ./shared/nix.nix
            {
              home.packages = home-packages;
            }
          ]
          ++ (defaultHomeManager system);
      });
      # Used for systems with dedicated GPUs
      mkDesktop = home-packages: (mkHome (home-packages ++ [pkgs.ollama]));
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = (import ./dev-shells) pkgs;
      # Standalone home-manager configuration
      packages.homeConfigurations."aurora" = mkHome [];
      packages.homeConfigurations."aurora@zara" = mkDesktop [];
    })
    # NixOS configurations
    # x86_64-linux systems
    // (let
      system = "x86_64-linux";
      pkgs = opkgs system;
    in {
      nixosConfigurations = {
        ruby = mkNixOS system pkgs ./systems/ruby;
      };
    });
}
