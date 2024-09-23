{ inputs, pkgs, ... }:
{
  imports = [ ];
  programs = { };

  home.packages = with pkgs; [
    librewolf
    pavucontrol
    kitty
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
