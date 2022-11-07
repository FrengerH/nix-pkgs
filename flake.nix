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
    in with pkgs; {
      rofi = callPackage ./packages/rofi {
        theme = "./packages/rofi/themes/rofi-theme.rasi";
      };
      dwm = callPackage ./packages/dwm {};
    };
}
