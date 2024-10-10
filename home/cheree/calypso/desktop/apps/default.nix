{ inputs, pkgs, ... }:
{
  imports = [ ./spicetify.nix ];
  programs = {
    foot = import ./foot pkgs;
  };

  home.packages = with pkgs; [
    librewolf
    pavucontrol
    btop
    vscode
    spotify
    telegram-desktop
    brave
    premid
    bottles
    vesktop
    slack
    mplayer
    vlc
    alsa-utils
    onedrive
    imv
    dunst
    fuzzel
  ];
}
