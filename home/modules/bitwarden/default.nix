{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.bitwarden;

  secret = name: config.sops.secrets.${name}.path;

  # Asks for the master password over pinentry's Assuan protocol. Kept separate
  # from unlock.sh so the protocol handling stays readable on its own.
  askpass = pkgs.writeShellScript "bitwarden-askpass" ''
    export PINENTRY=${pkgs.pinentry-gnome3}/bin/pinentry-gnome3
    exec ${./pinentry-password.sh}
  '';

  # The session key lives in XDG_RUNTIME_DIR, a tmpfs cleared on logout, so it
  # never outlives the session that unlocked it. %t expands inside the unit;
  # the fish side spells the same path out as $XDG_RUNTIME_DIR itself.
  sessionFile = "%t/bitwarden/session";

  unlockScript = pkgs.writeShellScript "bitwarden-unlock" ''
    exec ${./unlock.sh} \
      ${cfg.package}/bin/bw \
      ${askpass} \
      ${secret "bitwarden/baseUrl"} \
      ${secret "bitwarden/email"} \
      ${sessionFile} \
      ${pkgs.jq}/bin/jq
  '';

  # The agent socket is pinned to an absolute path rather than left at
  # Bitwarden's ~/.bitwarden-ssh-agent.sock default, so that the unit, the niri
  # fragment, and the shell all agree on one string Nix owns. niri does not
  # expand $HOME in its environment block, so it has to be spelled out.
  sshAgentSocket = "${config.xdg.stateHome}/bitwarden/ssh-agent.sock";

  # niri only injects its environment block into processes it spawns, so this is
  # what gives GUI apps started from a launcher the agent socket.
  niriEnvFragment = pkgs.writeText "bitwarden-env.kdl" ''
    environment {
        SSH_AUTH_SOCK "${sshAgentSocket}"
    }
  '';

  # Generated so the socket path stays single-sourced from Nix, matching the
  # niri fragment. Set unconditionally: gnome-keyring's agent is disabled, so
  # there is nothing to fall back to and a dangling path is the honest signal.
  fishSshEnv = pkgs.writeText "bitwarden-ssh.fish" ''
    set -gx SSH_AUTH_SOCK "${sshAgentSocket}"
  '';
in
{
  options.bitwarden = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the official Bitwarden CLI";
    };

    autoUnlock = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to unlock the vault once per graphical login, prompting for the
        master password in a pinentry dialog and caching the session key for
        the shell. When false, log in and unlock by hand instead.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bitwarden-cli;
      defaultText = lib.literalExpression "pkgs.bitwarden-cli";
      description = "The Bitwarden CLI package to install.";
    };

    sshAgent = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to run the Bitwarden desktop app as the system SSH agent and
          point SSH_AUTH_SOCK at it.

          The agent needs the vault to hold SSH key items, which the server must
          advertise support for. On Vaultwarden that means adding
          `ssh-agent-v2` and `ssh-key-vault-item` to
          EXPERIMENTAL_CLIENT_FEATURE_FLAGS. Bitwarden cannot share SSH_AUTH_SOCK
          with another agent, so nixos/services/security.nix disables
          gnome-keyring's gcr-ssh-agent, and this module expects programs.ssh
          to stop pinning identityFile.
        '';
      };

      desktopPackage = mkOption {
        type = types.package;
        default = pkgs.bitwarden-desktop;
        defaultText = lib.literalExpression "pkgs.bitwarden-desktop";
        description = "The Bitwarden desktop app package providing the agent.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.pinentry-gnome3
    ];

    # Exported rather than wrapped so `bw` keeps working verbatim in every
    # shell, script, and pipeline. A shell function would only cover interactive
    # fish.
    xdg.configFile."fish/conf.d/bitwarden.fish".source = ./bitwarden.fish;
    xdg.configFile."fish/functions/bwlock.fish".source = ./bwlock.fish;
    xdg.configFile."fish/functions/bwunlock.fish".source = ./bwunlock.fish;

    # pinentry-gnome3 needs the session's Wayland connection. The user manager
    # already carries WAYLAND_DISPLAY/DISPLAY into the service environment
    # (niri imports them at session start), so nothing needs setting here.
    systemd.user.services.bitwarden-unlock = mkIf cfg.autoUnlock {
      Unit = {
        Description = "Unlock the Bitwarden vault";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${unlockScript}";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.bitwarden = mkIf cfg.sshAgent.enable {
      Unit = {
        Description = "Bitwarden desktop app (SSH agent)";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${cfg.sshAgent.desktopPackage}/bin/bitwarden";
        Environment = [
          "BITWARDEN_SSH_AUTH_SOCK=${sshAgentSocket}"
          # Without this the Electron wrapper skips --ozone-platform-hint and
          # the app comes up on Xwayland instead of native Wayland.
          "NIXOS_OZONE_WL=1"
        ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Covers systemd user services, which niri's environment block and the
    # shell conf.d both miss.
    systemd.user.services.bitwarden-ssh-env = mkIf cfg.sshAgent.enable {
      Unit = {
        Description = "Point SSH_AUTH_SOCK at the Bitwarden SSH agent";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = lib.escapeShellArgs [
          "${pkgs.systemd}/bin/systemctl"
          "--user"
          "set-environment"
          "SSH_AUTH_SOCK=${sshAgentSocket}"
        ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    session.niri.includes = mkIf cfg.sshAgent.enable [ "bitwarden-env.kdl" ];
    home.file.".config/niri/bitwarden-env.kdl".source = mkIf cfg.sshAgent.enable niriEnvFragment;
    xdg.configFile."fish/conf.d/bitwarden-ssh.fish".source = mkIf cfg.sshAgent.enable fishSshEnv;

    # The hand-written ~/.config/autostart/bitwarden.desktop predates this
    # module and hardcodes a nix store path, so it would both break on the next
    # nixpkgs bump and race the unit above over the app's singleton lock.
    # Deleting a file counts as a side effect, hence after writeBoundary.
    home.activation.bitwarden_remove_stale_autostart = lib.mkIf cfg.sshAgent.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f "$HOME/.config/autostart/bitwarden.desktop"
      ''
    );
  };
}
