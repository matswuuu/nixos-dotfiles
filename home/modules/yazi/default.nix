{ pkgs, ... }:
{
  home.file = {
    ".config/yazi/init.lua".source = ./init.lua;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/copy-files-to-clipboard.sh" = {
      source = ./copy-files-to-clipboard.sh;
      executable = true;
    };
    ".config/yazi/yazi.toml".source = ./yazi.toml;
  };

  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    extraPackages = with pkgs; [
      fd
      ffmpegthumbnailer
      file
      fzf
      imagemagick
      jq
      mediainfo
      p7zip
      poppler
      ripgrep
      unar
      wl-clipboard
    ];
  };
}
