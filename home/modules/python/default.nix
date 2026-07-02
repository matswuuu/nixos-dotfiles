{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    conda
    glib
    gobject-introspection

    (pkgs.python314.withPackages (ps: with ps; [
        pip
        dbus-python
        pygobject3

        (ps.buildPythonPackage rec {
            pname = "tapo";
            version = "0.8.12";
            format = "pyproject";
            doCheck = false;
            src = ps.fetchPypi {
                inherit pname version;
                sha256 = "sha256-7wrcMOwh55O4367vj0KgQvk642LsNRn5mt1hmKiiJX0=";
            };
            cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                inherit src;
                hash = "sha256-HDgP3ZK0T4t514E+MYS02G39CwVqDbaOPQyFoqaVx+c=";
            };
            nativeBuildInputs = with pkgs; [
                rustc
                cargo
                rustPlatform.maturinBuildHook
                rustPlatform.cargoSetupHook
            ];
            propagatedBuildInputs = with ps; [
                requests
            ];
        })
    ]))
  ];
}