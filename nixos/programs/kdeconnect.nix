{ pkgs, ... }:
{
  programs.kdeconnect = {
    enable = true;
  };

  environment = {
    systemPackages = [ pkgs.kdePackages.plasma-browser-integration ];
    etc."opt/chrome/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.kdePackages.plasma-browser-integration}/etc/opt/chrome/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };
}
