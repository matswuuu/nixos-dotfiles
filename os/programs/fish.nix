  let
    vars = import ./../../vars.nix;
  in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
     shellAliases = {
      c7x-host = "bash /home/matswuuu/c7x-host.sh";
      my-ip = "bash ~/.config/waybar/scripts/ip_info.sh";
      os-rebuild = "cd ${vars.profiles.${vars.activeProfile}.flakeLocation}; git add --all; sudo nixos-rebuild switch --flake .";
      home-rebuild = "cd ${vars.profiles.${vars.activeProfile}.flakeLocation}; git add --all; home-manager switch --flake .";
      mongodb = "mongodb-compass --password-store=\"gnome-libsecret\" --ignore-additional-command-line-flags";
    };
  };
}