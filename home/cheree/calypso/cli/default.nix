{ pkgs, ... }:
{
  imports = [ ./sysfetch ./ssh.nix ./nixvim.nix ];

  home.packages = with pkgs; [
    pipes-rs
    lsix
  ];
}
