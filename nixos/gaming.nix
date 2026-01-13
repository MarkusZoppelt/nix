{
  config,
  lib,
  ...
}:

with lib;

{
  options.gaming = {
    enable = mkEnableOption "gaming support (Steam, gamemode, gamescope)";
  };

  config = mkIf config.gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = false;
    };

    programs.gamemode.enable = true;

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
