{ config, osConfig, lib, ... }:
  let
    vars = import ./../../vars.nix;
    profile = vars.profiles.${vars.activeProfile};
    flakeLocation = profile.flakeLocation;
    hostName = config.networking.hostName;
    username = lib.head (lib.attrNames config.users.users);
  in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
     shellAliases = {
      os-rebuild = "cd ${flakeLocation}; git add --all; sudo nixos-rebuild switch --flake .#${hostName}";
      home-rebuild = "cd ${flakeLocation}; git add --all; home-manager switch --flake .${username}@${hostName}";
      shtd = "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'";

      c7x-host = "bash /home/matswuuu/c7x-host.sh";
      mongodb = "mongodb-compass --password-store=\"gnome-libsecret\" --ignore-additional-command-line-flags";

      quickshell-fix = "pkill -f quickshell; rm -rf ~/.local/state/quickshell ~/.cache/quickshell /run/user/1000/quickshell";
    };
  };
}