{
  config,
  pkgs,
  system,
  input-packages,
  ...
}: {
  home.username = "aurora";
  home.homeDirectory = "/home/aurora";

  imports = [
    ./home-manager/starship.nix
    ./home-manager/fish.nix
    ./home-manager/nushell.nix
  ];

  # You should not change this value. If you want to update the value,
  # then check the Home Manager release notes for breaking changes,
  home.stateVersion = "24.11";

  # Enable font management
  fonts.fontconfig.enable = true;

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

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
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
    ])
    ++ [
      # input-packages.nuka.packages.${system}.default
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either:
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #  /etc/profiles/per-user/aurora/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
    PAGER = "moar";
  };

  home.shellAliases = {
    ed25519-keygen = "ssh-keygen -t ed25519";
    la = "ls -alh";
    gc = "git clone";
    ga = "git add";
    cfa = "cfg add";
    cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    gl = "git pull";
    cfl = "cfg pull";
    gs = "git sa";
    hms = "home-manager switch";
    cfs = "cfg sa";
    gp = "git push";
    cfp = "cfg push";
    cfps = "cfs && cfp";
    ".." = "cd ..";
    py = "python";
    ff = "ffmpeg";
    mi = "mediainfo";
    m = "micro";
    n = "nano";
    nrs = "sudo nixos-rebuild switch";
    nfu = "nix flake update";
    wget = "wget -c";
    suspend = "systemctl suspend -i";
  };

  programs.vscode = {
    package = pkgs.vscodium;
    enable = true;
    profiles.default = {
      extensions = import ./codine/extension.nix pkgs;
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
  };

  programs.helix = {
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
