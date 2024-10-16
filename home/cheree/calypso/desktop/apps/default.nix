{ inputs, pkgs, ... }:
{
  imports = [ ./spicetify.nix ];
  programs = {
    foot = import ./foot pkgs;
  };

  home.packages = with pkgs; [
    pavucontrol
    btop
    vscode
    telegram-desktop
    brave
    premid
    bottles
    vesktop
    slack
    mplayer
    vlc
    alsa-utils
    imv
    dunst
    fuzzel
  ];
}
