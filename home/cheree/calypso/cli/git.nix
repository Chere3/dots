{ lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      gpg = {
        format = "ssh";
        "ssh".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        email = "71246795+Chere3@users.noreply.github.com";
        name = "Chere3";
      };
    };
  };
}
