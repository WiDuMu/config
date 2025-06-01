{pkgs, ...}: {
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs;
    [
      alejandra
      av1an
      bat
      biome
      bun
      clang
      clang-tools
      cmake
      eza
      cargo
      dav1d
      delta
      dua
      fd
      ffmpeg-full
      gdb
      hyperfine
      libjxl
      lldb
      luajit
      marksman
      mediainfo
      meson
      micro
      moar
      nasm
      nh
      nil
      ninja
      nix-tree
      rr
      rustc
      tldr
      tokei
      typst
      valgrind
      vlang
      yt-dlp
      zig
      zls
      zoxide
    ]
    ++ (with pkgs; [
      corefonts
      nerd-fonts.caskaydia-cove
      nerd-fonts.monaspace
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.space-mono
      noto-fonts
      roboto-flex
      ubuntu-sans
      eb-garamond
      quicksand
      vista-fonts
    ]);

  fonts.fontconfig.enable = true;

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        editor.file-picker.hidden = false;
      };
      package = pkgs.evil-helix;
    };
  };
}
