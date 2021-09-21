{ config, pkgs, ... }:
let
  properties = config.properties;
in
{

  imports = [
    ../../home
    ../properties.nix
    ./secrets.nix
  ];

  nixpkgs.overlays = [
    (import ../../overlays)
  ];

  # home.packages = with pkgs; [ home-manager ];

  programs.home-manager = {
    enable = true;
  };

    home.communication = {
      enableTwitter = false;
      enableElement = false;
      enableSignal = false;
      enableSkype = false;
      enableSlack = true;
      enableTelegram = true;
      enableZoom = true;
      enableDiscord = false;
    };

  # home.backup = {
  #   enable = true;
  #   rslsync = {
  #     enable = true;
  #     enableWebUI = true;
  #     httpListenAddr = "127.0.0.1";
  #     httpListenPort = 8888;
  #     deviceName = properties.device.name;
  #   };
  # };

  # # home.communication = {
  # #   enableTwitter = true;
  # #   enableElement = false;
  # #   enableSignal = false;
  # #   enableSkype = false;
  # #   enableSlack = true;
  # #   enableTelegram = true;
  # #   enableZoom = false;
  # #   enableDiscord = false;
  # # };

    home.dev = {
      enable = true;
      aws.enable = true;
      docker.enable = true;
      emacs.enable = true;
      k8s.enable = true;
      terraform.enable = true;
    };

    home.sound.enableSpotify = true;

  # home.base.ssh.config = properties.ssh.config;

  home.gui.enable = true;
  home.gui.office.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
  };

  # nix = {
  #   package = pkgs.nixFlakes;
  #   autoOptimiseStore = true;
  #   gc = {
  #     automatic = true;
  #     dates = "weekly";
  #     options = "--delete-older-than 10d";
  #   };
  #   binaryCaches = ["s3://store?endpoint=http://nas:9000"];
  #   # I am using local cache on NAS
  #   requireSignedBinaryCaches = false;
  #   extraOptions = ''
  #     keep-outputs = true
  #     keep-derivations = true
  #     experimental-features = nix-command flakes ca-references
  #   '';
  # };

  # # time.timeZone = properties.timezone;

  # # # Enabled by default
  # # modules.base.enable = true;

  # # modules.backup.rslsync = {
  # #   enable = true;
  # #   enableWebUI = true;
  # #   httpListenAddr = "127.0.0.1";
  # #   httpListenPort = 8888;
  # # };
  # # modules.backup.restic = {
  # #   repo = properties.backup.repo;
  # #   excludePaths = properties.backup.excludePaths;
  # #   pass = properties.backup.backupPass;
  # #   paths = properties.backup.paths;
  # # };

  # # modules.dev = {
  # #   enable = true;
  # #   docker.enable = true;
  # #   docker.autoPrune = true;
  # #   k8s.enable = true;
  # #   virtualisation.enableVirtualbox = true;
  # #   terraform.enable = true;
  # #   aws.enable = true;
  # #   emacs.enable = true;
  # # };

  # # # environment.variables = {
  # # #   GDK_SCALE = "1.1";
  # # #   GDK_DPI_SCALE = "1.1";
  # # #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.1";
  # # # };

  # # modules.gui = {
  # #   enable = true;
  # #   fonts = {
  # #     dpi = 100;
  # #   };

  # #   # displayProfiles = builtins.toJSON {
  # #   #   home.fingerprint = lib.mkMerge [
  # #   #     homeDisplay.fingerprint
  # #   #     laptopDisplay.fingerprint
  # #   #   ];
  # #   #   home.config = lib.mkMerge [
  # #   #     homeDisplay.config
  # #   #     laptopDisplay.config
  # #   #     {
  # #   #       eDP-1 = {
  # #   #         position = "5840x0";
  # #   #       };
  # #   #     }
  # #   #   ];
  # #   #   home.hooks = homeDisplay.hooks;

  # #   #   laptop = laptopDisplay;
  # #   #   home2 = homeDisplay;
  # #   # };

  # #   longitude = properties.longitude;
  # #   latitude = properties.latitude;
  # #   day = 5500;
  # #   night = 3500;

  # #   office.enable = true;
  # # };

  # # modules.base.ssh.config = properties.ssh.config;

  # # modules.system.sound.enable = true;
  # # modules.system.sound.pulse.enable = true;
  # # modules.system.printing.enable = true;

  # # modules.communication = {
  # #   enable = true;
  # #   enableTwitter = true;
  # #   enableElement = false;
  # #   enableSignal = false;
  # #   enableSkype = false;
  # #   enableSlack = true;
  # #   enableTelegram = true;
  # #   enableZoom = true;
  # #   enableDiscord = true;
  # # };

  # # modules.system.powermanagement = {
  # #   enable = true;
  # #   powertop.enable = true;
  # #   governor = "powersave";
  # #   suspendHibernate.enable = true;
  # # };

  # # modules.mail = {
  # #   enable = true;
  # #   thunderbird.enable = true;
  # # };

  # # # modules.antivirus = {
  # # #   enable = true;
  # # # };

  # # modules.misc.ios.enable = true;
}
