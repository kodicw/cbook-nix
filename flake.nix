{
  description = "Home Manager configuration of charles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    polarbear.url = "github:kodicw/polarbear";
  };

  outputs = { nixpkgs, home-manager, nixgl, polarbear, ... }: {
    homeConfigurations."charles" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit nixgl polarbear; };

      modules = [ ./home.nix ];
    };
  };
}
