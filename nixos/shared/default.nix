{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./users.nix
    ./services.nix

    ./programs
  ];

  boot.loader = {
    timeout = 0;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      canTouchEfiVariables = true;
    };
  };

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  security = {
    polkit.enable = true;
    rtkit.enable = true;

    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [
            "root"
            "cheree"
          ];
          keepEnv = true;
          noPass = true;
        }
      ];
    };
  };
}
