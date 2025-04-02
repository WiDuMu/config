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
              attilabuti.brainfuck-syntax
              batisteo.vscode-django
              bbenoist.nix
              bierner.lit-html
              bierner.markdown-preview-github-styles
              binx.modus-vivendi-code
              biomejs.biome
              blueglassblock.better-json5
              bradlc.vscode-tailwindcss
              catppuccin.catppuccin-vsc-icons
              catppuccin.catppuccin-vsc
              chamboug.js-auto-backticks
              chrmarti.regex
              donjayamanne.githistory
              formulahendry.auto-rename-tag
              github.vscode-pull-request-github
              golang.go
              kamadorueda.alejandra
              levrotech.zig-znippets
              llvm-vs-code-extensions.vscode-clangd
              mhutchie.git-graph
              miguelsolorio.symbols
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
              myriad-dreamin.tinymist
              redhat.java
              rust-lang.rust-analyzer
	      slint.slint
              svelte.svelte-vscode
              vadimcn.vscode-lldb
              vlanguage.vscode-vlang
              tomoki1207.pdf
              vue.volar
              yandeu.five-server
              ziglang.vscode-zig
            ])
            ++ (with extensions.open-vsx; [
              amerey.markdown-emoji
              amerey.markdown-math-snippets
              gitlab.gitlab-workflow
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
