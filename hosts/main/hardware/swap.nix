{
  # Compressed in-RAM swap used before the disk swapfile (priority 5 vs. the
  # kernel-assigned negative priority of /swapfile). Swap-in from zram costs
  # microseconds instead of an NVMe + btrfs round trip, so pages reclaimed
  # from niri / audio clients under build memory pressure come back without
  # visible stalls. The swapfile stays as overflow.
  zramSwap.enable = true;

  # Swap readahead only helps on block devices; with zram it just adds
  # latency to every fault (same default as Fedora / ChromeOS).
  boot.kernel.sysctl."vm.page-cluster" = 0;

  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
    }
  ];
}
