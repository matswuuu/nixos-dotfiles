  let
    vars = import ./../../vars.nix;
    profile = vars.profiles.${vars.activeProfile};
  in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
     shellAliases = {
      c7x-host = "bash /home/matswuuu/c7x-host.sh";
      os-rebuild = "cd ${profile.flakeLocation}; git add --all; sudo nixos-rebuild switch --flake .";
      home-rebuild = "cd ${profile.flakeLocation}; git add --all; home-manager switch --flake .";
      mongodb = "mongodb-compass --password-store=\"gnome-libsecret\" --ignore-additional-command-line-flags";
      quickshell-fix = "pkill -f quickshell; rm -rf ~/.local/state/quickshell ~/.cache/quickshell /run/user/1000/quickshell";
    };
  };
}