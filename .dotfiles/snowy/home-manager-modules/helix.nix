{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      # theme = "base16_transparent";
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      editor.file-picker.hidden = false;
    };
    package = pkgs.evil-helix;
  };
}
