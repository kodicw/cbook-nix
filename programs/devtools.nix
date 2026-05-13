{ pkgs, ... }:

{
  programs.git = {
    enable = false;
    settings = {
      user = {
        name = "Kodi Walls";
        email = "kodicw@gmail.com";
      };
    };
  };

  programs.gh.enable = true;

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
  };

  programs.mcp = {
    enable = true;
    servers = {
      nixos = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "os"
        "shell"
        "uptime"
        "memory"
        "break"
        "colors"
      ];
    };
  };

  fonts.fontconfig.enable = true;
}