{ inputs, pkgs, ... }:
let inherit (inputs) nixvim; in {
  imports = [ nixvim.homeManagerModules.nixvim ];
  programs.nixvim = {
    enable = true;
    colorschemes.catpuccin.enable = true;
    plugins.lualine.enable = true;
  };
}