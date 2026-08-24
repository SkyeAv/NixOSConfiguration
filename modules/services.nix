{
  pkgs,
  lib,
  ...
}:
{
  # Service and daemon settings
  services = {
    # Automatic nicing
    ananicy = {
      enable = true;
      # 1.2.0 relies on <cstring> arriving transitively; newer libstdc++ dropped it,
      # so std::strerror/std::memset no longer resolve. Redundant includes are free.
      package = pkgs.ananicy-cpp.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          find src -name '*.cpp' -exec sed -i '1i #include <cstring>\n#include <cstdint>' {} +
        '';
      });
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    # X11 compatibility
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
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # Touchpad support
    libinput.enable = true;
    # EarlyOOM
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
    };
    # Laptop and SSD
    asusd.enable = true;
    supergfxd.enable = true;
    fstrim.enable = true;
    # Ollama
    ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        OLLAMA_KV_CACHE_TYPE = "q8_0";
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };
    # Spark standalone cluster; master and worker both stay on loopback.
    # conf/ in the store ships only .template files, so every setting here has
    # to arrive as an environment variable rather than via spark-env.sh.
    spark = {
      master = {
        enable = true;
        bind = "127.0.0.1";
        extraEnvironment = {
          SPARK_MASTER_WEBUI_PORT = "8180";
          SPARK_DAEMON_MEMORY = "1g";
        };
      };
      worker = {
        enable = true;
        master = "127.0.0.1:7077";
        # 15g is the executor heap, not the ceiling: the JVM adds ~10% off-heap
        # on top of whatever executors are told they have, and the worker daemon
        # costs another ~1.3g. That lands the cgroup at the 18G cap set below.
        extraEnvironment = {
          SPARK_WORKER_WEBUI_PORT = "8181";
          SPARK_WORKER_MEMORY = "15g";
          SPARK_DAEMON_MEMORY = "1g";
          SPARK_WORKER_CORES = "16";
        };
      };
    };
    # Fcrontab
    fcron = {
      enable = true;
      systab = ''
        # PLACEHOLDER UNTIL HOME SERVER SETUP
      '';
    };
    # SSH
    openssh.enable = true;
    # DNS resolution; FallbackDNS only applies when no link supplies its own
    resolved = {
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
    # Power profiles daemon
    power-profiles-daemon.enable = true;
    # Udev rules
    udev.packages = with pkgs; [
      mixxx
    ];
  };
  # Systemd
  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      wireless-regdom = {
        description = "Set wireless regulatory domain";
        wantedBy = [ "multi-user.target" ];
        after = [ "NetworkManager.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.iw}/bin/iw reg set US";
        };
      };
      # Spark is on demand, not at boot: two idle JVMs cost ~2.5G for nothing.
      # Start the cluster with `systemctl start spark-worker`, which pulls the
      # master up with it; `systemctl stop spark-master` tears both back down.
      spark-master = {
        wantedBy = lib.mkForce [ ];
        serviceConfig = {
          CPUQuota = "100%";
          MemoryMax = "2G";
          CPUWeight = 50;
          IOWeight = 50;
        };
      };
      # Hard-cap Spark at 16 cores and 20G total RSS. This cgroup holds the
      # executor pool; the master above is only a scheduler and stays tiny.
      # CPUWeight/IOWeight keep the desktop ahead of Spark under contention.
      spark-worker = {
        wantedBy = lib.mkForce [ ];
        wants = [ "spark-master.service" ];
        after = [ "spark-master.service" ];
        partOf = [ "spark-master.service" ];
        serviceConfig = {
          MemoryHigh = "17G";
          CPUQuota = "1600%";
          MemoryMax = "18G";
          CPUWeight = 50;
          IOWeight = 50;
        };
      };
    };
    # User services
    user.services = {
      # Kache content-addressed build cache daemon (cargo-installed; not in nixpkgs)
      kache = {
        description = "Kache build cache daemon";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "%h/.cargo/bin/kache daemon run";
          Environment = "KACHE_LOG=kache=info";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
      # Hyprvoice push-to-talk dictation (go-installed; not in nixpkgs)
      hyprvoice = {
        description = "Hyprvoice service";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        path = [
          "/etc/profiles/per-user/skyeav"
          "/run/current-system/sw"
        ];
        serviceConfig = {
          ExecStart = "%h/go/bin/hyprvoice serve";
          Environment = "YDOTOOL_SOCKET=/run/ydotoold/socket";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
  # Security configuration
  security = {
    # Rtkit for audio
    rtkit.enable = true;
    # Polkit for privilege escalation prompts
    polkit.enable = true;
  };
}
