{ inputs, username, ... }:
{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets.yaml";
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      "bar/tapo/ip" = { };
      "bar/tapo/email" = { };
      "bar/tapo/password" = { };
      "bitwarden/baseUrl" = { };
      "bitwarden/email" = { };
    };
  };
}
