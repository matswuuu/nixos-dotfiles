{
  nix = {
    gc = {
      automatic = true;
      dates = "06:00";
      options = "--delete-older-than 14d";
    };
  };
}