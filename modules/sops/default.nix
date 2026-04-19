{ inputs, ... }: 
{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets.yaml";
    age.keyFile = "/home/matswuuu/.config/sops/age/keys.txt";
    secrets = {
      "bar/tapo/ip" = {};
      "bar/tapo/email" = {};
      "bar/tapo/password" = {};
    };
  };
}