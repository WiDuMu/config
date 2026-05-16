{pkgs, ...}: {
  users.users.aurora = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9l0Em3K1Zcs0f1c0pw3ZovL4Vg0GhOUgfWLZPsNx/W aurora"
    ];
  };
}
