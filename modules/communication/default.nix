{ lib, ... }:
with lib;
{
  imports = [
    # Development
    ./cawbird.nix
    ./element.nix
    ./signal.nix
    ./skype.nix
    ./slack.nix
    ./telegram.nix
    ./zoom.nix
  ];
  options.modules.communication = {
    enable = mkEnableOption "Enable communication soft.";
    enableTwitter = mkEnableOption "Enable Twitter.";
    enableElement = mkEnableOption "Enable Element.";
    enableSignal = mkEnableOption "Enable Signal.";
    enableSkype = mkEnableOption "Enable Skype.";
    enableSlack = mkEnableOption "Enable Slack.";
    enableTelegram = mkEnableOption "Enable Telegram.";
    enableZoom = mkEnableOption "Enable Zoom.";
  };
}
