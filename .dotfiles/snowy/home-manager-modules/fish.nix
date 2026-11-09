{pkgs, ...}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInitLast = "fish_add_path $HOME/.cargo/bin";
  };
}
