{ pkgs, ... }:
{
  home.file = {
    ".config/yazi/init.lua".source = ./init.lua;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/vfs.toml".source = ./vfs.toml;
    ".config/yazi/copy-files-to-clipboard.sh" = {
      source = ./copy-files-to-clipboard.sh;
      executable = true;
    };
    ".config/yazi/yazi.toml".source = ./yazi.toml;
  };

  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    # Official mount manager: https://github.com/yazi-rs/plugins/tree/main/mount.yazi
    # Press M for the mount manager: m mount / u unmount / e eject / l enter.
    plugins = {
      mount = pkgs.yaziPlugins.mount;
    };
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
      # mount.yazi runtime deps (Linux): udisksctl + lsblk + eject
      udisks
      util-linux
      eject
      # manual MTP mounts from inside yazi shell: gio mount mtp://...
      gvfs
      glib
    ];
  };
}
