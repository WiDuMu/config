# This is a module for dealing with the particular method of deploying this flake, inside a bare git repo
{pkgs, ...}: {
  home.sessionVariables = {
    DOTFILES = "$HOME/.dotfiles";
    SNOWY = "$HOME/.dotfiles/snowy";
  };

  home.shellAliases = {
    cfa = "cfg add";
    cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    cfui = ''gitui -d "$HOME/.cfg" -w "$HOME"'';
    cfd = "cfg diff";
    cfl = "cfg pull";
    cfs = "cfg sa";
    cfp = "cfg push";
    cfsp = "cfg saps";
    snow = "cd $SNOWY";
    snowy = "cd $SNOWY";
  };
}
