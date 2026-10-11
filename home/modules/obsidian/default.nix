{
  pkgs,
  ...
}:

{
  programs.obsidian = {
    enable = true;

    vaults = {
      work = {
        target = "Documents/Obsidian/Work";
      };
      personal = {
        target = "Documents/Obsidian/Personal";
      };
    };

    defaultSettings.communityPlugins =
      let
        plugins = pkgs.obsidianPlugins;
      in
      map
        (id: {
          pkg = plugins.${id};
        })
        [
          "dataview"
          "templater-obsidian"
          "obsidian-git"
          "obsidian-tasks-plugin"
          "calendar"
          "periodic-notes"
          "quickadd"
          "omnisearch"
          "obsidian-linter"
          "table-editor-obsidian"
          "obsidian-outliner"
          "obsidian-excalidraw-plugin"
        ];
  };
}
