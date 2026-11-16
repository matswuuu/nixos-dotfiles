{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    # nixpkgs' node_modules FOD hash for opencode 2.2.6 doesn't match what bun
    # actually produces. Drop this override once nixpkgs fixes the hash.
    package = pkgs.opencode.overrideAttrs (old: {
      node_modules = old.node_modules.overrideAttrs {
        outputHash = "sha256-UOF9owEBSuVKX/hBhef7Wr4ymlNgTL21BiVBr+9a8Zo=";
      };
    });
    settings = builtins.fromJSON (builtins.readFile ./opencode.json);
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
}
