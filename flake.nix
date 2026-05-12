{
  description = "abode - Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polarbear.url = "github:kodicw/polarbear";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      polarbear,
      ...
    }:
    {
      homeManagerModules = {
        activation-crostini-icons = ./activation/crostini-icons.nix;
        config-home = ./config/home.nix;
        packages = ./packages.nix;
        programs-csharp = ./programs/csharp.nix;
        programs-devtools = ./programs/devtools.nix;
        programs-shells = ./programs/shells.nix;
        programs-terminals = ./programs/terminals.nix;
        programs-ai = ./programs/ai.nix;
        session = ./session.nix;
        systemd-opencode-server = ./systemd/opencode-server.nix;

        # Combined default module for convenience
        default =
          { ... }:
          {
            imports = [
              self.homeManagerModules.activation-crostini-icons
              self.homeManagerModules.config-home
              self.homeManagerModules.packages
              self.homeManagerModules.programs-csharp
              self.homeManagerModules.programs-devtools
              self.homeManagerModules.programs-shells
              self.homeManagerModules.programs-terminals
              self.homeManagerModules.programs-ai
              self.homeManagerModules.session
            ];
          };
      };

      homeConfigurations.kodicw = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit polarbear;
          userModule = import ./config/users/kodicw.nix;
        };
        modules = [
          self.homeManagerModules.default
          (import /home/kodicw/code/nixspirit).homeManagerModules.default
          (import /home/kodicw/code/nixspirit).homeManagerModules.ai-company
          (import /home/kodicw/code/bifrost).homeManagerModules.default
        ];
      };

      homeConfigurations.charles = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit polarbear;
          userModule = import ./config/users/charles.nix;
        };
        modules = [
          self.homeManagerModules.default
        ];
      };

      homeConfigurations.droid = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit polarbear;
          userModule = import ./config/users/droid.nix;
        };
        modules = [
          self.homeManagerModules.default
        ];
      };
    };
}
