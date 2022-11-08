{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      lib = nixpkgs.lib;

      clock = pkgs.writeShellScriptBin "clock" (
        builtins.readFile ./packages/dwmblocks/clock.sh
      );

      dwmblocksConf = pkgs.writeText "config.h" ''
        //Modify this file to change what commands output to your statusbar, and recompile using the make command.
        static const Block blocks[] = {
            /*Icon*/	/*Command*/		            /*Update Interval*/	/*Update Signal*/
            {"",	    "${clock}/bin/clock",	    30,	                1}
        };

        //Sets delimiter between status commands. NULL character ('\0') means no delimiter.
        static char *delim = " ";  
      '';

    in with pkgs; {
      clock = writeShellScriptBin "clock" (
        builtins.readFile ./packages/dwmblocks/clock.sh
      );

      tmux = writeShellScriptBin "tmuxStart" (
        builtins.readFile ./packages/st/tmux-start.sh
      );
      st = callPackage ./packages/st/wrapper.nix { 
        st-unwrapped = (callPackage ./packages/st {}); 
        startScript = "${tmux}/bin/tmux";
      };
      rofi = callPackage ./packages/rofi {
        theme = builtins.toFile "rofi-theme.rasi" (
          builtins.readFile ./packages/rofi/themes/rofi-theme.rasi
        );
      };
      dwm = callPackage ./packages/dwm {};
      dwmblocks = callPackage ./packages/dwmblocks { conf = dwmblocksConf; };
    };
}
