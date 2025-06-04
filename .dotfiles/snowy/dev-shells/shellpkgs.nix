# Lists of packages for dev shells
{pkgs, ...}: let
  ocaml = with pkgs; [ocaml ocamlformat] ++ (with pkgs.ocamlPackages; [dune_3 odoc utop ocaml-lsp]);
  rust = with pkgs; [cargo];
  js = with pkgs; [bun biome];
  nix = with pkgs; [alejandra];
  c = with pkgs; [gdb rr];
  vlang = with pkgs; [vlang];
  zig = with pkgs; [zig zls];
  default = with pkgs; [bat eza fd zoxide] ++ c ++ js ++ nix ++ rust;
  full = with pkgs; [tokei] ++ default ++ ocaml ++ vlang ++ zig;
in {
  inherit ocaml rust js nix c vlang zig default full;
}
