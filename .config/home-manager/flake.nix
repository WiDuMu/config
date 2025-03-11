{
  description = "Home Manager configuration of aurora";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nuka = {
      url = "github:widumu/config/?dir=.dotfiles/snowy/nuka";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codine = {
      url = "github:widumu/config/?dir=.dotfiles/snowy/codine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    codine,
    nuka,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."aurora" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        {
          home.packages = [
            nuka.packages.${system}.default
            codine.packages.${system}.default
          ];
        }
      ];
      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
