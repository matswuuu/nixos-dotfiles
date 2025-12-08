{
  activeProfile = "laptop";
  profiles = {
    "main" = {
      system = "x86_64-linux";
      username = "matswuuu";
      hostName = "main";
      flakeLocation = "~/nixos-dotfiles";
      modules = [
        ./os/hardware/main/hardware-configuration.nix
        ./os/hardware/main/cpu.nix
        ./os/hardware/main/nvidia.nix
        ./os/programs/steam.nix
      ];
      hyprland = [
        "~/.config/hypr/main/monitor.conf"
      ];
      catppuccin = {
        flavor = "macchiato";
        accent = "mauve";
      };
    };
    "laptop" = {
      system = "x86_64-linux";
      username = "matswuuu";
      hostName = "laptop";
      flakeLocation = "~/nixos-dotfiles";
      modules = [
        ./os/hardware/laptop/hardware-configuration.nix
        ./os/hardware/laptop/auto-cpufreq.nix
      ];
      hyprland = [
        "~/.config/hypr/laptop/monitor.conf"
      ];
      catppuccin = {
        flavor = "macchiato";
        accent = "mauve";
      };
    };
  };
}