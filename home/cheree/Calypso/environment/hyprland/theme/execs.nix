{ pkgs, ... }:
let
  config = ''
    # Daemons
    exec-once = dunst
    exec-once = swww-daemon
    exec-once = hypridle

    # Utilities
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store

    # Programs
    exec-once = waybar
    exec-once = vesktop --start-minimized
    exec-once = premid --no-sandbox
    exec-once = 1password --silent
    exec-once = onedrive --monitor
  '';
in
{
  xdg.configFile."hypr/theme/execs.conf".text = config;
}
