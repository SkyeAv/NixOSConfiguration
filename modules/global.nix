{
  pkgs,
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
      CUDA_PATH = "${pkgs.cudatoolkit}";
    };
    sessionVariables = {
      LD_LIBRARY_PATH = [
        "/run/current-system/sw/share/nix-ld/lib"
      ];
      NIXOS_OZONE_WL = "1";
    };
  };
  programs = {
    zsh.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;
    # Links compilers to fhs locations
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ];
    };

  };
  # Do not modify this
  system.stateVersion = "25.11";
}