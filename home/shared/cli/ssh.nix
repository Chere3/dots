{ lib, pkgs, ... }:
{
  enable = true;
  extraConfig = ''
    Host *
    IdentityAgent ~/.1password/agent.sock
  '';
}
