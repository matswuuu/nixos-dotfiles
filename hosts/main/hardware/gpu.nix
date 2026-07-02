{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting = {
        enable = true;
      };
      powerManagement = {
        enable = true;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nvidia-container-toolkit = {
      enable = true;
      mounts = [
        # Mount individual ICD JSON files (not whole directories) to avoid
        # conflicts with distro packages (e.g. Arch's mesa provides 50_mesa.json).
        {
          hostPath = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
          containerPath = "/usr/share/vulkan/icd.d/nvidia_icd.json";
          mountOptions = [ "ro" "nosuid" "nodev" "bind" ];
        }
        {
          hostPath = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
          containerPath = "/usr/share/glvnd/egl_vendor.d/10_nvidia.json";
          mountOptions = [ "ro" "nosuid" "nodev" "bind" ];
        }
      ];
    };
  };
}