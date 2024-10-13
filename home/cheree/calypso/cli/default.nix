{ pkgs, ... }:
{
  imports = [ ./sysfetch ./ssh.nix ];

  home.packages = with pkgs; [
    pipes-rs
    lsix
  ];
}
