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
      # MT7925 sleeps between DTIM beacons otherwise; costs ~25ms of latency jitter
      wifi.powersave = false;
      dns = "systemd-resolved";
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
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
  # DHCP hands out a dead secondary resolver (205.171.2.65, times out at 6s).
  # glibc walks nameservers in order with no memory of failures, so every miss
  # the router drops costs two 5s timeouts -- page loads were stalling 10-35s.
  # resolved caches, tracks per-server failure, and does split-DNS for the VPN.
  services.resolved = {
    enable = true;
    settings.Resolve = {
      FallbackDNS = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      DNSOverTLS = false;
      DNSSEC = false;
    };
  };
  # Without an explicit country the card boots into regdom 00, where every 5GHz
  # channel is no-IR and 6GHz is disabled outright
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
    options mt7925e disable_aspm=1
  '';
  # The modprobe param gets shadowed by COUNTRY_IE hints from neighboring APs
  systemd.services.wireless-regdom = {
    description = "Set wireless regulatory domain";
    wantedBy = [ "multi-user.target" ];
    after = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iw}/bin/iw reg set US";
    };
  };
}
