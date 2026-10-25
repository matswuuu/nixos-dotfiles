{
  # Options: `mtsw-shot config --default` lists every key.
  programs.mtsw-shot = {
    enable = true;
    settings = {
      accept_actions = [ "copy" ];
      save.path = "~/Pictures/Screenshots";
    };
  };
}
