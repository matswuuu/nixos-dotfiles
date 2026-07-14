{ pkgs, ...}:
{
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
    };
    mime = {
      enable = true;
    };
  };

  programs.niri = {
    enable = true;
  };
}
