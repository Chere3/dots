{
  pkgs,
  config,
  disk,
  ...
}:
{
  imports = [
    ./desktop.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  networking.hostName = "calypso";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };

  systemd.coredump.enable = true;
}
