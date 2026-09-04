{ pkgs, ... }:
{
  services.hermes-agent = {
    enable = true;
    container = {
      enable = true;
      backend = "docker";
      hostUsers = [ "matswuuu" ];
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
      ];
    };
    addToSystemPackages = true;
    settings = {
      model = {
        provider = "custom";
        default = "gemma4:12b";
        base_url = "http://host.docker.internal:11434/v1";
        context_length = 65536;
      };
      terminal = {
        backend = "docker";
      };
    };
    extraPackages = with pkgs; [
      git
      curl
      jq
      ripgrep
      fd
      tree
      wget
      unzip
    ];
  };
}
