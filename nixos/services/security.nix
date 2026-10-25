{
  services.gnome = {
    gnome-keyring.enable = true;

    # The Bitwarden SSH agent cannot share SSH_AUTH_SOCK with another agent, and
    # gcr-ssh-agent.socket claims that variable from its ExecStartPost
    # (`systemctl --user set-environment SSH_AUTH_SOCK=%t/gcr/ssh`) on every
    # login, which would silently undo the agent wiring in nixos/programs/ssh.nix.
    # NixOS asserts that only one SSH agent is installed at a time, so this has to
    # be off for the Bitwarden agent to be the only one.
    gcr-ssh-agent.enable = false;
  };
}
