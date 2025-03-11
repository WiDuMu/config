{
  inputs = {
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        # pkgs = inputs.nixpkgs.legacyPackages.${system};
        pkgs = import inputs.nixpkgs {
          system = system;
          config.allowUnfree = true;
          # Hacky workaround for a bug in upstream nix-vscode-extensions issue #99
          overlays = [inputs.nix-vscode-extensions.overlays.default];
        };
        # Workaround pt.2
        extensions = pkgs;
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
              binx.modus-vivendi-code
              biomejs.biome
              blueglassblock.better-json5
              bradlc.vscode-tailwindcss
              chamboug.js-auto-backticks
              chrmarti.regex
              donjayamanne.githistory
              formulahendry.auto-rename-tag
              #              castrogusttavo.symbols
              golang.go
              kamadorueda.alejandra
              levrotech.zig-znippets
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
              oderwat.indent-rainbow
              #              myriad-dreamin.tinymist
              #              nvarner.typst-lsp
              redhat.java
              rust-lang.rust-analyzer
              svelte.svelte-vscode
              vlanguage.vscode-vlang
              yandeu.five-server
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
