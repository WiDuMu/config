{
  programs.bash = {
    enable = true;
    bashrcExtra = ''source ~/.nix-profile/etc/profile.d/hm-session-vars.sh'';
  };
}
