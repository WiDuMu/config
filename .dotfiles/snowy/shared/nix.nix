{...}: {
  # Enable garbage collection automatically
  nix.gc = {
    automatic = true;
    #  dates = "weekly"; # For some reason home-manger and nixOS disagree on what this option should be named
    options = "--delete-older-than 14d";
    persistent = true;
    randomizedDelaySec = "50min";
  };
}
