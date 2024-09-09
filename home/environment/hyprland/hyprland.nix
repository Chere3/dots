{ pkgs, ... }:
let
  config = ''
    source = ~/.config/hypr/theme/keybinds.conf
    source = ~/.config/hypr/theme/execs.conf
    source = ~/.config/hypr/theme/style.conf
    source = ~/.config/hypr/theme/envs.conf
    source = ~/.config/hypr/theme/input.conf
    source = ~/.config/hypr/theme/rules.conf
  '';
in
{
  xdg.configFile."hypr/hyprland.conf".text = config;
}
