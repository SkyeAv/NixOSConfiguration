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
      elmPackages.elm
      signal-desktop
      datafusion-cli
      podman-compose
      cabal-install
      dotnet-sdk_11
      wl-clipboard
      claude-code
      nixfmt-tree
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
      cloudflared
      easyeffects
      bubblewrap
      dosfstools
      micromamba
      alsa-utils
      metasploit
      pkg-config
      python314
      nodejs_24
      wireshark
      fastfetch
      xdg-utils
      libnotify
      julia-bin
      llama-cpp
      # recordbox BROKEN FOR NOW
      opencode
      qpwgraph
      foremost
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
      spotdl
      heroic
      pandoc
      ardour
      logseq
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
      bazel
      vllm
      scdl
      ruff
      nmap
      file
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
      nixd
      nil
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
      R
    ];
  };
}
