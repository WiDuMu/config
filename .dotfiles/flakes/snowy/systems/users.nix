{pkgs, ...}: {
  programs.fish.enable = true;
  users.users.aurora = {
    isNormalUser = true;
    description = "aurora";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9l0Em3K1Zcs0f1c0pw3ZovL4Vg0GhOUgfWLZPsNx/W aurora"
    ];
  };
}
