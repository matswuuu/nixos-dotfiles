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
  };
}