{ pkgs, nixgl, polarbear, ... }:

{
  home.packages = [
    pkgs.just
    pkgs.deadnix
    pkgs.ripgrep
    pkgs.ghostty
    pkgs.openssh
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    pkgs.gemini-cli
    pkgs.claude-code
    pkgs.opencode
    pkgs.wl-clipboard
    pkgs.fastfetch
    pkgs.rclone
    pkgs.quickemu
    pkgs.jq
    pkgs.mcp-nixos
    pkgs.firefox
    nixgl.packages.x86_64-linux.nixGLIntel
    polarbear.packages.x86_64-linux.nixvim
    pkgs.nb
  ];
}