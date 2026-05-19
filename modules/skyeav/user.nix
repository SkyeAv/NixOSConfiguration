{
  pkgs,
  ...
}:
{
  # NixOS user configuration
  users.users.skyeav = {
    description = "Skye Lane Goetz";
    isNormalUser = true;
    shell = pkgs.zsh;
    # Group configuration
    extraGroups = [
      "networkmanager"
      "libvirtd"
      "comfyui"
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
      playwright-driver.browsers
      cudaPackages.cudatoolkit
      kdePackages.libkscreen
      nvtopPackages.nvidia
      rPackages.tidyverse
      kdePackages.kzones
      bitwarden-desktop
      telegram-desktop
      llama-cpp-vulkan
      elmPackages.elm
      signal-desktop
      podman-compose
      cabal-install
      wl-clipboard
      claude-code
      nixfmt-tree
      ghostscript
      whisper-cpp
      texliveFull
      libreoffice
      imagemagick
      pavucontrol
      antigravity
      tor-browser
      virt-viewer
      cloudflared
      easyeffects
      dosfstools
      alsa-utils
      python314
      nodejs_24
      fastfetch
      xdg-utils
      libnotify
      julia-bin
      # recordbox BROKEN FOR NOW
      opencode
      qpwgraph
      mangohud
      usbutils
      pciutils
      nix-diff
      qrencode
      # rstudio BROKEN FOR NOW
      gnumake
      ripgrep
      zoom-us
      vesktop
      pyright
      awscli2
      heroic
      pandoc
      ffmpeg
      libzip
      duckdb
      nimble
      libgcc
      psmisc
      rustup
      drawio
      mixxx
      pdftk
      rsync
      unzip
      slack
      cmake
      ninja
      wtype
      procs
      scdl
      ruff
      file
      htop
      curl
      dune
      wget
      lshw
      gawk
      btop
      dust
      tree
      prek
      zlib
      perl
      nixd
      nil
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
      ghc
      fd
      jq
      go
      gh
      uv
      R
    ];
  };
}
