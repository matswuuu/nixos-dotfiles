{
  # Temporary compat: nixpkgs removed buildGo125Module on 2026-09-15,
  # but sops-nix master still calls it (pkgs/sops-install-secrets).
  # Alias it to the current builder until upstream migrates.
  # TODO: drop once sops-nix uses buildGo126Module+.
  nixpkgs.overlays = [
    (final: prev: {
      buildGo125Module = prev.buildGo126Module;
    })
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
        "https://yazi.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };
  };
}
