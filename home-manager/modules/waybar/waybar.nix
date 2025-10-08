  let
    vars = import ./../../../vars.nix;
  in
{
  home.file = {
    ".config/waybar/common.jsonc".source = ./common.jsonc;
    ".config/waybar/style.css".source = ./style.css;

    # Scripts
    ".config/waybar/scripts/gpu_usage.sh" = {
      source = ./scripts/nvidia_gpu_usage.sh;
      executable = true;
    };
    ".config/waybar/scripts/cpu_temp.sh" = {
      source = ./scripts/cpu_temp.sh;
      executable = true;
    };
    ".config/waybar/scripts/gpu_temp.sh" = {
      source = ./scripts/nvidia_gpu_temp.sh;
      executable = true;
    };
    ".config/waybar/scripts/ip_info.sh" = {
      source = ./scripts/ip_info.sh;
      executable = true;
    };
  };
  # programs.waybar = {
  #   enable = true;
  #   settings = {
  #     mainBar = {
  #       output = vars.profiles.${vars.activeProfile}.waybar.output;
  #       include = [ ./common.jsonc ];
  #     };
  #   };
  # };
  catppuccin.waybar = {
    mode = "createLink";
  };
}
