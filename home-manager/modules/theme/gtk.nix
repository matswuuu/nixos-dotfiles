{ inputs, lib, config, pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  programs = {
    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        cursor = {
          enable = true;
          flavour = vars.profiles.${vars.activeProfile}.catppuccin.flavor;
          accent = vars.profiles.${vars.activeProfile}.catppuccin.accent;
        };
      };
      cursorTheme.size = 48;
    };
    dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        }
      ];
    };
  };
}