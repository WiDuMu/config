{
  default-packages = with pkgs; [bat eza fd micro zoxide];
  full-packages = with pkgs; [tokei];
  ocaml-packages = with pkgs; [ocaml ocamlformat] ++ (with pkgs.ocamlPackages; [dune_3 odoc utop ocaml-lsp]);
  rust-packages = with pkgs; [cargo];
  js-packages = with pkgs; [bun biome];
  nix-packages = with pkgs; [alejandra];
  c-packages = with pkgs; [gdb rr];
  vlang-packages = with pkgs; [vlang];
  zig-packages = with pkgs; [zig zls];
}
