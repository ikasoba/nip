{
  outputs = { ... }: {
    lib = {
      from =
        inputMap: inputs: system:
        let
          x = builtins.mapAttrs (
            name:
              let input = inputs.${name};
              in
                map (pkgname: input.legacyPackages.${system}.${pkgname} or input.packages.${system}.${pkgname} or null)
          ) inputMap;
        in
          builtins.concatLists (builtins.attrValues x)
        ;
    };
  };
}
