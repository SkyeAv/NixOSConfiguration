{
  pkgs,
  ...
}:
{
  # Networking configuration
  networking = {
    hostName = "skyetop";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [
        7070
        4447
        4444
      ];
    };
  };
}
