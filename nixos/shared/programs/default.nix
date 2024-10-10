{ lib, pkgs, ... }:
{
  environment = {
    variables.EDITOR = "neovim";
    systemPackages = with pkgs; [
      lsof
      wget
      unrar
      unzip
      p7zip
      home-manager
      nix-output-monitor
      _1password
      _1password-gui
      vim
      kitty
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    etc = {
      "1password/custom_allowed_browsers" = {
        text = ''firefox'';
        mode = "0755";
      };
    };
  };

  programs = {
    git.enable = true;
    light.enable = true;
    dconf.enable = true;
    nano.enable = false;
    less.enable = lib.mkDefault false;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ "cheree" ];
      package = pkgs._1password-gui;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/cheree/dots";
    };

    fish = import ./fish.nix;
  };
}
