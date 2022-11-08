{ lib
, stdenv
, fetchurl
, pkg-config
, fontconfig
, freetype
, libX11
, libXft
, ncurses
, writeText
, conf ? null
, patches ? [ ]
, extraLibs ? [ ]
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "st-unwrapped";
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/FrengerH/st/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-TSEH+dlduuMOOCcxgc55LYjeKfjD3Xm4Bq53OKw+ftg=";
  };

  inherit patches;

  configFile = lib.optionalString (conf != null)
    (writeText "config.def.h" conf);

  postPatch = lib.optionalString (conf != null) "cp ${configFile} config.def.h"
    + lib.optionalString stdenv.isDarwin ''
    substituteInPlace config.mk --replace "-lrt" ""
  '';

  strictDeps = true;

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  buildInputs = [
    libX11
    libXft
  ] ++ extraLibs;

  preInstall = ''
    export TERMINFO=$out/share/terminfo
  '';

  installFlags = [ "PREFIX=$(out)" ];

  passthru.tests.test = nixosTests.terminal-emulators.st;

  meta = with lib; {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.unix;
  };
}

