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
      os-rebuild = "sudo nixos-rebuild switch --flake ${vars.profiles.${vars.activeProfile}.flakeLocation}";
      home-rebuild = "home-manager switch --flake ${vars.profiles.${vars.activeProfile}.flakeLocation}";
    };
  };
}