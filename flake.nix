{
  description = "Cheree's configuration at Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:mic92/sops-nix";
    disko.url = "github:nix-community/disko";

    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    spicetify-nix.url = "github:gerg-l/spicetify-nix";
  };

  outputs =
    inputs@{ ... }:
    {
      homeConfigurations = import ./home { inherit inputs; };
      nixosConfigurations = import ./nixos { inherit inputs; };
    };

  nixConfig = { };

}


