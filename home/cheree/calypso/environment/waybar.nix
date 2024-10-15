{ pkgs, stable, ... }:
let
  config = ''
    {
        "layer": "top",
        "position": "top",
        "spacing": 0,
        "height": 34,
        "modules-left": [
            "custom/logo",
            "hyprland/workspaces"
        ],
        "modules-center": [
            "clock",
            "hyprland/window"
        ],
        "modules-right": [
            "tray",
            "memory",
            "cpu",
            "custom/gpu",
            "network",
            "pulseaudio",
            "custom/power"
        ],
        "wlr/taskbar": {
            "format": "{icon}",
            "on-click": "activate",
            "on-click-right": "fullscreen",
            "icon-theme": "WhiteSur",
            "icon-size": 25,
            "tooltip-format": "{title}"
        },
        "hyprland/workspaces": {
            "on-click": "activate",
            "format": "{icon}",
            "format-icons": {
                "default": "",
                "1": "1",
                "2": "2",
                "3": "3",
                "4": "4",
                "5": "5",
                "6": "6",
                "7": "7",
                "8": "8",
                "9": "9",
                "active": "󱓻",
                "urgent": "󱓻"
            },
            "persistent-workspaces": {
                "1": [],
                "2": [],
                "3": [],
                "4": [],
                "5": []
            }
        },
        "memory": {
            "interval": 5,
            "format": "  {}%",
            "max-length": 10
        },
        "cpu": {
            "interval": 5,
            "format": "󰍛 {}%",
            "max-length": 10
        },
        "custom/gpu": {
        "exec": "cat /sys/class/hwmon/hwmon4/device/gpu_busy_percent",
        "format": "󰡀 {}%",
        "return-type": "",
        "interval": 5
        },
        "tray": {
            "spacing": 10
        },
        "clock": {
            "tooltip-format": "{calendar}",
            "format-alt": "  {:%a, %d %b %Y}",
            "format": "  {:%I:%M %p}"
        },
        "sway/window": {
            "max-length": 80,
            "tooltip": false
        },
        "network": {
            "format-wifi" : "{icon}",
            "format-icons": ["󰤯","󰤟","󰤢","󰤥","󰤨"],
            "format-ethernet": "󰀂  ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
    	"format-alt" : "󱛇",
            "format-disconnected" : "󰖪",
    	"tooltip-format-disconnected": "Disconnected",
    	"on-click": "~/.config/rofi/wifi/wifi.sh &",
            "on-click-right": "~/.config/rofi/wifi/wifinew.sh &",
    	"interval": 5,
    	"nospacing": 1
        },
        "pulseaudio": {
            "format": "{icon}",
            "format-bluetooth": "󰂰",
            "nospacing": 1,
            "tooltip-format": "Volume : {volume}%",
            "format-muted": "󰝟",
            "format-icons": {
                "headphone": "",
                "default": ["󰖀","󰕾",""]
            },
            "on-click": "pavucontrol",
            "scroll-step": 1
        },
        "custom/logo": {
            "format": "  ",
            "tooltip": false,
            "on-click": "~/.config/rofi/launchers/misc/launcher.sh &"
        },
            "custom/power": {
            "format": "󰤆",
            "tooltip": false,
            "on-click": "~/.config/rofi/powermenu/type-2/powermenu.sh &"
        }
    }
  '';
  style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: monospace;
      font-size: 12px;
    }

    window#waybar {
      background-color: #1e1e2e;
      transition-property: background-color;
      transition-duration: 0.5s;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #workspaces {
      background-color: transparent;
    }

    #workspaces button {
      all: initial;
      /* Remove GTK theme values (waybar #1351) */
      min-width: 0;
      /* Fix weird spacing in materia (waybar #450) */
      box-shadow: inset 0 -3px transparent;
      /* Use box-shadow instead of border so the text isn't offset */
      padding: 6px 18px;
      margin: 6px 3px;
      border-radius: 4px;
      background-color: #11111B;
      color: #cdd6f4;
    }

    #workspaces button.active {
      color: #cdd6f4;
      background-color: #11111B;
    }

    #workspaces button:hover {
      box-shadow: inherit;
      text-shadow: inherit;
      color: #cdd6f4;
      background-color: #11111B;
    }

    #workspaces button.urgent {
      background-color: #f38ba8;
    }

    #memory,
    #cpu,
    #custom-power,
    #battery,
    #backlight,
    #pulseaudio,
    #network,
    #clock,
    #tray,
    #window,
    #custom-gpu {
      border-radius: 4px;
      margin: 6px 3px;
      padding: 6px 12px;
      background-color: #11111B;
      color: #cdd6f4;
    }

    #custom-power {
      margin-right: 6px;
    }

    #custom-logo {
      padding-right: 7px;
      padding-left: 7px;
      margin-left: 5px;
      font-size: 15px;
      border-radius: 8px 0px 0px 8px;
      color: #89b4fa;
    }

    @keyframes blink {
      to {
        background-color: #f38ba8;
        color: #181825;
      }
    }

    #battery.warning,
    #battery.critical,
    #battery.urgent {
      background-color: #f38ba8;
      color: #181825;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    #network {
      background-color: #11111B;
      padding-right: 17px;
    }

    tooltip {
      border-radius: 8px;
      padding: 15px;
      background-color: #131822;
    }

    tooltip label {
      padding: 5px;
      background-color: #131822;
    }
  '';
in
{
  xdg.configFile."waybar/config".text = config;
  xdg.configFile."waybar/style.css".text = style;

  programs.waybar.enable = true;
  programs.waybar.package = stable.waybar;
}
