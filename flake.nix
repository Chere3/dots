{
  description = "Cheree's configuration at Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:mic92/sops-nix";
    disko.url = "github:nix-community/disko";
  };

  outputs =
    inputs@{ ... }:
    {
      homeConfigurations = import ./home { inherit inputs; };
      nixosConfigurations = import ./nixos { inherit inputs; };
    };

  nixConfig = { };

}
