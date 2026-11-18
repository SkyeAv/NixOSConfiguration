{
  pkgs,
  config,
  ...
}:
{
  # Cross user configuration and programs
  fonts.packages = with pkgs; [
    vista-fonts
    corefonts
  ];
  # Global environment
  environment = {
    systemPackages = with pkgs; [
      wireguard-tools
      speedtest-cli
      supergfxctl
      openconnect
      xmlstarlet
      coreutils
      minikube
      nssTools
      kubectl
      asusctl
      ethtool
      wavemon
      iperf3
      cacert
      iw
    ];
    variables = {
      EXTRA_LDFLAGS = "-L/lib -L${config.hardware.nvidia.package}/lib";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
      CUDA_PATH = "${pkgs.cudatoolkit}";
      EXTRA_CCFLAGS = "-I/usr/include";
    };
    sessionVariables = {
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      NIXOS_OZONE_WL = "1";
      # Do NOT add /run/current-system/sw/share/nix-ld/lib here. It is already
      # exported as NIX_LD_LIBRARY_PATH by programs.nix-ld, and injecting it into
      # every process shadows store RPATHs (e.g. prek's aws-lc libcrypto vs the
      # nix-ld set's OpenSSL 3.5.9 libcrypto -> undefined symbol
      # EVP_aead_aes_128_gcm_tls13).
      LD_LIBRARY_PATH = [
        "${config.hardware.nvidia.package}/lib"
        "${pkgs.ncurses}/lib"
      ];
    };
  };
  programs = {
    # Shells
    bash.enable = true;
    zsh.enable = true;
    # Firefox
    firefox.enable = true;
    # Links compilers to fhs locations
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        config.hardware.nvidia.package
        stdenv.cc.cc.lib
        openssl.dev
        portaudio
      ];
    };
    # Mtr
    mtr.enable = true;
    # GnuPG agent
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # Steam configuration
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    # Ydotool
    ydotool.enable = true;
    # Comma
    nix-index-database.comma.enable = true;
    # AppImage
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run;
    };
  };
  # Do not modify this
  system.stateVersion = "25.11";
}
