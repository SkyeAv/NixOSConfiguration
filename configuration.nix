{pkgs, lib, config, ...}:
let
  py = pkgs.python13Packages;
  cuda = pkgs.cudaPackages;
  plasma = pkgs.kdePackages;
  nvtop = pkgs.nvtopPackages;
in {
  # HARDWARE CONFIGURATION
  imports = [
    ./hardware-configuration.nix
  ];
  # ENABLE SUBSITUTERS
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.flox.dev"
    ];
    trusted-public-keys = [
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs"
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  # BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # HOSTNAME
  networking.hostName = "skyetop";
  # NETWORKING
  networking.wireless.enable = true;
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
  # HYPERLAND
  programs.hyprland.enable = true;
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
  # TOUCHPAD SUPPORT
  services.libinput.enable = true;
  # USER ACCOUNT
  users.users.skyeav = {
    isNormalUser = true;
    description = "Skye Lane Goetz";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = (with pkgs; [
      bitwarden-desktop
      libreoffice
      imagemagick
      fastfetch
      pciutils
      ripgrep
      discord
      zoxide
      vscode
      neovim
      ffmpeg
      heroic
      gimp2
      slack
      tmux
      htop
      curl
      wget
      lshw
      git
      eza
      fd
      jq
    ]) ++ (with plasma; [
      kdeconnect-kde
      kate
    ]) ++ (with cuda; [
      cudatoolkit
    ]) ++ (with nvtop; [
      nvidia
    ]);
  };
  # FIREFOX INSTALL
  programs.firefox.enable = true;
  # ASUS LAPTOPS
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;
  # ALLOW UNFREE PACKAGES
  nixpkgs.config.allowUnfree = true;
  # OPENGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # ENABLE NVIDIA GPU
  services.xserver.videoDrivers = [
    "modesetting"
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
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  # SYSTEM WIDE PACKAGES
  environment.systemPackages = (with pkgs; [
    supergfxctl
    coreutils
    asusctl
    kitty
  ]);
  # SUID WRAPPERS
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };
  # ENABLE OPENSSH
  services.openssh.enable = true;
  # DISABLE FIREWAL
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
  # NIX VERSION
  system.stateVersion = "25.11";
}
