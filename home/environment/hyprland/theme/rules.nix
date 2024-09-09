{ pkgs, ... }:
let
  config = ''
    # Windows rules
    windowrule=float,^(foot)$

    ############################################## Workspaces with windows rules ############################################
    windowrule=workspace 1,^(firefox)$

    # Chat apps
    windowrule=workspace 3,^(vesktop)$
    windowrule=workspace 3,^(org.telegram.desktop)$

    # Code editors
    windowrule=workspace 2,^(code-url-handler)$

    # Music apps
    windowrule=workspace 4,title:^(Spotify Premium)$

    # Browsers
    windowrule=workspace 5, ^(brave-browser)$
    windowrule=fullscreen, ^(brave-browser)$
    windowrule=float, title:^(Picture-in-Picture)$
    windowrule=size 460 300, title:^(Picture-in-Picture)$
    windowrule=move 1360 730, title:^(Picture-in-Picture)$
    windowrule=float, title:^(Developer Tools)(.*)$
    windowrule=size 460 300, title:^(Developer Tools)(.*)$

    ############################################## Windows details ################################### 
    windowrulev2 = suppressevent maximize, class:.*
    windowrulev2 = suppressevent close, class:.*

    ############################################## Workspaces rules ##################################
    workspace=1, monitor:HDMI-A-1
    workspace=2, monitor:DP-1
    workspace=3, monitor:DP-1
    workspace=4, monitor:DP-1
    workspace=5, monitor:DP-1
  '';
in
{
  xdg.configFile."hypr/theme/rules.conf".text = config;
}
