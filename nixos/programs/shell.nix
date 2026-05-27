{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      c7x-host = "bash $HOME/c7x-host.sh";
      yoru-host = "bash $HOME/yoru-host.sh";
      mongodb = "mongodb-compass --password-store=\"gnome-libsecret\" --ignore-additional-command-line-flags";

      quickshell-fix = "pkill -f quickshell; rm -rf ~/.local/state/quickshell ~/.cache/quickshell /run/user/1000/quickshell";
    };
  };
}