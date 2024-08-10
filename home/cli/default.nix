{ lib, pkgs, ... }:
{
  home-manager.enable = true;
  neovim.enable = true;
  neovim.defaultEditor = true;
  direnv.enable = true;
  direnv.nix-direnv.enable = true;

  ssh = import ./ssh.nix;
  git = import ./git.nix { inherit lib pkgs; };
  fish = import ./fish.nix;
}
