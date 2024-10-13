{ inputs, pkgs, ... }:
{
  imports = [ ./environment ./desktop ./cli ];
  nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

  home.packages = with pkgs; [
    roboto
    source-sans-pro
    (pkgs.nerdfonts.override {
      fonts = [
        "Ubuntu"
        "UbuntuMono"
        "CascadiaCode"
      ];
    })
  ];
}
