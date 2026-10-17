{ config, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      # No identityFile or IdentitiesOnly: both would bypass the agent entirely
      # and pin these hosts to ~/.ssh/github and ~/.ssh/gitlab. Keys are
      # selected from SSH_AUTH_SOCK (gnome-keyring's gcr-ssh-agent), which picks
      # by the public key the server offers.
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/gitlab";
      };

      "storage" = {
        hostname = "storage.dedi.c7x.dev";
        user = "matswuuu";
        port = 22;
        identityFile = "~/.ssh/cristalix";
      };

      "mokou" = {
        hostname = "mokou.dedi.c7x.dev";
        user = "matswuuu";
        port = 22;
        identityFile = "~/.ssh/cristalix";
      };

      "new2b2t" = {
        hostname = "new2b2t.dedi.c7x.dev";
        user = "matswuuu";
        port = 22;
        identityFile = "~/.ssh/cristalix";
      };
    };
  };

  # `programs.ssh` normally links ~/.ssh/config into the world-readable
  # /nix/store. ssh (and other consumers) reject that ownership/mode with
  # "Bad owner or permissions on ~/.ssh/config", so materialise a private,
  # user-owned copy instead.
  home.file.".ssh/config".enable = false;

  home.activation.sshConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run mkdir -p "$HOME/.ssh"
    run chmod 700 "$HOME/.ssh"
    run rm -f "$HOME/.ssh/config"
    run install -m 600 ${lib.escapeShellArg (toString config.home.file.".ssh/config".source)} "$HOME/.ssh/config"
  '';
}
