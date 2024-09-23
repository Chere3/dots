{ pkgs, ... }:
{
  imports = [ ./macchina.nix ];
  home.packages = with pkgs; [ fastfetch ];
}
