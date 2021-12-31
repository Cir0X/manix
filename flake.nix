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
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; }; in
    rec {
      packages.manix = naersk.lib.${system}.buildPackage ./.;
      defaultPackage = packages.manix;
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          rust-analyzer
          cargo-flamegraph
        ];
      };
    });
}
