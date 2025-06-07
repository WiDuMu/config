{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    # TODO Switch this for flake-parts
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/001f9f541edd406ff00aab49d968f535658778fa";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.catppuccin.homeModules.catppuccin
    ];
    defaultNixOS = system: [
      home-manager.nixosModules.home-manager
      inputs.catppuccin.nixosModules.catppuccin
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
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = (import ./dev-shells) pkgs;
      # Standalone home-manager configuration
      packages.homeConfigurations."aurora" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs input-packages system;
        };

        modules =
          [
            ./shared/nix.nix
          ]
          ++ (defaultHomeManager system);
      };
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
