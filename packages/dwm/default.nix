{ lib, stdenv, fetchurl, libX11, libXinerama, libXft, writeText, writeShellScriptBin, patches ? [ ], conf ? null}:

stdenv.mkDerivation rec {
  pname = "dwm";
  version = "6.3";

  src = fetchurl {
    url = "https://github.com/FrengerH/dwm/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-1HflLYRJK5g6ukmedhMQ2N9+h7URHBf8zhq7BD5hWr0=";
  };

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
  '';

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to set the config.def.h file containing the configuration
  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf
        then conf else writeText "config.def.h" conf;
      tmuxStart = writeShellScriptBin "tmuxStart" (builtins.readFile ./scripts/tmux-start.sh);
      secretsFile = writeText "secrets.h" ''
        static const char path[] = "";
        static const char tmux_start[] = "";
        static const char powermenu[] = "";
        static const char rofitheme[] = "";
      '';
    in
    lib.optionalString (conf != null) "cp ${configFile} config.def.h" + "cp ${secretsFile} secrets.h";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    homepage = "https://dwm.suckless.org/";
    description = "An extremely fast, small, and dynamic window manager for X";
    longDescription = ''
      dwm is a dynamic window manager for X. It manages windows in tiled,
      monocle and floating layouts. All of the layouts can be applied
      dynamically, optimising the environment for the application in use and the
      task performed.
      Windows are grouped by tags. Each window can be tagged with one or
      multiple tags. Selecting certain tags displays all windows with these
      tags.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viric neonfuz ];
    platforms = platforms.all;
  };
}
