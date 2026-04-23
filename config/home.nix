{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
}