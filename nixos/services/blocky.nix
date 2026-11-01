{
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = "127.0.0.1:53";

      # Family resolvers filter adult content upstream as a second layer behind
      # the denylists below. Mixing in an unfiltered resolver would let
      # parallel_best answer from it and skip that filtering.
      upstreams.groups.default = [
        "1.1.1.3"
        "1.0.0.3"
        "94.140.14.15"
        "94.140.15.16"
      ];

      blocking = {
        denylists.porn = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-only/hosts"
          "https://blocklistproject.github.io/Lists/porn.txt"
          "https://nsfw.oisd.nl/domainswild2"
          # Firefox's canary domain: answering it with NXDOMAIN makes Firefox
          # keep using system DNS instead of switching to its own DoH resolver.
          ''
            use-application-dns.net
          ''
        ];
        clientGroupsBlock.default = [ "porn" ];
        # NXDOMAIN rather than 0.0.0.0, since that is what Firefox's canary
        # check looks for.
        blockType = "nxDomain";
        loading = {
          # Serve DNS right away at boot and fill the lists in the background,
          # instead of failing to start while the network is still down.
          strategy = "fast";
          # The larger lists are tens of MB and overrun the 5s default.
          downloads.timeout = "2m";
        };
      };

      caching = {
        minTime = "5m";
        prefetching = true;
      };
    };
  };

  networking = {
    nameservers = [ "127.0.0.1" ];
    # Keep NetworkManager from replacing the resolver with DHCP-provided DNS.
    networkmanager.dns = "none";
  };
}
