pkgs:
let colors = import ./colors.nix; in {
  enable = true;
  package = pkgs.foot;
  settings = {
    colors = colors.catppuccin;
    shell = "fish";
  };
}
