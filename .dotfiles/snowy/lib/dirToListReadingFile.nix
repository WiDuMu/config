dir: let
  fileTypes = builtins.readDir dir;
  attrsToList = set:
    map (n: {
      name = n;
      value = set.${n};
    }) (builtins.attrNames set);
  fileNames = map (file: file.name) (builtins.filter (file: file.value == "regular") (attrsToList fileTypes));
  fileValues =
    map (name: {
      inherit name;
      value = builtins.readFile "${dir}/${name}";
    })
    fileNames;
in
  fileValues
