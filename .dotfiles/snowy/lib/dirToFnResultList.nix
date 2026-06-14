dir: fn: (builtins.attrValues ((import ./dirToFnResultAttrs.nix) dir fn))
