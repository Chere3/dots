{
  config,
  pkgs,
  lib,
  ...
}:
let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # User packages
  users.users.cheree.packages = with pkgs; [
    foot
    dolphin
    konsole
    fuzzel
    cliphist
    wl-clipboard
    swww
    grim
    slurp
    hyprpicker
    jq
    libnotify
    _1password-gui
    _1password
    qemu
    qemu_kvm
    virt-manager
    OVMF
  ];

  # Environment packages
  environment.systemPackages = with pkgs; [
    vim
    gsettings-desktop-schemas
    libgccjit
    playerctl
    hypridle
    hyprlock
    nix-search-cli
    steam
    steam-run
    libsecret
  ];

  # Font packages
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];

  # Configuration for electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # 1password config
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
      '';
      mode = "0755";
    };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "cheree" ];
  };

  programs.virt-manager.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.seahorse.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
