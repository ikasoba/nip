let
  inherit (import <nixpkgs> {}) lib;
  args = builtins.fromJSON (builtins.getEnv "ARGS");
  inputsFilePath = builtins.getEnv "INPUTS_FILE";
  inputs = import "${inputsFilePath}";
  pipel' = builtins.foldl' (x: f: f x);
  compose' = builtins.foldl' (f: g: x: g (f x)) (x: x);
  refs =
    pipel' args [
      (map (
        let
          parse = builtins.match "([^:]+)#(.+)";
          makeEntry =
            m: {
              name = builtins.elemAt m 0;
              value = builtins.elemAt m 1;
            };
        in
          compose' [ parse makeEntry ]
      ))
      (builtins.groupBy (x: x.name))
      (builtins.mapAttrs (_: map (x: x.value)))
    ];
  result =
    pipel' (builtins.attrNames inputs ++ builtins.attrNames refs) [
      lib.unique
      (map (name: {
        inherit name;
        value = lib.unique (
          (inputs.${name} or []) ++ (refs.${name} or [])
        );
      }))
      (builtins.listToAttrs)
    ]
    ;
in
  lib.generators.toPretty { } result
