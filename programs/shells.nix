{ pkgs, ... }:

{
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

  programs.television = {
    enable = true;
    enableNushellIntegration = true;
    channels = {
      files = {
        metadata = {
          name = "files";
        };
        source = {
          command = "fd --type f";
        };
        keybindings = {
          enter = "actions:open-nvim";
        };
        "actions.open-nvim" = {
          command = "nvim {}";
          mode = "execute";
        };
      };
    };
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

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;

  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
