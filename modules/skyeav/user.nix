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
      kdePackages.kzones
      bitwarden-desktop
      telegram-desktop
      datafusion-cli
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
      aircrack-ng
      antigravity
      tor-browser
      virt-viewer
      cloudflared
      micromamba
      alsa-utils
      metasploit
      recordbox
      python314
      nodejs_24
      wireshark
      fastfetch
      geekbench
      xdg-utils
      libnotify
      julia-bin
      opencode
      qpwgraph
      foremost
      chemtool
      mangohud
      usbutils
      pciutils
      nix-diff
      qrencode
      rstudio
      openssl
      gnumake
      ripgrep
      zoom-us
      vesktop
      pyright
      awscli2
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
