{
  pkgs,
  config,
  ...
}: {
  services.flameshot = {
    enable = true;

    package = pkgs.flameshot.override {
      enableWlrSupport = true;
    };

    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;

        savePath = "${config.home.homeDirectory}/Pictures/screenshots";
        savePathFixed = true;
        saveAsFileExtension = ".png";
        filenamePattern = "%F_%H-%M";
        drawThickness = 1;
        copyPathAfterSave = true;

        useGrimAdapter = true;
      };
    };
  };
}