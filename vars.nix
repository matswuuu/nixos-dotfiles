{
  activeProfile = "laptop";
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
      ];
      waybar = {
        thermal = {
          cpuZone = 0
        }
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
      waybar = {
        thermal = {
          cpuZone = 5
        }
      };
    };
  }
}