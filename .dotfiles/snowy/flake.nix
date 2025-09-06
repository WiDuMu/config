{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO Switch this for flake-parts
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
      disko.nixosModules.disko
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
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = (import ./dev-shells) pkgs;
      packages.nuka = inputs.nvf.lib.neovimConfiguration (import ./shared/nvf.nix);
      # Standalone home-manager configuration
      packages.homeConfigurations."aurora" = mkHome [];
      packages.homeConfigurations."aurora@zara" = mkHome [pkgs.oterm pkgs.ollama];
    })
    # NixOS configurations
    // (let
      system = "x86_64-linux";
      pkgs = opkgs system;
    in {
      # spare thinkpad
      nixosConfigurations.ruby = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules =
          [
            ./systems/ruby
          ]
          ++ (defaultNixOS system);
      };
    });
}
