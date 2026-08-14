{
  fileSystems."/home/matswuuu/games" = {
    device = "/dev/disk/by-uuid/7248a423-38fb-4cde-9df5-ba37f6c1c2b6";
    fsType = "btrfs";
    options = [
        "subvol=@games"
        "compress=zstd"
        "noatime"
        "nofail"
    ];
  };
}