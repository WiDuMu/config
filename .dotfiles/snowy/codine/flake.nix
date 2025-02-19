{
  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extensions = inputs.nix-vscode-extensions.extensions.${system};
        #         open-vsx-release = extensions.open-vsx-release;
        inherit (pkgs) vscode-with-extensions vscodium;

        packages.default = vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions =
            (with extensions.vscode-marketplace; [
              alexdauenhauer.catppuccin-noctis
              alvarosannas.nix
              batisteo.vscode-django
              bbenoist.nix
              bierner.lit-html
              bierner.markdown-preview-github-styles
              biomejs.biome
              birdlinux.catppuccin-dark-theme
              bradlc.vscode-tailwindcss
#              castrogusttavo.symbols
              catppuccin.catppuccin-vsc
              cbasdev.dracula-purple
              golang.go
              kamadorueda.alejandra
              ms-azuretools.vscode-docker
              ms-python.debugpy
              ms-python.python
              ms-python.vscode-pylance
              ms-vscode-remote.remote-containers
              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit
              ms-vscode.cmake-tools
              ms-vscode.hexeditor
              ms-vscode.vscode-typescript-next
              ms-vsliveshare.vsliveshare
              myax.short-js-doc
#              myriad-dreamin.tinymist
#              nvarner.typst-lsp
              redhat.java
              yandeu.five-server
              rust-lang.rust-analyzer
              ziglang.vscode-zig
            ])
            ++ (with extensions.open-vsx-release; [
              ]);
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [packages.default pkgs.bashInteractive];
        };
      in {
        inherit packages devShells;
      }
    );
}
