{ pkgs, ... }:
{
  imports = [ ./sysfetch ./ssh.nix ./git.nix ];

  home.packages = with pkgs; [
    pipes-rs
    lsix
  ];
}
