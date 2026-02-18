{pkgs, ...}:
# A set function that returns the extensions wanted by VSCode. Nix-VSCode-Extensions overlay required
(
  (with pkgs.vscode-marketplace; [
    attilabuti.brainfuck-syntax
    barbosshack.crates-io
    batisteo.vscode-django
    bbenoist.nix
    bierner.lit-html
    bierner.markdown-preview-github-styles
    biomejs.biome
    blueglassblock.better-json5
    bradlc.vscode-tailwindcss
    chamboug.js-auto-backticks
    chrmarti.regex
    formulahendry.auto-rename-tag
    fwcd.kotlin
    golang.go
    kamadorueda.alejandra
    levrotech.zig-znippets
    llvm-vs-code-extensions.vscode-clangd
    mhutchie.git-graph
    miguelsolorio.symbols
    ms-azuretools.vscode-docker
    ms-python.debugpy
    ms-python.python
    ms-toolsai.jupyter
    astral-sh.ty
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
    t3m1n4l.amoled-github
    tamasfe.even-better-toml
    vlanguage.vscode-vlang
    tomoki1207.pdf
    vue.volar
    yandeu.five-server
    ziglang.vscode-zig
  ])
  ++ (with pkgs.open-vsx; [
    amerey.markdown-emoji
    amerey.markdown-math-snippets
  ])
  ++ [
    pkgs.vscode-extensions.vadimcn.vscode-lldb
  ]
)
