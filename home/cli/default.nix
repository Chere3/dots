{ lib, pkgs, ... }:
{
  imports = [ ./macchina.nix ];

  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.ssh = import ./ssh.nix;
  programs.git = import ./git.nix { inherit lib pkgs; };
  programs.fish = import ./fish.nix;
}
