{
  services.gnome = {
    gnome-keyring.enable = true;
  };

  # The Bitwarden SSH agent cannot share SSH_AUTH_SOCK with another agent, and
  # gcr-ssh-agent.socket claims that variable from its ExecStartPost
  # (`systemctl --user set-environment SSH_AUTH_SOCK=%t/gcr/ssh`) on every login,
  # which would silently undo the agent wiring in home/modules/bitwarden.
  # NixOS asserts that only one SSH agent is installed at a time, so this has to
  # be off for the Bitwarden agent to be the only one.
  #
  # Kept in step with home/modules/bitwarden, which owns the agent itself.
  # Turning bitwarden.sshAgent.enable off means re-enabling this.
  services.gnome.gcr-ssh-agent.enable = false;
}
