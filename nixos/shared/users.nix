{ config, ... }:

let
  ifExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users = {
    groups = { };

    users = {
      cheree = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups =
          [
            "wheel"
            "video"
            "audio"
          ]
          ++ ifExist [
            "kvm"
            "docker"
            "podman"
            "adbusers"
            "libvirtd"
            "networkmanager"
          ];
      };
    };
  };
}
