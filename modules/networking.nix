{
  pkgs,
  ...
}:
{
  # Networking configuration
  networking = {
    hostName = "skyetop";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      dns = "systemd-resolved";
      plugins = with pkgs; [ networkmanager-openconnect ];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        18081
        16123
        16124
        16125
      ];
    };
  };
}
