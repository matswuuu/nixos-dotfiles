{
  programs.git = {
    enable = true;

    settings = {
      url."git@github.com:".insteadOf = "https://github.com/";
      url."git@gitlab.com:".insteadOf = "https://gitlab.com/";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/gitlab";
        identitiesOnly = true;
      };
    };
  };
}