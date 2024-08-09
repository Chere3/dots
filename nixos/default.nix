{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./packages.nix
    ./services.nix
    ./system.nix
  ];
}
