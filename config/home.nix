{ config, pkgs, ... }:

{
  home.username = "kodicw";
  home.homeDirectory = "/home/kodicw";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
}