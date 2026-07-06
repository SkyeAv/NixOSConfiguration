{
  pkgs,
  inputs,
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
      inputs.agent-of-empires.packages.${pkgs.system}.aoe-with-web
      beamMinimal28Packages.elixir_1_19
      playwright-driver.browsers
      cudaPackages.cudatoolkit
      kdePackages.libkscreen
      nvtopPackages.nvidia
      kdePackages.kzones
      bitwarden-desktop
      telegram-desktop
      llama-cpp-vulkan
      cloudflare-warp
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
      virt-viewer
      cloudflared
      easyeffects
      dosfstools
      alsa-utils
      postgresql
      python314
      nodejs_24
      fastfetch
      xdg-utils
      libnotify
      julia-bin
      opencode
      graphviz
      qpwgraph
      mangohud
      usbutils
      pciutils
      nix-diff
      qrencode
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
      lmms
      scdl
      ruff
      file
      htop
      curl
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
      acpi
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
      ghc
      fd
      jq
      go
      gh
      uv
    ];
  };
}
