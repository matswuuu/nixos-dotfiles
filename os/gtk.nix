{
  programs = {
    # gtk = {
    #   enable = true;
    # };
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