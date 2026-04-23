{
  config,
  pkgs,
  nixgl,
  polarbear,
  jbot,
  userModule ? {},
  ...
}:

{
  imports = [
    userModule
  ];
}