{ config, lib, ... }:
let 
  cfg = config.programs.amezia-wg;
in 
{
  options = {
    programs.amnezia-wg = {
      whitelist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "A list of whitelisted ips.";
        example = [ "3.21.59.133" "example.org" ];
      };
      blacklist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "A list of blacklisted ips.";
        example = [ "3.21.59.133" "example.org" ];
      };
    };
  };
  config = {
    programs.amnezia-vpn = {
      enable = true;
    };

    home.file.".config/proxy/config.json".text = 
      builtins.toJSON {
        whitelist = builtins.toJSON cfg.whitelist;
        blacklist = builtins.toJSON cfg.blacklist;
      };
  };
}