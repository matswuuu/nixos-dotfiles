{ lib, ... }:
{
  programs.ssh = {
    startAgent = lib.mkForce false;
  };

  environment.variables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
}
