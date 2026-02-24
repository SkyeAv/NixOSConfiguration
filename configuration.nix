{pkgs, inputs, lib, config, ...}:
let
  code-extensions = pkgs.vscode-extensions;
  beam = pkgs.beamMinimal28Packages;
  py = pkgs.python313Packages;
  nvtop = pkgs.nvtopPackages;
  caml = pkgs.ocamlPackages;
  plasma = pkgs.kdePackages;
  cuda = pkgs.cudaPackages;
  np = pkgs.nodePackages;
  cuda-py = pkgs.python313.override {
    packageOverrides = self: super: {
      torch = super.torch-bin;
      torchvision = super.torchvision-bin;
      torchaudio = super.torchaudio-bin;
    };
  };
in {
  # HARDWARE CONFIGURATION
  imports = [
    ./hardware-configuration.nix
  ];
  # ENABLE SUBSITUTERS
  nix.settings = {
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0;
    download-buffer-size = 4294967296;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://cuda-maintainers.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs"
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
  # GARBAGE COLLECTOR
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # BOOTLOADER
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # OVERLAYS
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    (final: prev: {
      python313Packages = prev.python313Packages // {
        torch = prev.python313Packages.torch-bin;
        torchvision = prev.python313Packages.torchvision-bin;
        torchaudio = prev.python313Packages.torchaudio-bin;
      };
    })
  ];
  # CATCHY OS KERNEL
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
  # ANANICY PROCESS PRIORITY
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };
  # ENABLE SPECIAL BOOT
  boot.plymouth.enable = true;
  # MAKE BOOT QUIETER
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  # KERNEL PARAMS
  boot.kernelParams = [
    "rd.systemd.show_status=false"
    "transparent_hugepage=always"
    "numa_balancing=disable"
    "acpi_backlight=native"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "amd_pstate=active"
    "loglevel=3"
    "nowatchdog"
    "splash"
    "quiet"
  ];
  # KERNEL MODULES
  boot.kernelModules = [
    "asus_wmi"
    "uvcvideo"
    "k10temp"
    "nct6775"
    "uinput"
    "btusb"
    "jc42"  
  ];
  # SYSCTL PARAMS
  boot.kernel.sysctl = {
    "vm.nr_overcommit_hugepages" = 256;
    "vm.compaction_proactiveness" = 0;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;
    "vm.overcommit_memory" = 1;
    "vm.nr_hugepages" = 512;
    "vm.page-cluster" = 3;
    "vm.dirty_ratio" = 15;
    "vm.swappiness" = 10;
  };
  # NVIDIA OPTIMIZATIONS
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords="PeerMappingOverride=1"
    options nvidia NVreg_UsePageAttributeTable=1
    options nvidia NVreg_EnableGpuFirmware=1
    options nvidia_drm modeset=1 fbdev=1
  '';
  # HOSTNAME
  networking.hostName = "skyetop";
  # NETWORKING
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [
    pkgs.networkmanager-openconnect
  ];
  # TIMEZONE
  time.timeZone = "America/Los_Angeles";
  # LOCATION
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # X11 COMPATABILITY
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # KDE PLASMA
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # CUPS PRINT SUPPORT
  services.printing.enable = true;
  # PIPEWIRE SOUND SUPPORT
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-suspend" = {
          "monitor.alsa.rules" = [{
            matches = [{"node.name" = "~alsa_output.*";}];
            actions.update-props = {"session.suspend-timeout-seconds" = 0;};
          }];
        };
        "50-disable-bluez-seat-monitoring" = {
          "wireplumber.profiles" = {
            main = {"monitor.bluez.seat-monitoring" = "disabled";};
          };
        };
      };
    };
  };
  # ENABLE FIRMWARE
  hardware.enableAllFirmware = true;
  # BLUETOOTH SUPPORT
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy.AutoEnable = true;
    };
  };
  # TOUCHPAD SUPPORT
  services.libinput.enable = true;
  # BETTER MEMORY PRESSURE
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };
  # USER ACCOUNT
  users.users.skyeav = {
    isNormalUser = true;
    description = "Skye Lane Goetz";
    extraGroups = [
      "networkmanager"
      "ydotool"
      "render"
      "podman"
      "docker"
      "wheel"
      "input"
      "video"
      "audio"
    ];
    subGidRanges = [{ count = 65536; startGid = 100000; }];
    subUidRanges = [{ count = 65536; startUid = 100000; }];
    packages = (with pkgs; [
      bitwarden-desktop
      telegram-desktop
      wayland-scanner
      datafusion-cli
      podman-desktop
      podman-compose
      brightnessctl
      appimage-run
      wl-clipboard
      whisper-cpp
      texliveFull
      libreoffice
      imagemagick
      pavucontrol
      claude-code
      openconnect
      aircrack-ng
      antigravity
      alsa-utils
      pkg-config
      metasploit
      wireshark
      fastfetch
      distrobox
      geekbench
      stress-ng
      xdg-utils
      streamrip
      goose-cli
      libnotify
      qpwgraph
      foremost
      lmstudio
      chemtool
      mangohud
      usbutils
      pciutils
      goverlay
      nix-diff
      qrencode
      ripgrep
      glmark2
      zoom-us
      vesktop
      chatbox
      xdotool
      pyright
      pylint
      reaper
      zoxide
      neovim
      ffmpeg
      libzip
      heroic
      duckdb
      nimble
      libgcc
      psmisc
      pdftk
      rsync
      hping
      tiled
      unzip
      ocaml
      gimp2
      slack
      cmake
      ninja
      ngrok
      wtype
      procs
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
      vpnc
      btop
      dust
      love
      tree
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
      dig
      fd
      jq
      go
      gh
    ]) ++ [(cuda-py.withPackages (ps: with ps; [
      sentence-transformers
      backports-zstd
      sentencepiece
      uncertainties
      sqlite-utils
      scikit-learn
      transformers
      jupyter-core
      transformers
      torchvision
      safetensors
      onnxruntime
      trafilatura
      ruamel-yaml
      statsmodels
      tokenizers
      matplotlib
      sqlalchemy
      setuptools
      playwright
      accelerate
      torchaudio
      biopython
      rapidfuzz
      ipykernel
      fastexcel
      torchsde
      notebook
      networkx
      fastmcp
      alembic
      aiohttp
      seaborn
      optimum
      fastapi
      pyexcel
      pyarrow
      pillow
      pyyaml
      duckdb
      orjson
      polars
      mkdocs
      pandas
      polars
      flake8
      einops
      psutil
      plotly
      pyvis
      lmfit
      torch
      scipy
      sympy
      typer
      numpy
      wheel
      tqdm
      yarl
      lxml
      zstd
      shap
      peft
      pipx
      pip
      av
    ]))] ++ (with caml; [
      cmdliner
    ]) ++ (with beam; [
      elixir
    ]) ++ (with plasma; [
      kdeconnect-kde
      libkscreen
      kzones
      kate
    ]) ++ (with cuda; [
      cudatoolkit
    ]) ++ (with nvtop; [
      nvidia
    ]) ++ (with np; [
      nodejs
    ]) ++ [(pkgs.writeShellScriptBin "opencode" ''
      export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec ${pkgs.opencode}/bin/opencode "$@"
    '')];
  };
  # ENVIRONMENT VARIABLES
  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
  };
  # FIREFOX INSTALL
  programs.firefox.enable = true;
  # ASUS LAPTOPS
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;
  # SSD TRIM
  services.fstrim.enable = true;
  # OLLAMA DAEMON
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_KV_CACHE_TYPE = "q4_0";
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KEEP_ALIVE = "-1";
    };
  };
  # FCRON
  services.fcron = {
    enable = true;
    systab = ''
      # RESET VIBE CODE LIMITS
      @ 6:00 & bootrun(true) echo "Hi" | claude --print
      @ 6:00 & bootrun(true) opencode run "Hi"
      # OS BACKUP TO LOCAL SERVER
      @ 20:00 & bootrun(true) rsync -av --no-compress --exclude="Backups" --delete /home/skyeav/ skyeav@192.168.1.6:/Users/skyeav/Backups/SkyeTop
    '';
  };
  # NIX LD FOR BINARIES
  programs.nix-ld.enable = true;
  # ALLOW UNFREE PACKAGES
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  # OPENGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
  # ENABLE NVIDIA GPU
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:100:0:0";
      amdgpuBusId = "PCI:101:0:0";
    };
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  # SYSTEM WIDE PACKAGES
  environment.systemPackages = (with pkgs; [
    supergfxctl
    openconnect
    xmlstarlet
    coreutils
    asusctl
  ]);
  # SUID WRAPPERS
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # ENABLE OPENSSH
  services.openssh.enable = true;
  # DISABLE FIREWALL
  networking.firewall.enable = false;
  # STEAM INSTALL
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  hardware.steam-hardware.enable = true;
  # PODMAN ENABLE
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # POWER PROFILES DAEMON
  services.power-profiles-daemon.enable = true;
  # ADD ZRAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 40;
  };
  # ACPILIGHT
  hardware.acpilight.enable = true;
  # FONTS
  fonts.packages = (with pkgs; [
    corefonts
  ]);
  # YDOTOOL
  programs.ydotool.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="ydotool", OPTIONS+="static_node=uinput"
  '';
  # USER DEFINED SERVICES
  systemd.user.services = {
    hyprvoice = {
      description = "Hyprvoice service";
      wantedBy = ["default.target"];
      path = [
        "/etc/profiles/per-user/skyeav"
        "/run/current-system/sw"
        "/etc/systemd/system"
      ];
      serviceConfig.ExecStart = "%h/go/bin/hyprvoice serve";
    };
    ydotool = {
      description = "Ydotool service";
      wantedBy = ["default.target"];
      path = [
        "/etc/profiles/per-user/skyeav"
        "/run/current-system/sw"
        "/etc/systemd/system"
      ];
      serviceConfig.ExecStart = "${pkgs.ydotool}/bin/ydotoold";
    };
  };
  # HOME MANAGER
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.skyeav = {
    home.stateVersion = "25.11";
    # APPEND TO PATH
    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
    # BASH INSTALL
    programs.bash = {
      enable = true;
      shellAliases = {
        amphetamine = "systemd-inhibit --what=idle:sleep --why='Presentation' sleep infinity";
        os-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#skyeav";
        ssh-skyemac = "ssh skyeav@192.168.1.6";
        ps = "procs";
        top = "htop";
        vim = "nvim";
        vi = "nvim";
        du = "dust";
        ls = "eza";
        df = "duf";
        cd = "z";
      };
    };
    # ZOXIDE INSTALL
    programs.zoxide = {
      enable = true;
      enableBashIntegration= true;
    };
    # DIRENV INSTALL
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
    };
    # VSCODE INSTALL
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default.extensions = (with code-extensions; [
        # MANYALLY SET MATERIAL ICON THEME AND NIGHT OWL THEME
        # MANUALLY ADD WINDSURF AND NIMLANG
        shd101wyy.markdown-preview-enhanced
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode-remote.remote-ssh-edit
        github.vscode-github-actions
        ms-toolsai.jupyter-renderers
        elixir-lsp.vscode-elixir-ls
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one
        aaron-bond.better-comments
        pkief.material-icon-theme
        ms-vscode.remote-explorer
        ms-toolsai.jupyter-keymap
        tamasfe.even-better-toml
        ocamllabs.ocaml-platform
        grapecity.gc-excelviewer
        johnpapa.vscode-peacock
        james-yu.latex-workshop
        mechatroner.rainbow-csv
        oderwat.indent-rainbow
        esbenp.prettier-vscode
        ms-vscode.live-server
        usernamehw.errorlens
        ms-toolsai.jupyter
        jnoortheen.nix-ide
        redhat.vscode-yaml
        ms-pyright.pyright
        ms-python.python
        sdras.night-owl
        eamodio.gitlens
        zainchen.json
        sumneko.lua
        golang.go
      ]);
    };
  };
  # VSCODE USE WAYLAND
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # NIX VERSION
  system.stateVersion = "25.11";
}
