{
  description = "A Nix-flake-based development environment intended for deployment on a silverblue-based envrionment.";

  inputs = {
    codine = {
      url = "path:./codine";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        nix-vscode-extensions.follows = "nix-vscode-extensions";
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
      url = "github:nix-community/nix-vscode-extensions/001f9f541edd406ff00aab49d968f535658778fa";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
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
    eachSystem = flake-utils.lib.eachSystem;
    eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
    input-packages = {inherit nuka;};
    opkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
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
          home-manager.backupFileExtension = "hmbak";
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
      mkShellsPlusPackage = suffix: package:
        nixpkgs.lib.attrsets.mapAttrs' (name: packages: {
          name = "${name}${suffix}";
          value = shell (packages ++ [package]);
        });
      shellPackages = (import ./shellpkgs.nix) {pkgs = nixpkgs.legacyPackages.${system};};
    in {
      # Formatter for a system
      formatter = pkgs.alejandra;
      # Dev shell (`nix develop`)
      devShells = (mkShells shellPackages) // (mkShellsPlusPackage "-vim" inputs.nuka.packages.${system}.default shellPackages) // (mkShellsPlusPackage "-vscode" inputs.codine.packages.${system}.default shellPackages);
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
            ./systems/ruby
          ]
          ++ (defaultNixOS system);
      };
    });
}
