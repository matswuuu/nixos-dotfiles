{ pkgs, config, ... }:
let
  baseSettings = builtins.fromJSON (builtins.readFile ./opencode.json);

  # Telegram remote control (OpenCode v2 plugin). The bot token comes from
  # sops and is read at runtime via OpenCode's {file:...} substitution, so it
  # never lands in the Nix store.
  telegramPlugin = {
    package = "github:jaygupta17/opencode2-telegram";
    options = {
      token = "{file:${config.sops.secrets."opencode/telegram/token".path}}";
      # Allowed Telegram chat IDs. Empty = bootstrap mode (the bot replies to
      # the first DM with its chat_id).
      allowFrom = [ 5840978292 ];
    };
  };
in
{
  sops.secrets."opencode/telegram/token" = { };

  programs.opencode = {
    enable = true;
    settings = baseSettings // {
      plugins = baseSettings.plugins ++ [ telegramPlugin ];
    };
    skills = ./skills;
    commands = ./commands;
    cli.theme.name = "catppuccin-macchiato";
  };

  # opencode.json references {file:./prompts/*.md} relative to
  # ~/.config/opencode/opencode.json, so the prompts directory must be
  # deployed alongside it. programs.opencode has no `prompts` option,
  # hence the explicit xdg.configFile entry.
  xdg.configFile."opencode/prompts" = {
    source = ./prompts;
    recursive = true;
  };

  # harness2 skill (skills/harness2 + commands/harness2.md, deployed above):
  # its experience library is mutable state the agent appends to, so it
  # can't live in the Nix store. Just make sure the directory exists.
  home.activation.opencodeHarness2 = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.xdg.dataHome}/opencode/harness2"
  '';
}
