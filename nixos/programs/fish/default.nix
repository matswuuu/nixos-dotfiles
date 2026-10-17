{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      rm = "trash-put"; # move files to trash instead of deleting
      c7x-host = "bash $HOME/c7x-host.sh";
      yoru-host = "bash $HOME/yoru-host.sh";
      mongodb = "mongodb-compass --password-store=\"gnome-libsecret\" --ignore-additional-command-line-flags";
    };
  };
}
