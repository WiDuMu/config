{ inputs, pkgs, ... } :
{
  # NixGL, while it would be nice to be able to use nvidia it is both impure and broken RN
  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    offloadWrapper = "mesa";
    installScripts = ["mesa"];
  };
  home.packages = [pkgs.nixgl.nixGLIntel];
}
