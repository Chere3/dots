{ inputs, pkgs, ... }:
let
  calypso = inputs.calypso.packages.${pkgs.system.default};
in
{
  environment = {
    systemPackages = with pkgs; [ calypso ];

    loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
          exec hyprland
      fi
    '';
  };

  programs = {
    virt-manager.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    virtualisation.libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
