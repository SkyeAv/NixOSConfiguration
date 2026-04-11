{
  pkgs,
  config,
  ...
}:
{
  # Cross user configuration and programs
  fonts.packages = with pkgs; [
    corefonts
  ];
  # Global environment
  environment = {
    systemPackages = with pkgs; [
      supergfxctl
      openconnect
      xmlstarlet
      coreutils
      asusctl
    ];
    variables = {
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
      CUDA_PATH = "${pkgs.cudatoolkit}";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      LD_LIBRARY_PATH = [
        "/run/current-system/sw/share/nix-ld/lib"
      ];
    };
  };
  programs = {
    bash.enable = true;
    zsh.enable = true;
    # Firefox
    firefox.enable = true;
    thunderbird.enable = true;
    # Links compilers to fhs locations
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        config.boot.kernelPackages.nvidiaPackages.beta
        stdenv.cc.cc.lib
      ];
    };
    # Subuid support
    mtr.enable = true;
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
  };
  # Do not modify this
  system.stateVersion = "25.11";
}
