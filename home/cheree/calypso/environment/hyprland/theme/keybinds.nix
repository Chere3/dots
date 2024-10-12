{ pkgs, ... }:
let
  config = ''
    # Variables for programs
    $terminal = foot
    $fileManager = dolphin
    $drun = fuzzel
    $fullscreendis = hyprctl dispatch fullscreen 1

    # Sound and media controls
    bindl = Alt ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle
    bindl = Super ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle
    bindl = ,XF86AudioMute, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0% 
    bindle=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ 
    bindle=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- 
    bindl=, XF86AudioPlay, exec, playerctl play-pause # the stupid key is called play , but it toggles 
    bindl=, XF86AudioNext, exec, playerctl next 
    bindl=, XF86AudioPrev, exec, playerctl previous

    # See https://wiki.hyprland.org/Configuring/Keywords/


    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = Super, RETURN, exec, $terminal
    bind = Super, Q, killactive,
    bind = Super, M, exit,
    bind = Super, E, exec, $fileManage



    bind = Super, SUPER_L, exec, $drun

    bind = Super, P, pin, # dwindle
    bind = Super, J, togglesplit, # dwindle
    bind = Super+Alt, Space, togglefloating,
    bind = Super, D, exec, $fullscreendis 
    bind = Super, F, fullscreen, 0,

    # Move focus with mainMod + arrow keys
    bind = Super, left, movefocus, l
    bind = Super, right, movefocus, r
    bind = Super, up, movefocus, u
    bind = Super, down, movefocus, d

    # Tools
    bind = Super, Print, exec, ~/.config/hypr/scripts/screenshot.sh copy area # Screenshots
    bind = Super, V, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy # Clipboard history
    bind = Super+SHIFT, C, exec, hyprpicker | wl-copy # Color picker
    bind = Super, Period, exec, pkill fuzzel || ~/.config/fuzzel/fuzzel-emoji.sh

    # Switch workspaces with mainMod + [0-9]
    bind = Super, 1, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 1 
    bind = Super, 2, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 2 
    bind = Super, 3, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 3 
    bind = Super, 4, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 4
    bind = Super, 5, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 5 
    bind = Super, 6, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 6 
    bind = Super, 7, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 7 
    bind = Super, 8, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 8
    bind = Super, 9, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 9 
    bind = Super, 0, exec, ~/.config/hypr/scripts/workspace_action.sh workspace 10 

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = Super+Alt, 1, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 1 
    bind = Super+Alt, 2, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 2 
    bind = Super+Alt, 3, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 3 
    bind = Super+Alt, 4, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 4
    bind = Super+Alt, 5, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 5 
    bind = Super+Alt, 6, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 6 
    bind = Super+Alt, 7, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 7 
    bind = Super+Alt, 8, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 8
    bind = Super+Alt, 9, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 9 
    bind = Super+Alt, 0, exec, ~/.config/hypr/scripts/workspace_action.sh movetoworkspacesilent 10 


    # Example special workspace (scratchpad)
    bind = Super, S, togglespecialworkspace, magic
    bind = Super+SHIFT, S, movetoworkspace, special:magic

    # Scroll through existing workspaces with mainMod + scroll
    bind = Super, mouse_down, workspace, e+1
    bind = Super, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = Super, mouse:272, movewindow
    bindm = Super, mouse:273, resizewindow
  '';
in
{
  xdg.configFile."hypr/theme/keybinds.conf".text = config;
}
