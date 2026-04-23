{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    polarbear.url = "github:kodicw/polarbear";
    jbot.url = "path:/home/kodicw/code/jbot";
  };

  outputs = { nixpkgs, home-manager, nixgl, polarbear, jbot, ... }:
    let
      lib = import ./lib {
        inherit nixpkgs home-manager nixgl polarbear jbot;
      };

      sharedModules = [
        ./config/home.nix
        ./packages.nix
        ./programs/shells.nix
        ./programs/terminals.nix
        ./programs/devtools.nix
        ./session.nix
        ./systemd/opencode-server.nix
        ./systemd/rclone-gdrive.nix
        ./activation/crostini-icons.nix
      ];

      kodicwExtraModules = [
        jbot.homeManagerModules.ai-company
      ];
    in
    {
      homeConfigurations = {
        kodicw = lib.makeUserConfig sharedModules "kodicw" kodicwExtraModules;
      };
    };
}