{
  config,
  pkgs,
  system,
  input-packages,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aurora";
  home.homeDirectory = "/home/aurora";

  imports = [
    ./home-manager/starship.nix
    ./home-manager/fish.nix
    ./home-manager/nushell.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
      fd
      ffmpeg-full
      gdb
      jan
      lldb
      mediainfo
      rr
      rustc
      tokei
      typst
      valgrind
      vlang
      yt-dlp
      zig
      zls
      zoxide

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ [
      input-packages.nuka.packages.${system}.default
      # input-packages.codine.packages.${system}.default
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
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aurora/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };

  home.shellAliases = {
    la = "ls -alh";
    gc = "git clone";
    ga = "git add";
    cfa = "cfg add";
    gl = "git pull";
    cfl = "cfg pull";
    gs = "git sa";
    cfs = "cfg sa";
    gp = "git push";
    cfp = "cfg push";
    ".." = "cd ..";
    py = "python";
    ff = "ffmpeg";
    mi = "mediainfo";
    m = "micro";
    n = "nano";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
