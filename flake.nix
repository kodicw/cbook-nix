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
        jbot.homeManagerModules.ai-company
      ];

      lib = nixpkgs.lib;

      makeUser = username: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { inherit nixgl polarbear jbot; };
        modules = sharedModules ++ [
          {
            _module.args = {
              userModule = import ./config/users/${username}.nix;
            };
          }
          ({ config, ... }: {
            imports = [ config._module.args.userModule ];
          })
        ];
      };
    in
    {
      homeConfigurations = {
        kodicw = makeUser "kodicw";
      };
    };
}