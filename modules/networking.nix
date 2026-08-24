{
  pkgs,
  ...
}:
{
  # Networking configuration
  networking = {
    hostName = "skyetop";
    # Prefer Cloudflare globally; link DNS from DHCP still wins per-link so
    # corporate and VPN split-DNS keep working at work.
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager = {
      enable = true;
      # MT7925 sleeps between DTIM beacons otherwise; costs ~25ms of latency jitter
      wifi.powersave = false;
      dns = "systemd-resolved";
      plugins = with pkgs; [ networkmanager-openconnect ];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        7070
        4447
        4444
      ];
    };
  };
}
