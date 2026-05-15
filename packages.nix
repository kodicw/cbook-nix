{
  pkgs,
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
      eza
      ripgrep
      speedtest-rs
      rustup
      gcc
      nodejs
      openssh
      fastfetch
      rclone
      mcp-nixos
      claude-code
      ollama
      opencode
      gemini-cli
      nb
      xonsh
      polarbear.packages.${system}.nixvim
      polarbear.packages.${system}.tools-ssh
    ]
    ++ lib.optionals (!isAarch64) [
      ghostty
    ];
}
