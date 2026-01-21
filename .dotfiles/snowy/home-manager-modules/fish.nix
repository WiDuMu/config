{pkgs, ...}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellInitLast = "fish_add_path $HOME/.cargo/bin";
  };
}
