{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "rust"
      "dockerfile"
      "catppuccin"
    ];

    userSettings = {
      hour_format = "hour24";
    };
  };
}
