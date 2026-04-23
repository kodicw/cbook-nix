{ nixpkgs, nixgl, polarbear, jbot, home-manager }:

{
  makeUserConfig = sharedModules: username: extraModules:
    let
      userModule = import ../config/users/${username}.nix;
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit nixgl polarbear jbot; };
      modules = sharedModules ++ extraModules ++ [
        { _module.args = { inherit userModule; }; }
      ];
    };
}