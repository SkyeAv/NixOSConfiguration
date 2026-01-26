# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal NixOS system configuration managed through Nix Flakes. The configuration defines a complete system setup for an ASUS laptop ("skyetop") with hybrid AMD/NVIDIA graphics, focused on development, gaming, and AI/ML workloads with CUDA support.

## System Architecture

### Core Configuration Structure

- **`flake.nix`**: Flake entry point defining inputs (nixpkgs, home-manager, CachyOS kernel, KWin effects) and the NixOS configuration output for the "skyeav" system
- **`configuration.nix`**: Main system configuration with hardware settings, services, user packages, and environment setup
- **`hardware-configuration.nix`**: Auto-generated hardware-specific settings (do not manually edit)

### Key System Features

1. **Flake-based Configuration**: Uses `flake-parts` for modular structure with inputs from nixpkgs-unstable
2. **CachyOS Kernel**: Custom kernel (`cachyosKernels.linuxPackages-cachyos-latest-lto`) with LTO optimizations and Ananicy process priority management
3. **Hybrid Graphics**: AMD integrated GPU (101:0:0) + NVIDIA discrete GPU (100:0:0) with PRIME sync mode
4. **CUDA Support**: Full CUDA toolkit with PyTorch binaries overridden for GPU acceleration
5. **Home Manager**: Integrated user environment management for the `skyeav` user
6. **Desktop Environment**: KDE Plasma 6 with SDDM display manager

### Python Environment Pattern

The configuration uses a special pattern for CUDA-enabled Python (lines 10-16, 61-66 in configuration.nix):
- Creates `cuda-py` using `python313.override` with `packageOverrides`
- Forces binary wheel versions of `torch`, `torchvision`, `torchaudio` for CUDA compatibility
- Applied both as overlay (lines 61-66) and directly (lines 10-16)
- Installed as user package with `.withPackages` at lines 249-305

### Package Organization

Packages are organized using Nix `let` bindings for namespacing (lines 3-8):
- `code-extensions`: VS Code extensions
- `beam`: Erlang/Elixir ecosystem (BEAM)
- `py`: Python packages
- `nvtop`: NVTOP variants
- `caml`: OCaml packages
- `plasma`: KDE Plasma packages
- `cuda`: CUDA packages
- `cuda-py`: CUDA-enabled Python

## Common Commands

### Rebuild System Configuration
```bash
os-rebuild
# Expands to: sudo nixos-rebuild switch --flake /etc/nixos#skyeav
```

This is the primary command for applying configuration changes. The alias is defined in `programs.bash.shellAliases` (line 325).

### Flake Operations
```bash
# Update flake inputs
nix flake update

# Check flake for errors
nix flake check

# Show flake outputs
nix flake show

# Lock a specific input version
nix flake lock --update-input <input-name>
```

### Testing Configuration Changes
```bash
# Build without switching (dry-run)
sudo nixos-rebuild build --flake /etc/nixos#skyeav

# Test configuration (switch but don't set as default boot option)
sudo nixos-rebuild test --flake /etc/nixos#skyeav

# Boot into configuration once (next boot only)
sudo nixos-rebuild boot --flake /etc/nixos#skyeav
```

### Garbage Collection
The system has automatic garbage collection configured (lines 48-52), but can be triggered manually:
```bash
# Remove old generations
nix-collect-garbage -d

# Remove generations older than N days
nix-collect-garbage --delete-older-than 30d
```

## Important Configuration Patterns

### Adding System Packages
Add to `environment.systemPackages` (lines 382-390) for system-wide availability.

### Adding User Packages
Add to `users.users.skyeav.packages` (lines 182-318) for user-specific packages. Organized by package set:
- Regular packages: lines 182-248
- CUDA Python packages: lines 249-305
- OCaml packages: lines 305-307
- BEAM packages: lines 307-309
- Plasma packages: lines 309-313
- CUDA packages: lines 314-316
- NVTOP packages: lines 316-318

### VS Code Extensions
Add to Home Manager configuration at `home-manager.users.skyeav.programs.vscode.profiles.default.extensions` (lines 460-489).

### Shell Aliases
Defined in `programs.bash.shellAliases` (lines 323-331).

### Flake Inputs
When adding new flake inputs to `flake.nix`:
1. Add input in `inputs` block (lines 3-11)
2. Include in `outputs` function parameters (line 12)
3. Pass through `specialArgs` if needed in modules (line 18)
4. Run `nix flake lock` to update lock file

## Hardware-Specific Details

### Graphics Configuration
- **Hybrid GPU Setup**: AMD (primary) + NVIDIA (secondary) with PRIME sync (lines 371-375)
- **NVIDIA Settings**: Uses beta drivers, open-source kernel modules, with modesetting enabled (lines 368-380)
- **Video Drivers**: Both `amdgpu` and `nvidia` loaded (lines 364-367)

### ASUS Laptop Services
- `services.asusd`: Controls ASUS-specific hardware features (line 340-342)
- `services.supergfxd`: Graphics switching daemon (line 342)
- Requires `asusctl` and `supergfxctl` packages (lines 383-387)

### Power Management
- **Auto-cpufreq**: Dynamic CPU frequency scaling with battery/charger profiles (lines 424-434)
- **Governor**: `powersave` on battery, `performance` when charging
- **Turbo Boost**: Disabled on battery, auto when charging

### Brightness Control
- Uses `acpilight` for hardware brightness control (line 442)
- `brightnessctl` installed for user control (line 186)

## CUDA and ML Setup

### CUDA Configuration
- CUDA toolkit installed via `cudaPackages.cudatoolkit` (lines 314-316)
- `CUDA_PATH` environment variable set (lines 334-336)
- `nixpkgs.config.cudaSupport = true` globally enabled (line 354)
- OpenGL/graphics with NVIDIA VAAPI driver (lines 356-362)

### Ollama Service
- Runs as system daemon with CUDA support (lines 346-349)
- Package: `pkgs.ollama-cuda`

### PyTorch Setup
The configuration ensures CUDA-enabled PyTorch by forcing binary wheel installations, which include precompiled CUDA support, rather than building from source.

## Network Configuration

### VPN Support
- **OpenConnect**: Installed system-wide (line 384) and as user package (line 192)
- **NetworkManager Plugin**: `networkmanager-openconnect` enabled (lines 111-113)
- **openconnect-sso Alias**: Special Qt platform settings for GUI (line 324)

## Modification Guidelines

### Editing configuration.nix
1. Make changes to the relevant sections
2. The file uses explicit line organization with comments marking major sections
3. Test with `nixos-rebuild build` before switching
4. Run `os-rebuild` to apply changes

### Binary Cache Configuration
The system uses multiple binary caches (lines 32-45) to speed up builds:
- Official NixOS cache
- CUDA maintainers cache
- CachyOS kernel cache
- Flox cache
- Lantian cache

When adding packages that require compilation, check if a cache exists to avoid long build times.

### Managing Kernel Parameters
Kernel parameters are in `boot.kernelParams` (lines 83-96). Key parameters:
- NVIDIA-specific: `nvidia.NVreg_UsePageAttributeTable=1`
- AMD CPU: `amd_pstate=guided`
- Backlight: `acpi_backlight=native`
- Boot quieting: `quiet`, `splash`, `loglevel=3`

### Home Manager Changes
User-specific configuration is under `home-manager.users.skyeav` (lines 450-491). Changes here affect only the user environment, not system-wide settings.

## System State Version

The system is pinned to state version `25.11` (lines 451, 495). This should not be changed on existing installations as it affects how NixOS interprets certain configuration options for backwards compatibility.
