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
      # libvirt owns these; NM managing them leaks a 10.0.2.0/24 route from Whonix
      unmanaged = [
        "interface-name:virbr*"
        "interface-name:vnet*"
      ];
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
