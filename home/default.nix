{ inputs, ... }:

let
  inherit (inputs) nixpkgs nixpkgs-stable home-manager;

  mkHome =
    { modules
    , user ? "cheree"
    , stateVersion ? "24.05"
    , system ? "x86_64-linux"
    ,
    }:
    let
      stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [ ./shared ] ++ modules;
      extraSpecialArgs = {
        inherit inputs user stateVersion stable;
      };
    };
in
{
  "cheree@calypso" = mkHome {
    modules = [ ./cheree/calypso ];
  };
}
