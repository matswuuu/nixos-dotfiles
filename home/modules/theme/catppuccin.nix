{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "mauve";
    cursors = {
      enable = false;
    };
    kvantum = {
      apply = true;
    };
    btop = {
      enable = true;
    };
    dunst = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    mpv = {
      enable = true;
    };
    obs = {
      enable = true;
    };
    obsidian = {
      enable = true;
    };
    kitty = {
      enable = true;
    };
    yazi = {
      enable = true;
    };
    # catppuccin/nix still writes programs.opencode.tui, which OpenCode 2
    # ignores; the theme is set via programs.opencode.cli instead.
    opencode = {
      enable = false;
    };
    gtk = {
      icon = {
        enable = true;
      };
    };
  };
}
