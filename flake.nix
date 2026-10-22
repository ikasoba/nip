{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "nip";
          src = ./.;
          buildPhase = ''
            mkdir -p "$out/bin"
            cp -r "$src"/{nip.bash,lib,cli} "$out/bin"
            mv "$out/bin/nip.bash" "$out/bin/nip"
            chmod +x "$out/bin/nip"
          '';
        };
      }
    ) // {
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
