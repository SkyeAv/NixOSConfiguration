{
  pkgs,
  ...
}:
{
  # NixOS user configuration
  users.users.skyeav = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # Group configuration
    extraGroups = [
      "networkmanager"
      "libvirtd"
      "ydotool"
      "render"
      "podman"
      "docker"
      "wheel"
      "input"
      "video"
      "audio"
    ];
    # Ranges for podman
    subGidRanges = [
      {
        count = 65536;
        startGid = 100000;
      }
    ];
    subUidRanges = [
      {
        count = 65536;
        startUid = 100000;
      }
    ];
    # User package configuration
    packages = with pkgs; [
      beamMinimal28Packages.elixir_1_19
      cudaPackages.cudatoolkit
      kdePackages.libkscreen
      nvtopPackages.nvidia
      kdePackages.kzones
      bitwarden-desktop
      telegram-desktop
      datafusion-cli
      podman-compose
      cabal-install
      ghostscript
      whisper-cpp
      texliveFull
      libreoffice
      imagemagick
      pavucontrol
      aircrack-ng
      antigravity
      tor-browser
      virt-viewer
      micromamba
      alsa-utils
      metasploit
      python314
      nodejs_24
      wireshark
      fastfetch
      geekbench
      xdg-utils
      streamrip
      libnotify
      julia_111
      opencode
      qpwgraph
      foremost
      chemtool
      mangohud
      usbutils
      pciutils
      nix-diff
      qrencode
      ripgrep
      zoom-us
      vesktop
      pyright
      nixfmt
      ffmpeg
      libzip
      duckdb
      nimble
      libgcc
      psmisc
      rustup
      pdftk
      rsync
      hping
      unzip
      ocaml
      slack
      cmake
      ninja
      ngrok
      wtype
      procs
      bisq2
      ruff
      nmap
      file
      tmux
      htop
      curl
      opam
      dune
      wget
      lshw
      gawk
      btop
      dust
      love
      tree
      prek
      zlib
      pipx
      perl
      ghc
      duf
      fzf
      zip
      gcc
      git
      eza
      nim
      bat
      bun
      lua
      tor
      dig
      fd
      jq
      go
      gh
      uv
    ];
  };
}