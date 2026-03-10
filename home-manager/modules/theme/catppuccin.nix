{ inputs, lib, config, pkgs, ...}:
  let
    vars = import ./../../../vars.nix;
  in
{
  catppuccin = {
    enable = true;
    flavor = vars.profiles.${vars.activeProfile}.catppuccin.flavor;
    accent = vars.profiles.${vars.activeProfile}.catppuccin.accent;
    kvantum = {
      apply = true;
    };
    btop = {
      enable = true;
    };
    dunst = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    mpv = {
      enable = true;
    };
    obs = {
      enable = true;
    };
    kitty = {
      enable = true;
    };
    gtk = {
      icon = {
        enable = true;
      };
    };
  };
}