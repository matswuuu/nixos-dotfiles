{ inputs, ... }: 
{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets.yaml";
    age.keyFile = "/home/matswuuu/.config/sops/age/keys.txt";
    secrets = {
      "bar/network/host1/ip" = {};
      "bar/network/host1/port" = {};
      "bar/network/host2/ip" = {};
      "bar/network/host2/port" = {};
      "bar/network/host3/ip" = {};
      "bar/network/host3/port" = {};
      "bar/network/host4/ip" = {};
      "bar/network/host4/port" = {};

      "bar/tapo/ip" = {};
      "bar/tapo/email" = {};
      "bar/tapo/password" = {};
    };
  };
}