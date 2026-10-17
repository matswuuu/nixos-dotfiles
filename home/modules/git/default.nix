{
  programs.git = {
    enable = true;

    settings = {
      url."git@github.com:".insteadOf = "https://github.com/";
      url."git@gitlab.com:".insteadOf = "https://gitlab.com/";
    };
  };
}
