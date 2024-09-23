{ lib, pkgs, ... }:
{
  programs = {
    lazygit = {
      enable = true;
      settings = { };
    };

    gh = {
      enable = true;
      extensions = [ pkgs.gh-markdown-preview ];
      settings = {
        version = "1";
        prompt = "enabled";
        git_protocol = "git";
      };
    };

    git = {
      enable = true;
      userName = "chere3";
      userEmail = "71246795+Chere3@users.noreply.github.com";
      extraConfig = {
        color.ui = true;
        core.editor = "nvim";
        gpg = {
          format = "ssh";
          "ssh".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
        };
      };
    };
  };
}
