{ pkgs, ... }:
{
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./mocha.nix
    ./theme/envs.nix
    ./theme/execs.nix
    ./theme/input.nix
    ./theme/keybinds.nix
    ./theme/rules.nix
    ./theme/style.nix
  ];
}
