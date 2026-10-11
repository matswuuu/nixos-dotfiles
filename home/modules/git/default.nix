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
      # No identityFile or IdentitiesOnly: both would bypass the agent entirely
      # and pin these hosts to ~/.ssh/github and ~/.ssh/gitlab. Keys now come
      # from the Bitwarden SSH agent, which selects by the public key the
      # server offers.
      "github.com" = {
        hostname = "github.com";
        user = "git";
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
      };
    };
  };
}
