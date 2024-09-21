{ config, disk, ... }:
{
  imports = [ ];

  networking.hostName = "Calypso";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
