{
  activeProfile = "main";
  profiles = {
    "main" = {
      system = "x86_64-linux";
      username = "matswuuu";
      flakeLocation = "~/nixos-dotfiles";
<<<<<<< HEAD
      modules = [
        ./os/programs/steam.nix
=======
      hyprland = [
        "~/.config/hypr/main/monitor.conf"
>>>>>>> 43f07eae7f18a275dcfbb835ed9b6da8f4bfd285
      ];
      catppuccin = {
        flavor = "macchiato";
        accent = "mauve";
      };
    };
    "laptop" = {
      system = "x86_64-linux";
      username = "matswuuu";
      flakeLocation = "~/nixos-dotfiles";
<<<<<<< HEAD
      modules = [];
=======
      hyprland = [
        "~/.config/hypr/laptop/monitor.conf"
      ];
>>>>>>> 43f07eae7f18a275dcfbb835ed9b6da8f4bfd285
      catppuccin = {
        flavor = "macchiato";
        accent = "mauve";
      };
    };
  };
}
