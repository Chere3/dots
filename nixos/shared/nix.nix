{ stateVersion, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "cheree"
      ];
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.stateVersion = stateVersion;
}
