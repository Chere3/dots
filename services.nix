{config, pkgs, ...}:
{
    # X11 keymap
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.variant = "altgr-intl";

    # Gnome keyring.
    services.gnome.gnome-keyring.enable = true;


    # Bluetooth
    services.blueman.enable = true;

    # Bluetooth media controls
    systemd.user.services.mpris-proxy = {
        description = "Mpris proxy";
        after = [ "network.target" "sound.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

    # Start pipewire and rtkit
    security.rtkit.enable = true;
    # Bluetooth audio
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.extraConfig = {
            "monitor.bluez.properties" = {
                "bluez5.enable-sbc-xq" = true;
                "bluez5.enable-msbc" = true;
                "bluez5.enable-hw-volume" = true;
                "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
                };
            };
        };
}
