{ pkgs, ... }:
{
  imports = [ ./helix ];

  home.packages = with pkgs; [
    podman-compose
    obsidian
  ];
}
