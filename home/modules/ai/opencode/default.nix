{
  programs.opencode = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./opencode.json);
    tui = builtins.fromJSON (builtins.readFile ./tui.json);
    agents = ./agents;
    skills = ./skills;
  };
}
