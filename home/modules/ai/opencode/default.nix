{ ... }:
{
  programs.opencode = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./opencode.json);
    tui = builtins.fromJSON (builtins.readFile ./tui.json);
    agents = ./agents;
    skills = ./skills;
    commands = ./commands;
  };

  # opencode.json references {file:./prompts/*.md} relative to
  # ~/.config/opencode/opencode.json, so the prompts directory must be
  # deployed alongside it. programs.opencode has no `prompts` option,
  # hence the explicit xdg.configFile entry.
  xdg.configFile."opencode/prompts" = {
    source = ./prompts;
    recursive = true;
  };
}
