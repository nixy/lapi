{ nixpkgs ? (import <nixpkgs> {}) }:
let
  inherit (nixpkgs) bash curl coreutils gnugrep jq stdenv;
  version = "0.0.1";
in
  nixpkgs.stdenv.mkDerivation {
    name = "lapi-${version}";
    src = ./.;

    installPhase = ''
      mkdir -p $out/bin
      cp lapi $out/bin
    '';

    postFixup = ''
      substituteInPlace $out/bin/lapi --replace "curl " "${curl}/bin/curl "
      substituteInPlace $out/bin/lapi --replace "cut " "${coreutils}/bin/cut "
      substituteInPlace $out/bin/lapi --replace "grep " "${gnugrep}/bin/grep "
      substituteInPlace $out/bin/lapi --replace "jq " "${jq}/bin/jq "
    '';

    meta = {
      description = "Rudimentary command line interface to the Linode API";
      license = stdenv.lib.licenses.bsd3;
      platform = stdenv.lib.platforms.all;
    };
  }
