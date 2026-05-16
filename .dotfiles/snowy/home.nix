module-inputs @ {
  config,
  pkgs,
  system,
  input-packages,
  ...
}: let
  dirToList = import ./lib/dirToList.nix;
in {
  home.username = "aurora";
  home.homeDirectory = "/home/${config.home.username}";

  imports =
    (dirToList ./home-manager-modules)
    ++ (
      if (module-inputs ? osConfig)
      then [
        {
          home.shellAliases.nrs = "sudo nixos-rebuild switch";
          home.shellAliases.rs = "sudo nixos-rebuild switch";
        }
      ]
      else [
        {
          home.shellAliases.hms = "home-manager switch";
          home.shellAliases.rs = "home-manager switch";
          home.packages = with pkgs; [
          ];
          nix.nixPath = ["nixpkgs=${module-inputs.inputs.nixpkgs}"];
        }
      ]
    );

  # You should not change this value.
  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs;
    [
      age
      alejandra
      # av1an
      bat
      biome
      bun
      cargo
      dav1d
      delta
      dua
      efficient-compression-tool
      fd
      ffmpeg-full
      gdb
      git-lfs
      hyperfine
      libjxl
      lldb
      luajit
      gnumake
      markdown-oxide
      mediainfo
      meson
      moor
      nasm
      ninja
      nix-tree
      nodePackages_latest.nodejs
      oxipng
      parallel
      rr
      sops
      ssh-to-age
      tinymist
      tldr
      tokei
      typst
      uv
      valgrind
      vlang
      yt-dlp
      zig
      zls
      zoxide
      # Simple 'backup' command
      (pkgs.writeShellScriptBin "bak" ''
        echo "Backing up $1..."
        mv "$1" "$1.bak"
      '')
      # Suspend after a given amount of time. Don't ask me why I have to read this like this
      (pkgs.writeScriptBin "suspend_timed" (builtins.readFile ./shared/scripts/suspend_timed))
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
    # # Import any package in the input packages automagickally
    ++ (builtins.map (p: p.packages.${system}.default) input-packages);

  # If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at:
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #  /etc/profiles/per-user/aurora/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    DOTFILES = "$HOME/.dotfiles";
    SNOWY = "$HOME/.dotfiles/snowy";
    PAGER = "moor";
    GIT_PAGER = "delta";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.shellAliases = {
    d = "delta";
    ed25519-keygen = "ssh-keygen -t ed25519";
    la = "ls -alh";
    gc = "git clone";
    ga = "git add";
    cfa = "cfg add";
    cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    cfui = ''gitui -d "$HOME/.cfg" -w "$HOME"'';
    cfd = "cfg diff";
    gui = "gitui";
    gl = "git pull";
    cfl = "cfg pull";
    gs = "git sa";
    cfs = "cfg sa";
    gp = "git push";
    cfp = "cfg push";
    cfsp = "cfg saps";
    ".." = "cd ..";
    py = "python";
    ff = "ffmpeg";
    mi = "mediainfo";
    n = "nano";
    nfu = "nix flake update";
    snowy = "cd $SNOWY";
    wget = "wget -c";
    suspend = "systemctl suspend -i";
    snow = "cd $SNOWY";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
