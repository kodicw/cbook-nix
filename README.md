# cbook-nix

This repository contains the [Home Manager](https://github.com/nix-community/home-manager) configuration for my ChromeOS environment (Crostini/Linux development environment).

It uses Nix Flakes to provide a reproducible and declarative way to manage user-level packages, shell environments, and configuration files.

## Key Features
- **Nix Flakes**: For dependency management and reproducible builds.
- **Nushell**: Interactive shell with Starship prompt and Carapace completion.
- **Zellij**: Terminal multiplexer for workspace management.
- **Wayland Optimized**: Configuration for Foot and Ghostty terminals with Wayland-specific session variables.
- **Cloud Integration**: Automatic Google Drive mounting via `rclone` systemd service.

## Usage

To apply the configuration to your environment:

```bash
home-manager switch --flake .#kodicw
```

To update the flake inputs:

```bash
nix flake update
```
