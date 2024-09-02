{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Bootloader. 
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";

  # System enviroment
  programs.hyprland.enable = true;
  programs.xwayland.enable = true;

  # Set xdg enviroment
  xdg.autostart.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gtk
  ];

  # Set internalization
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking
  networking.hostName = "Calypso";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Graphics and GPU.
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  # Users and groups
  users.users.cheree.isNormalUser = true;
  users.users.cheree.description = "Cheree";
  users.users.cheree.extraGroups = [
    "networkmanager"
    "wheel"
  ];

  # NixOs garbage auto-collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  # Enable the nix command experimental feature
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes) ''
    experimental-features = nix-command flakes
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
