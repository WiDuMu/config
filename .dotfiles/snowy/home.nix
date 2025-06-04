{
  config,
  pkgs,
  system,
  input-packages,
  ...
}: let
  dirToList = import ./lib/dirToList.nix;
in {
  home.username = "aurora";
  home.homeDirectory = "/home/aurora";

  imports = dirToList ./home-manager-modules;

  # You should not change this value.
  home.stateVersion = "24.11";

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
      markdown-oxide
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
      rustup
      tinymist
      tldr
      tokei
      typst
      valgrind
      vlang
      yt-dlp
      zig
      zls
      zoxide
      # Simple 'backup' command
      (pkgs.writeShellScriptBin "bak" ''
        mv "$1" "$1.bak"
      '')
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
    EDITOR = "micro";
    VISUAL = "micro";
    PAGER = "moar";
  };

  home.shellAliases = {
    d = "delta";
    ls = "eza -a";
    ed25519-keygen = "ssh-keygen -t ed25519";
    la = "ls -alh";
    gc = "git clone";
    ga = "git add";
    cfa = "cfg add";
    cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    gl = "git pull";
    cfl = "cfg pull";
    gs = "git sa";
    hm = "home-manager";
    hms = "home-manager switch";
    cfs = "cfg sa";
    gp = "git push";
    cfp = "cfg push";
    cfsp = "cfg saps";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin.flavor = "mocha";
  catppuccin.accent = "mauve";
  catppuccin.enable = true;
  catppuccin.vscode.enable = false;
}
