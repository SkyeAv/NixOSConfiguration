{pkgs, inputs, lib, config, ...}:
let
  code-extensions = pkgs.vscode-extensions;
  beam = pkgs.beamMinimal28Packages;
  py = pkgs.python313Packages;
  nvtop = pkgs.nvtopPackages;
  caml = pkgs.ocamlPackages;
  plasma = pkgs.kdePackages;
  cuda = pkgs.cudaPackages;
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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.flox.dev"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs"
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
  ];
  # OVERRIDES
  nixpkgs.config.packageOverrides = pkgs: {
    libsForQt515 = pkgs.libsForQt5;
  };
  # CATCHY OS KERNEL
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
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
    "nvidia.NVreg_UsePageAttributeTable=1"
    "rd.systemd.show_status=false"
    "acpi_backlight=video"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "amd_pstate=guided"
    "loglevel=3"
    "nowatchdog"
    "splash"
    "quiet"
  ];
  # KERNEL MODULES
  boot.kernelModules = [
    "uvcvideo"
    "k10temp"
    "nct6775"
    "uinput"
    "btusb"
  ];
  # HOSTNAME
  networking.hostName = "skyetop";
  # NETWORKING
  networking.networkmanager.enable = true;
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
    wireplumber.enable = true;
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
  # USER ACCOUNT
  users.users.skyeav = {
    isNormalUser = true;
    description = "Skye Lane Goetz";
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "input"
    ];
    packages = (with pkgs; [
      bitwarden-desktop
      wayland-scanner
      datafusion-cli
      brightnessctl
      texliveFull
      libreoffice
      imagemagick
      pavucontrol
      alsa-utils
      fastfetch
      geekbench
      stress-ng
      mangohud
      usbutils
      pciutils
      goverlay
      ripgrep
      discord
      glmark2
      zoom-us
      reaper
      zoxide
      neovim
      ffmpeg
      heroic
      duckdb
      nimble
      unzip
      ocaml
      gimp2
      slack
      cmake
      ninja
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
      git
      eza
      nim
      bat
      fd
      jq
    ]) ++ (with py; [
      sentence-transformers
      sqlite-utils
      scikit-learn
      transformers
      onnxruntime
      matplotlib
      setuptools
      playwright
      accelerate
      biopython
      rapidfuzz
      ipykernel
      lightgbm
      seaborn
      optimum
      fastapi
      pyexcel
      pyyaml
      duckdb
      orjson
      polars
      mkdocs
      pandas
      python
      flake8
      scipy
      sympy
      torch
      typer
      numpy
      wheel
      zstd
      shap
      peft
      pip
    ]) ++ (with caml; [
      cmdliner
    ]) ++ (with beam; [
      elixir
    ]) ++ (with plasma; [
      kdeconnect-kde
      kate
    ]) ++ (with cuda; [
      cudatoolkit
    ]) ++ (with nvtop; [
      nvidia
    ]);
  };
  # BASHRC
  programs.bash = {
    enable = true;
    shellAliases = {
      top = "htop";
      vim = "nvim";
      vi = "nvim";
      ls = "eza";
    };
  };
  # FIREFOX INSTALL
  programs.firefox.enable = true;
  # ASUS LAPTOPS
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;
  # SSD TRIM
  services.fstrim.enable = true;
  # NIX LD FOR BINARIES
  programs.nix-ld.enable = true;
  # ALLOW UNFREE PACKAGES
  nixpkgs.config.allowUnfree = true;
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
    coreutils
    asusctl
  ]);
  # BETTER MEMORY PRESSURE
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };
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
  # DOCKER ENABLE
  virtualisation.docker.enable = true;
  # MAX CPU PREFORMANCE
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
  # ADD ZRAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  # ACPILIGHT
  hardware.acpilight.enable = true;
  # FONTS
  fonts.packages = (with pkgs; [
    corefonts
  ]);
  # HOME MANAGER
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.skyeav = {
    home.stateVersion = "25.11";
    # VSCODE INSTALL
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      profiles.default.extensions = (with code-extensions; [
        shd101wyy.markdown-preview-enhanced
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode-remote.remote-ssh-edit
        ms-toolsai.jupyter-renderers
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one
        aaron-bond.better-comments
        ms-vscode.remote-explorer
        ms-toolsai.jupyter-keymap
        tamasfe.even-better-toml
        ocamllabs.ocaml-platform
        johnpapa.vscode-peacock
        james-yu.latex-workshop
        mechatroner.rainbow-csv
        oderwat.indent-rainbow
        esbenp.prettier-vscode
        ms-toolsai.jupyter
        jnoortheen.nix-ide
        redhat.vscode-yaml
        ms-python.python
        sdras.night-owl
        eamodio.gitlens
        zainchen.json
      ]);
    };
  };
  # VSCODE USE WAYLAND
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # NIX VERSION
  system.stateVersion = "25.11";
}
