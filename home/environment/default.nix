{ lib, pkgs, ... }:
{
  imports = [
    ./waybar.nix
    ./dunst.nix
    ./fuzzel.nix
  ];
}
