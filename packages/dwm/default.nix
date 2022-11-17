{ lib, stdenv, fetchurl, libX11, libXinerama, libXft, writeText, writeShellScriptBin, patches ? [ ], conf ? null}:

stdenv.mkDerivation rec {
  pname = "dwm";
  version = "test-6";

  src = fetchurl {
    url = "https://github.com/FrengerH/dwm/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-gNKEV4BS0McpL04bXmbaVDhyMRhvnbD9KQem0E43NSg="; # Version test-6
    # sha256 = "sha256-GSFr2+cF1DJw9H5BHdF/Otz9ZU5q9LJ+JwgT5bsB+RY="; # Version test-5
    # sha256 = "sha256-xQlrUIf43xdY+hYLrvQy3L8i1+k847n7tSIxsLoIUl4="; # Version test-4
    # sha256 = "sha256-wxAydSYYptUc1NRoapgI2gHWnUqYJ7TjyCJc3jkBnZs="; # Version test-3
    # sha256 = "sha256-V8B+tgYmn0ksWLpGPJzcad7bclYeRoo2PcUex1Qh5gM="; # Version test-2
    # sha256 = "sha256-VOJrq7Q5mkFieYQvlS0OgjfaNIXI5BYV8IiiG0cQv00="; # Version test-1
    # sha256 = "sha256-9Li2s2gje7t36lGsh9KFNwWWL/7VZKb3qssRgX59PLE="; # Version 6.3.6
    # sha256 = "sha256-MPbkRKLaK1x5/BBqrNx2GDgwATig2W6GPvQuiNj40qA="; # Version 6.3.5
    # sha256 = "sha256-mtNffAs/brGyDHudNt1w41TykOKM81hBkhhFTJA7Ahg="; # Version 6.3.4
    # sha256 = "sha256-kbYFKSddA7hv07T68wTnr4DNY0Acsi0jVkBpsPOq1Fs="; # Version 6.3.3
    # sha256 = "sha256-vmyxFgcRgy9ITnn8ypHyZxYynIR21HHrSt+m2ZjQ18M="; # Version 6.3.2
    # sha256 = "sha256-bX+E5mRGhWWmwJYh9fL4zGQBZTX4kW2PSPyNlepHhMw="; # Version 6.3.1
    # sha256 = "sha256-1HflLYRJK5g6ukmedhMQ2N9+h7URHBf8zhq7BD5hWr0="; # Version 6.3
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
  };}
