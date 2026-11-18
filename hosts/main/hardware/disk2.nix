{
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/072690e6-b9d2-43b6-b7ef-c7c9d54870c6";
    fsType = "btrfs";
    options = [
      "subvol=@data"
      "noatime"
      "compress=zstd"
      "nofail"
    ];
  };
  fileSystems."/mnt/data2" = {
    device = "/dev/disk/by-uuid/35a1a29d-0f76-4e73-bc20-f65864c7c3a2";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
