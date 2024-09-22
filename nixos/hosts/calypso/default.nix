{ config, disk, ... }:
{
  imports = [
    ./desktop.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  networking.hostName = "Calypso";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  systemd.coredump.enable = true;
}
