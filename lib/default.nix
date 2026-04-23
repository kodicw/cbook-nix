{ nixpkgs, nixgl, polarbear, jbot }:

{
  pkgs = nixpkgs.legacyPackages."x86_64-linux";
  extraSpecialArgs = { inherit nixgl polarbear jbot; };

  makeUserConfig = sharedModules: username: extraModules:
    let
      userModule = import ../config/users/${username}.nix;
    in
    nixpkgs.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = extraSpecialArgs;
      modules = sharedModules ++ extraModules ++ [
        { _module.args = { inherit userModule; }; }
      ];
    };
}