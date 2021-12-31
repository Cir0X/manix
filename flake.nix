{
  description = "A fast CLI documentation searcher for Nix.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , naersk
    , flake-compat
    }:
    let
      pname = "manix";
    in
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = naersk.lib.${system};
      in
      rec {
        packages.${pname} = naersk-lib.buildPackage ./.;
        defaultPackage = packages.${pname};
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            rust-analyzer
            cargo-flamegraph
          ];
        };
      });
}
