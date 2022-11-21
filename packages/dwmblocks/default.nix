{ lib, stdenv, fetchFromGitHub, libX11, patches ? [ ], writeText, conf ? null }:

stdenv.mkDerivation {
  pname = "dwmblocks";
  version = "unstable-2020-12-27";

  # src = fetchFromGitHub {
  #   owner = "LukeSmithxyz";
  #   repo = "dwmblocks";
  #   rev = "5a6fa8d550c11552480f10e660073ca294d446b1";
  #   sha256 = "sha256-3dutuQwYFg+oaIQ5cGL7lWapuzEWTeE/Kn0suEkCbLo=";
  # };
  src = fetchFromGitHub {
    owner = "UtkarshVerma";
    repo = "dwmblocks-async";
    rev = "6a97f4d0c517d1d1c71fa599b97eb3508710f5a1";
    sha256 = "sha256-/rUZDkOvt9qlqoWaWvjZcDz8sxR9B9an7jsTOIP92cA=";
  };


  buildInputs = [ libX11 ];

  inherit patches;

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf
        then conf else writeText "config.h" conf;
    in
      lib.optionalString (conf != null) "cp ${configFile} config.h";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Modular status bar for dwm written in c";
    homepage = "https://github.com/LukeSmithxyz/dwmblocks";
    license = licenses.isc;
    maintainers = with maintainers; [ sophrosyne ];
    platforms = platforms.linux;
  };
}

