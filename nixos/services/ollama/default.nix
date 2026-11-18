{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host = "0.0.0.0";
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };
}
