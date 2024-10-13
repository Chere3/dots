{ inputs, pkgs, ... }:
let inherit (inputs) spicetify-nix; in {
  imports = [ spicetify-nix.homeManagerModules.default ];
  programs.spicetify = let spicePkgs = spicetify-nix.legacyPackages.${pkgs.system}; in {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    enabledExtensions = with spicePkgs.extensions; [
      "shuffle+"
      "beautiful-lyrics"
    ];
  };
}
