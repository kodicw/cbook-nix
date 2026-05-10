{
  pkgs,
  nixgl,
  polarbear,
  ...
}:

let
  system = pkgs.system;
  isAarch64 = system == "aarch64-linux";
in
{
  home.packages = with pkgs; [
    fd
    openssh
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    wl-clipboard
    fastfetch
    rclone
    mcp-nixos
    claude-code
    opencode
    gemini-cli
    polarbear.packages.${system}.nixvim
    polarbear.packages.${system}.tools-net
    polarbear.packages.${system}.tools-nix
    polarbear.packages.${system}.tools-red
    polarbear.packages.${system}.tools-sre
    polarbear.packages.${system}.tools-ssh
    nb
  ] ++ lib.optionals (!isAarch64) [
    ghostty
    firefox
    nixgl.packages.${system}.nixGLIntel
  ];
}
