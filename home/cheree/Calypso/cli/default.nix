{ pkgs, ... }:
{
  imports = [ ./sysfetch ];

  home.packages = with pkgs; [
    pipes-rs
    lsix
  ];
}
