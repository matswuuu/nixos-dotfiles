{
  activeProfile = "main";
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
        ./os/programs/gamemode.nix
        ./os/programs/steam.nix
        ./server/yoru/yoru.nix
      ];
      packages = [
        nvtopPackages.nvidia
        vulkan-tools
      ];
      hyprland = [
        ./home-manager/modules/hyprland/main/monitor.conf
      ];
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
        ./os/hardware/laptop/hardware-configuration.nix
        ./os/hardware/laptop/auto-cpufreq.nix
      ];
      packages = [

      ];
      hyprland = [
        ./home-manager/modules/hyprland/laptop/monitor.conf
      ];
      waybar = {
        output = "eDP-1";
        thermal = {
          cpuZone = "5";
        };
      };
    };
  };
}