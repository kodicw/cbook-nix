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
  home.packages =
    with pkgs;
    [
      fd
      bat
      ripgrep
      speedtest-rs
      cargo
      rustup
      gcc
      nodejs
      openssh
      fastfetch
      rclone
      mcp-nixos
      claude-code
      opencode
      gemini-cli
      nb
      polarbear.packages.${system}.nixvim
      polarbear.packages.${system}.tools-ssh
    ]
    ++ lib.optionals (!isAarch64) [
      ghostty
    ];
}
