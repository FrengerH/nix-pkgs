let
  pkgs = import <nixpkgs> {};
in with pkgs; {
  rofi = callPackage ./packages/rofi {
    theme = "./packages/rofi/themes/rofi-theme.rasi";
  };
  dwm = callPackage ./packages/dwm {};
}
