dir: (builtins.mapAttrs (name: path: builtins.readFile path) ((import ./dirToAttrset.nix) dir))
