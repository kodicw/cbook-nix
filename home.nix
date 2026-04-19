{
  config,
  pkgs,
  nixgl,
  polarbear,
  ...
}:

{
  home.username = "kodicw";
  home.homeDirectory = "/home/kodicw";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ghostty
    pkgs.openssh
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    pkgs.gemini-cli
    pkgs.claude-code
    pkgs.opencode
    pkgs.wl-clipboard
    pkgs.fastfetch
    pkgs.rclone
    pkgs.quickemu
    pkgs.jq
    pkgs.mcp-nixos
    pkgs.firefox
    nixgl.packages.x86_64-linux.nixGLIntel
    polarbear.packages.x86_64-linux.nixvim
  ];

  programs.gh.enable = true;

  programs.ghostty = {
    enable = true;
    settings = {
      background = "#000000";
      background-opacity = 0.85;
      window-decoration = false;
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10;
      # command = "${pkgs.nushell}/bin/nu";
    };
  };

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

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Kodi Walls";
        email = "kodicw@gmail.com";
      };
    };
  };

  fonts.fontconfig.enable = true;

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      theme = "default";
      show_startup_tips = false;
      default_layout = "default";
    };
  };

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
        }
        pane
        pane size=1 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
  '';

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    XKB_DEFAULT_LAYOUT = "us";
    XKB_DEFAULT_MODEL = "pc105";
    XKB_DEFAULT_RULES = "evdev";
    XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
    TERMINFO_DIRS = "/usr/share/terminfo:/lib/terminfo:/home/kodicw/.nix-profile/share/terminfo";
    DISPLAY = ":0";
    WAYLAND_DISPLAY = "wayland-0";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XMODIFIERS = "@im=none";
  };

  systemd.user.services.opencode-server = {
    Unit = {
      Description = "opencode: Headless opencode server";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.opencode}/bin/opencode serve --port 8080 --hostname 127.0.0.1";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "rclone: Remote FUSE filesystem for Google Drive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = "/usr/bin/mkdir -p %h/gdrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive: %h/gdrive --vfs-cache-mode full --vfs-cache-max-size 10G --vfs-read-chunk-size 128M --dir-cache-time 72h --buffer-size 128M --poll-interval 15s --allow-other --allow-non-empty";
      ExecStop = "/usr/bin/fusermount -u %h/gdrive";
      Restart = "on-failure";
      RestartSec = "10s";
      RestartPreventExitStatus = "1";
    };
  };

  home.activation = {
    syncCrostiniIcons = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      # Sync applications and icons to paths Crostini Garcon expects
      mkdir -p ~/.local/share/applications ~/.local/share/icons

      # Link icons from nix profile
      if [ -d ~/.nix-profile/share/icons ]; then
        for i in ~/.nix-profile/share/icons/*; do
          ln -sfn "$i" ~/.local/share/icons/$(basename "$i")
        done
      fi

      # Link desktop files from nix profile
      if [ -d ~/.nix-profile/share/applications ]; then
        for f in ~/.nix-profile/share/applications/*.desktop; do
          dest="$HOME/.local/share/applications/$(basename "$f")"
          # Only symlink if it doesn't exist or is already a symlink
          # This prevents overwriting manual files but cleans up old ones
          if [ ! -e "$dest" ] || [ -L "$dest" ] || grep -q "nixGLIntel" "$dest"; then
            ln -sfn "$f" "$dest"
          fi
        done
      fi
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "chromeos";
      };
      modules = [
        "title"
        "separator"
        {
          type = "os";
          format = "chromeos";
        }
        "shell"
        "uptime"
        "memory"
        "break"
        "colors"
      ];
    };
  };

  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false
      }

      def --wrapped nvim [...rest] {
        with-env { VIMINIT: "set keyprotocol= | let &term=&term" } {
          ^nvim ...$rest
        }
      }

      if $nu.is-interactive {
          fastfetch
      }
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nvim = "VIMINIT='set keyprotocol= | let &term=&term' nvim";
    };
    initExtra = ''
      if [[ $- == *i* ]] && [[ $(ps -p $PPID -o comm=) != "nu" ]] && command -v nu >/dev/null; then
        exec nu
      fi
    '';
  };

  # Podman storage configuration on Google Drive
}
