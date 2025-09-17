{
  activeProfile = "main";
  profiles = {
    "main" = {
      system = "x86_64-linux";
      username = "matswuuu";
      hostName = "main";
      flakeLocation = "~/nixos-dotfiles";
      modules = [
        ./os/hardware/hardware-configuration-main.nix
        ./os/hardware/nvidia.nix
        ./os/programs/steam.nix
        ./server/yoru/yoru.nix
      ];
      hyprland = {
        monitor = [
          "DP-1, 1920x1080@165, 0x0, 1"
          "DP-2, 1920x1080@144, 0x1080, 1"
        ];
      };
      waybar = {
        output = "DP-1";
        thermal = {
          cpuZone = "0";
        };
      };
    };
    "laptop" = {
      system = "x86_64-linux";
      username = "matswuuu";
      hostName = "laptop";
      flakeLocation = "~/nixos-dotfiles";
      modules = [
        ./os/hardware/hardware-configuration-laptop.nix
      ];
      hyprland = {
        monitor = [
          "eDP-1, 1920x1080@60, 0x0, 1.2"
        ];
      };
      waybar = {
        output = "eDP-1";
        thermal = {
          cpuZone = "5";
        };
      };
    };
  };
}