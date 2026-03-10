{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
    settings = {
      term = "xterm-256color";
      window_padding_width = 10;
      background_opacity = 0.9;
      background_blur = 5;
    };
  };
}