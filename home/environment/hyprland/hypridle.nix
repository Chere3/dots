{ pkgs, ... }:
let
  config = ''
    $lock_cmd = pidof hyprlock || hyprlock
    $suspend_cmd = pidof steam || systemctl suspend || loginctl suspend # fuck nvidia

    general {
        lock_cmd = $lock_cmd
        before_sleep_cmd = loginctl lock-session
    }

    listener {
        timeout = 600 # 10mins
        on-timeout = loginctl lock-session
    }

    listener {
        timeout = 900 # 15mins
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }

    listener {
        timeout = 7200 # 2hours
        on-timeout = $suspend_cmd
    }
  '';
in
{
  xdg.configFile."hypr/hypridle.conf".text = config;
}
