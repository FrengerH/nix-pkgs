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
                  /*Command*/		            /*Update Interval*/	       /*Update Signal*/
            BLOCK("${clock}/bin/clock",         0,                         5),
            BLOCK("${clock}/bin/clock",         0,                         5)
        };

        // Maximum possible length of output from block, expressed in number of characters.
        #define CMDLENGTH 50

        // The status bar's delimiter which appears in between each block.
        #define DELIMITER " "

        // Adds a leading delimiter to the statusbar, useful for powerline.
        #define LEADING_DELIMITER

        // Enable clickability for blocks. Needs `dwm` to be patched appropriately.
        // See the "Clickable blocks" section below.
        #define CLICKABLE_BLOCKS
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
      dwmblocks = callPackage ./packages/dwmblocks { 
        conf = dwmblocksConf;
        # patches = [
        #   (fetchpatch {
        #     url = "https://raw.githubusercontent.com/LukeSmithxyz/dwmblocks/master/patches/dwmblocks-statuscmd-signal.diff";
        #     sha256 = "sha256-crceCEPE7mjlkbMmSQQMQ1h6wZVr2TUOfiibeNHf3YM=";
        #   })
        # ];
      };
      neovim = callPackage ./packages/neovim {};
    };
}
