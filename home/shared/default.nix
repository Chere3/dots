{ pkgs
, inputs
, user
, stateVersion
, ...
}:
{
  imports = [
    ./cli
    ./dev
    ./firefox
  ];

  home = {
    username = user;
    stateVersion = stateVersion;
    homeDirectory = "/home/${user}";
    packages = with pkgs; [ librewolf nixpkgs-fmt onedrive ];
  };

  nixpkgs.overlays = with inputs; [ nur.overlay ];
}
