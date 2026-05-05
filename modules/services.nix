{
  pkgs,
  ...
}:
{
  # Service and daemon settings
  services = {
    # Automatic nicing
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    # X11 compatability
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = [
        "amdgpu"
        "nvidia"
      ];
    };
    # Plasma services
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    # Printing
    printing.enable = true;
    # Audio settings
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    # Touchpad support
    libinput.enable = true;
    # EarlyOOM
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
    };
    # Labtop and SSD
    asusd.enable = true;
    supergfxd.enable = true;
    fstrim.enable = true;
    # Ollama
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      environmentVariables = {
        OLLAMA_KV_CACHE_TYPE = "q8_0";
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };
    # Fcrontab
    fcron = {
      enable = true;
      systab = ''
        # OS BACKUP TO LOCAL SERVER
        @ 20:00 & bootrun(true) rsync -av --no-compress --exclude="Backups" --delete /home/skyeav/ skyeav@192.168.1.6:/Users/skyeav/Backups/SkyeTop
      '';
    };
    # I2P support
    i2pd = {
      enable = true;
      address = "0.0.0.0";
      proto = {
        http.enable = true;
        socksProxy.enable = true;
        httpProxy.enable = true;
      };
    };
    # SSH
    openssh.enable = true;
    # Power profiles daemon
    power-profiles-daemon.enable = true;
    # Udev rules
    udev = {
      packages = with pkgs; [
        mixxx
      ];
      extraRules = ''
        KERNEL=="uinput", MODE="0660", GROUP="ydotool", OPTIONS+="static_node=uinput"
      '';
    };
  };
  # Systemd
  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
    };
    # User services
    user.services = {
      ydotool = {
        description = "ydotoold daemon";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path=%t/ydotoold.socket";
          Restart = "always";
        };
      };
      hyprvoice = {
        description = "Hyprvoice service";
        wantedBy = [ "default.target" ];
        after = [ "ydotool.service" ];
        requires = [ "ydotool.service" ];
        path = [
          "/etc/profiles/per-user/skyeav"
          "/run/current-system/sw"
        ];
        serviceConfig = {
          ExecStart = "%h/go/bin/hyprvoice serve";
          Environment = "YDOTOOL_SOCKET=%t/ydotoold.socket";
          Restart = "on-failure";
        };
      };
    };
  };
  # Security configuration
  security = {
    # Rtkit for audio
    rtkit.enable = true;
    # Polkit for VMs
    polkit.enable = true;
  };
}
