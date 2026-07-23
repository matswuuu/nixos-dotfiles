{
    fileSystems."/mnt/data" = {
        device = "/dev/disk/by-uuid/ACB6A0E5B6A0B16E";
        fsType = "ntfs-3g";
        options = [
            "uid=1000"
            "gid=100"
            "rw"
            "nofail"
        ];
    };
    fileSystems."/mnt/data2" = {
        device = "/dev/disk/by-uuid/35a1a29d-0f76-4e73-bc20-f65864c7c3a2";
        fsType = "ext4";
    };
}