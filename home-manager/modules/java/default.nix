{ pkgs, ... }: {
  programs.java = {
    enable = true;
    package = pkgs.openjdk.override {
      enableJavaFX = true;
    };
  };
}