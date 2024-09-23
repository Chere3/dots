{ pkgs, ... }:
{
  imports = [ ./git.nix ];
  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        rounded_corners = true;
        theme_background = false;
        color_theme = "tokyo_storm";
      };
    };

    eza.enable = true;
    taskwarrior.enable = true;

    yazi = {
      enable = true;
      enableBashIntegration = true;
      keymap = { };
      settings = { };
      theme = { };
    };

    home.packages = with pkgs; [ ];
  };
}
