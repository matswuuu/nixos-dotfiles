{ pkgs, lib, fetchurl, ... }:

let
  inherit (builtins) toString filter;

  # Keep NixOS patches that apply cleanly to glibc 2.43.
  # Exclude:
  # - 2.42-master.patch: backports from release/2.42/master already in 2.43 tarball
  # - 0001-Revert-Remove-all-usage-of-BASH-or-BASH-in-installed.patch: hardcodes /bin/bash
  #   in scripts; FHS env provides /bin/bash so this is not needed
  patches = let
    origPatches = pkgs.glibc.patches or [ ];
    isExcluded = p:
      lib.hasSuffix "2.42-master.patch" (toString p)
      || lib.hasSuffix "0001-Revert-Remove-all-usage-of-BASH-or-BASH-in-installed.patch" (toString p);
  in filter (p: !isExcluded p) origPatches
     ++ [ ./glibc-2.43-open-tree-fix.patch ];

in
pkgs.glibc.overrideAttrs (old: {
  pname = "glibc";
  version = "2.43";
  name = "glibc-2.43";

  src = fetchurl {
    url = "mirror://gnu/glibc/glibc-2.43.tar.xz";
    sha256 = "0c9qzbaprh779ggvix9c8hcps5y59y2caw42w2il7nxxbmmnrj6r";
  };

  inherit patches;

  # Remove the 2.42-specific patchSuffix from version-related metadata
  passthru = (old.passthru or { }) // {
    version = "2.43";
  };
})
