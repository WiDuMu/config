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
    nix-vscode-extensions = {
      #TODO: remove this pin when the nix-vscode repo fixes their latex extension.
      url = "github:nix-community/nix-vscode-extensions/5809c8500215e5a46ca2e3469daff8f2c0a80665";
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
  } @ inputs: let
    # Function that creates outputs for each system
    eachSystem = flake-utils.lib.eachSystem;
    eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
    input-packages = {inherit nuka codine;};
    opkgs = system:
      import nixpkgs {
        system = system;
        allowUnfree = true;
        overlays = [
          inputs.nix-vscode-extensions.overlays.default
        ];
      };
    defaultHomeManager = system: [
      {
        home-manager.users.aurora = import ./home.nix;
      }
    ];
    defaultNixOS = system: ([
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit input-packages system;
          };
        }
      ]
      ++ defaultHomeManager system);
  in
    eachDefaultSystem (system: let
      pkgs = opkgs system;
      # Make a dev shell given a list of packages
      shell = shell-packages:
        pkgs.mkShell {
          buildInputs = with pkgs; [bashInteractive];
          packages = shell-packages;
        };
      mkShells = builtins.mapAttrs (name: packages: (shell packages));
      shellPackages = (import ./shellpkgs.nix) {pkgs = nixpkgs.legacyPackages.${system};};
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = mkShells shellPackages;
      # Home-manager configuration
      packages.homeConfigurations."aurora" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit input-packages system;
        };

        modules = [
          ./home.nix
        ];
      };
    })
    // (let
      system = "x86_64-linux";
      pkgs = opkgs system;
    in {
      # spare thinkpad
      nixosConfigurations.ruby = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules =
          [
            ./systems/ruby.nix
          ]
          ++ (defaultNixOS system);
      };
    });
}
