{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      imports = [
        # Optional: use external flake logic, e.g.
        # inputs.foo.flakeModules.default
      ];
      flake = {
        # Put your original flake attributes here.
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        packages.default = pkgs.hello;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [hello];
        };
      };
    });
}
