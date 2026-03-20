{
  pkgs,
  ...
}:
{
  # Home manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.skyeav = {
      home = {
        # Do not modify this
        stateVersion = "25.11";
        # Append vars to path
        sessionPath = [
          "$HOME/.local/bin"
          "$HOME/go/bin"
        ];
      };
      programs = {
        # Zsh configuration
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          # Zsh aliases
          shellAliases = {
            amphetamine = ''systemd-inhibit --what=idle:sleep --why="Presentation" sleep infinity'';
            rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#skyeav";
            skyemac = "ssh skyeav@192.168.1.6";
            zed = "zeditor";
            ps = "procs";
            top = "htop";
            du = "dust";
            ls = "eza";
            df = "duf";
            cd = "z";
          };
          # Oh my zsh configuration
          oh-my-zsh = {
            enable = true;
            plugins = [
              "extract"
              "git"
            ];
            theme = "eastwood";
          };
          history.size = 100;
        };
        # Zoxide integration
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
        # Direnv integration
        direnv = {
          enable = true;
          enableZshIntegration = true;
        };
        # Carapace integration
        carapace = {
          enable = true;
          enableZshIntegration = true;
        };
        # Nushell
        nushell.enable = true;
        # Zed configuration
        zed-editor = {
          enable = true;
          extensions = [
            "toml"
            "nix"
            "dockerfile"
            "proto"
            "lua"
            "elixir"
            "latex"
            "ruff"
            "haskell"
            "julia"
            "nu"
            "nim"
            "perl"
            "ocaml"
            "github-actions"
            "material-icon-theme"
            "ayu-darker"
            "git-firefly"
            "log"
          ];
          installRemoteServer = true;
          userSettings = {
            theme = {
              mode = "dark";
              dark = "Ayu Darker";
              light = "Ayu Darker";
            };
            terminal = {
              shell = "system";
            };
            base_keymap = "VSCode";
          };
        };
        # Neovim configuration
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
        };
        # Kitty configuration
        kitty = {
          enable = true;
          shellIntegration.enableZshIntegration = true;
        };
        # Librewolf
        librewolf.enable = true;
      };
    };
  };
}
