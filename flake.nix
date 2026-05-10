{
  description = "abode - Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    polarbear.url = "github:kodicw/polarbear";
    nixspirit.url = "path:/home/kodicw/code/nixspirit";
    bifrost.url = "path:/home/kodicw/code/bifrost";
  };

  outputs = { self, nixpkgs, home-manager, nixgl, polarbear, nixspirit, bifrost, ... }: {
    homeManagerModules = {
      activation-crostini-icons = ./activation/crostini-icons.nix;
      config-home = ./config/home.nix;
      packages = ./packages.nix;
      programs-csharp = ./programs/csharp.nix;
      programs-devtools = ./programs/devtools.nix;
      programs-shells = ./programs/shells.nix;
      programs-terminals = ./programs/terminals.nix;
      session = ./session.nix;
      systemd-opencode-server = ./systemd/opencode-server.nix;
      
      # Combined default module for convenience
      default = { ... }: {
        imports = [
          self.homeManagerModules.activation-crostini-icons
          self.homeManagerModules.config-home
          self.homeManagerModules.packages
          self.homeManagerModules.programs-csharp
          self.homeManagerModules.programs-devtools
          self.homeManagerModules.programs-shells
          self.homeManagerModules.programs-terminals
          self.homeManagerModules.session
          self.homeManagerModules.systemd-opencode-server
          nixspirit.homeManagerModules.default
          nixspirit.homeManagerModules.ai-company
          bifrost.homeManagerModules.default
        ];
      };
    };

    homeConfigurations.kodicw = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit nixgl polarbear nixspirit;
        userModule = import ./config/users/kodicw.nix;
      };
      modules = [
        self.homeManagerModules.default
      ];
    };

    homeConfigurations.droid = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      extraSpecialArgs = {
        inherit nixgl polarbear nixspirit;
        userModule = import ./config/users/droid.nix;
      };
      modules = [
        self.homeManagerModules.default
      ];
    };
  };
}
