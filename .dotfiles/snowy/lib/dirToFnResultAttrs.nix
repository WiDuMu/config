# Based on dirToAttrset.nix stolen shamelessly from Nyyadia
let
  # Function to convert a directory of .nix files to an attribute set
  dirToAttrset = dir: fn: let
    # Read directory contents with error handling
    entriesResult = builtins.tryEval (builtins.readDir dir);

    # Early return if directory doesn't exist or can't be read
    entries =
      if !entriesResult.success
      then throw "dirToAttrset: Cannot read directory ${toString dir}"
      else entriesResult.value;

    # Process each entry - returns { name, value } or null
    processEntry = name: type:
      if type == "regular"
      then
        {
          name = name;
          value = fn name (dir + "/${name}");
        }
      else
        # Skip everything else
        null;

    # More efficient: use builtins.concatMap to filter and map in one pass
    result = builtins.listToAttrs (
      builtins.concatMap (
        name: let
          entry = processEntry name entries.${name};
        in
          if entry == null
          then []
          else [entry]
      ) (builtins.attrNames entries)
    );
  in
    result;
in
  dirToAttrset
