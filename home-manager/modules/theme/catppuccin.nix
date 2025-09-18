{ inputs, lib, config, pkgs, ...}:
  let
    vars = import ./../../vars.nix;
  in
{
  catppuccin = {
    enable = true;
    flavor = vars.prfoiles.${vars.activeProfile}.catppuccin.flavor;
    accent = vars.prfoiles.${vars.activeProfile}.catppuccin.accent;
  };
}