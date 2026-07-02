{
    services.btrbk = {
      instances."backup" = {
        onCalendar = "daily";
        settings = {
          volume."/btr_pool" = {
            snapshot_dir = "btrbk_snapshots"; # Directory where snapshots are stored
            subvolume = "nixos"; # Name of your subvolume to backup
            target = "/mnt/backup_drive/btrbk_backups"; # Local backup target
          };
        };
      };
    };
}