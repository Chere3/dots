{ pkgs, ... }:
let
  theme = {
    name = "Matcha-dark-sea";
    package = pkgs.matcha-gtk-theme;
  };
in
{
  imports = [ ./apps ];
  home = {
    sessionVariables.GTK_USE_PORTAL = "1";

    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme.name = theme.name;
    font.name = "Ubuntu Nerd Font";
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };

  qt.enable = true;
  qt.platformTheme.name = "qtct";

  xdg.mimeApps.enable = true;
}
