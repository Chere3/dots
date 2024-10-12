pkgs:
let colors = imports ./colors.nix; in {
  enable = true;
  package = pkgs.foot;
  settings = {
    colors = colors.catppuccin;
    shell = "fish";
  };
}
