{ nixpkgs ? (import <nixpkgs> {}) }:
let
  inherit (nixpkgs) bash curl coreutils gnugrep jq stdenv;
  version = "0.0.2";
in
  nixpkgs.stdenv.mkDerivation {
    name = "lapi-${version}";
    src = ./.;

    installPhase = ''
      mkdir -p $out/bin
      cp lapi3 $out/bin/lapi3
      ln -s $out/bin/lapi3 $out/bin/lapi
    '';

    postFixup = ''
      substituteInPlace $out/bin/lapi3 --replace "curl " "${curl}/bin/curl "
      substituteInPlace $out/bin/lapi3 --replace "cut " "${coreutils}/bin/cut "
      substituteInPlace $out/bin/lapi3 --replace "grep " "${gnugrep}/bin/grep "
      substituteInPlace $out/bin/lapi3 --replace "jq " "${jq}/bin/jq "
    '';

    meta = {
      description = "Rudimentary command line interface to the Linode API";
      license = stdenv.lib.licenses.bsd3;
      platform = stdenv.lib.platforms.all;
    };
  }
