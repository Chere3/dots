{ pkgs, ... }:
let
  script = ''
    env = XCURSOR_SIZE,23
    env = HYPRCURSOR_SIZE,23
    env = GTK_THEME, Adwaita:dark
  '';
in
{
  xdg.configFile."hypr/theme/envs.conf".text = script;
}
