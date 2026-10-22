{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nip.url = "path:..";
  };

  outputs = inputs @ { nip, flake-utils, nixpkgs, ... }:
    let inputsFor = nip.lib.from (import ./inputs.nix) inputs;
    in
      flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShells.default = pkgs.mkShell {
            packages = inputsFor system;
          };
        }
    );
}
