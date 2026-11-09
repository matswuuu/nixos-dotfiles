{
  lib,
  appimageTools,
  fetchurl,
  libgpg-error,
}:

let
  pname = "openidea";
  version = "0.1.39";

  src = fetchurl {
    url = "https://github.com/l0ng-ai/openidea/releases/download/v${version}/OpenIDEA_${version}_amd64.AppImage";
    hash = "sha256-3QQEcibwvIWEgnn9ZzR36G9FhUCMGW2QjLLNdq/YWAM=";
  };

  contents = appimageTools.extract { inherit pname version src; };

  # appimageTools.wrapType2 builds the derivation from its arguments, so the
  # resulting `version`/`src` attributes carry no source position. nix-update
  # needs one to know which file to rewrite, so point it at the real position
  # of `src` in this file:
  #   nix run nixpkgs#nix-update -- --flake openidea
  updateTarget = { inherit version src; };
  srcPos = builtins.unsafeGetAttrPos "src" updateTarget;
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The AppImage bundles libgcrypt.so.20 but not libgpg-error.so.0, which it
  # expects the host distribution to provide.
  extraPkgs = pkgs: [ libgpg-error ];

  extraInstallCommands = ''
    install -Dm444 ${contents}/OpenIDEA.desktop $out/share/applications/openidea.desktop
    cp -r ${contents}/usr/share/icons $out/share/icons
  '';

  meta = {
    description = "AI-native IDE with an IntelliJ-style editor";
    homepage = "https://github.com/l0ng-ai/openidea";
    platforms = [ "x86_64-linux" ];
    mainProgram = "openidea";
    position = "${srcPos.file}:${toString srcPos.line}";
  };
}
