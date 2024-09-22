{ lib, pkgs, ... }:
{
  environment = {
    variables.EDITOR = "neovim";
    systemPackages = with pkgs; [
      lsof
      wget
      unrar
      unzip
      p7zip
      home-manager
      nix-output-monitor
    ];
  };

  programs = {
    git.enable = true;
    light.enable = true;
    dconf.enable = true;
    nano.enable = false;
    less.enable = false;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/cheree/dots";
    };

    fish = import ./bash.nix;
  };
}
