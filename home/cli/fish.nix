{
  enable = true;
  shellAliases = {
    sho = "home-manager switch";
    rho = "home-manager switch --rollback";
    sno = "sudo nixos-rebuild switch";
  };
  shellInit = ''
    function fish_greeting
    end

    macchina
  '';
}
