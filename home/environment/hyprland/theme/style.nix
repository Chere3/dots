{ pkgs, ... }:
let
  config = ''
    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general { 
        gaps_in = 5
        gaps_out = 20

        border_size = 1

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        col.active_border = rgb(89B4FA)
        col.inactive_border = rgb(15141A)

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false

        layout = dwindle
    }

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration {
        rounding = 0

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0
        inactive_opacity = 1.0

        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur {
            enabled = true
            size = 3
            passes = 1
            
            vibrancy = 0.1696
        }
    }

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations {
        enabled = true

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 5, myBezier
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 7, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 3, default
    }

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle {
        pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # You probably want this
    }

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master {
        new_status = master
    }

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc { 
        force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
        new_window_takes_over_fullscreen = 2
    }

    windowrulev2 = suppressevent maximize, class:.* 
  '';
in
{
  xdg.configFile."hypr/theme/style.conf".text = config;
}
