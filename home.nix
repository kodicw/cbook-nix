{
  config,
  pkgs,
  nixgl,
  polarbear,
  jbot,
  ...
}:

{
  imports = [
    jbot.homeManagerModules.ai-company
    ./config/home.nix
    ./packages.nix
    ./programs/shells.nix
    ./programs/terminals.nix
    ./programs/devtools.nix
    ./session.nix
    ./systemd/opencode-server.nix
    ./systemd/rclone-gdrive.nix
    ./activation/crostini-icons.nix
  ];
}