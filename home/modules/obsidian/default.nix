#{ pkgs, lib, ... }:
#
#let
#  plugins = [
#    {
#      id = "obsidian-excalidraw-plugin";
#      repo = "zsviczian/obsidian-excalidraw-plugin";
#      version = "2.27.3";
#      description = "Sketch/whiteboard diagrams embedded in notes";
#    }
#    {
#      id = "dataview";
#      repo = "blacksmithgu/obsidian-dataview";
#      version = "0.5.70";
#      description = "Query your vault like a database";
#    }
#    {
#      id = "templater-obsidian";
#      repo = "SilentVoid13/Templater";
#      version = "2.25.0";
#      description = "Dynamic templates with variables and JS";
#    }
#    {
#      id = "obsidian-git";
#      repo = "Vinzent03/obsidian-git";
#      version = "2.39.0";
#      description = "Git backup and sync for your vault";
#    }
#    {
#      id = "obsidian-tasks-plugin";
#      repo = "obsidian-tasks-group/obsidian-tasks";
#      version = "8.4.0";
#      description = "Tasks with due dates, priorities, recurrence";
#    }
#    {
#      id = "calendar";
#      repo = "liamcain/obsidian-calendar-plugin";
#      version = "2.0.0-beta.2";
#      description = "Calendar sidebar for daily notes";
#    }
#    {
#      id = "periodic-notes";
#      repo = "liamcain/obsidian-periodic-notes";
#      version = "1.0.0-beta.3";
#      description = "Daily / weekly / monthly notes";
#    }
#    {
#      id = "quickadd";
#      repo = "chhoumann/quickadd";
#      version = "2.25.0";
#      description = "One-keystroke capture and macros";
#    }
#    {
#      id = "omnisearch";
#      repo = "scambier/obsidian-omnisearch";
#      version = "1.31.0";
#      description = "Instant full-text search";
#    }
#    {
#      id = "obsidian-linter";
#      repo = "platers/obsidian-linter";
#      version = "1.33.0";
#      description = "Consistent Markdown formatting";
#    }
#    {
#      id = "table-editor-obsidian";
#      repo = "tgrosinger/advanced-tables-obsidian";
#      version = "0.23.2";
#      description = "Spreadsheet-like Markdown tables";
#    }
#    {
#      id = "obsidian-style-settings";
#      repo = "community-archive/obsidian-style-settings";
#      version = "1.0.9";
#      description = "Tweak theme variables (pairs with Catppuccin)";
#    }
#    {
#      id = "tag-wrangler";
#      repo = "pjeby/tag-wrangler";
#      version = "0.6.5";
#      description = "Rename / merge tags safely";
#    }
#    {
#      id = "nldates-obsidian";
#      repo = "community-archive/nldates";
#      version = "0.6.4";
#      description = "Natural-language date parsing";
#    }
#    {
#      id = "cmdr";
#      repo = "jsmorabito/obsidian-commander";
#      version = "0.5.12";
#      description = "Custom buttons, macros and UI";
#    }
#    {
#      id = "obsidian-icon-folder";
#      repo = "florianwoelki/obsidian-iconize";
#      version = "2.14.7";
#      description = "Icons for folders and files";
#    }
#  ];
#
#  # Catppuccin theme (matches the rest of this setup). Pinned git tag from
#  # https://github.com/catppuccin/obsidian ; files are taken from the repo root.
#  theme = {
#    name = "catppuccin";
#    repo = "catppuccin/obsidian";
#    version = "2.0.3";
#  };
#
#  pluginLines = lib.concatMapStringsSep "\n" (p: "${p.id}|${p.repo}|${p.version}") plugins;
#  pluginList = lib.concatMapStringsSep "\n" (p: "  ${p.id} (${p.version}) - ${p.description}") plugins;
#
#  syncPlugins = pkgs.writeShellApplication {
#    name = "obsidian-sync-plugins";
#    runtimeInputs = with pkgs; [
#      curl
#      jq
#    ];
#    text = ''
#      usage() {
#        cat <<'USAGE'
#      Usage: obsidian-sync-plugins [OPTIONS] [VAULT_PATH]
#
#        Installs the pinned Obsidian community plugins + Catppuccin theme
#        into VAULT_PATH (default: $HOME/notes) and enables them.
#
#      Options:
#        --force   Re-download everything, even if already up to date
#        --list    Show the pinned plugins and exit
#        -h, --help  Show this help
#      USAGE
#      }
#
#      VAULT=""
#
#      while [ "$#" -gt 0 ]; do
#        case "$1" in
#          --force) FORCE=1 ;;
#          --list)
#            printf '%s\n' "Pinned plugins:"
#            printf '%s\n' '${pluginList}'
#            exit 0
#            ;;
#          -h|--help) usage; exit 0 ;;
#          --) shift; break ;;
#          -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
#          *)
#            if [ -z "$VAULT" ]; then VAULT="$1";
#            else echo "Unexpected argument: $1" >&2; exit 1; fi
#            ;;
#        esac
#        shift
#      done
#
#      VAULT="''${VAULT:-$HOME/notes}"      OBSIDIAN_DIR="$VAULT/.obsidian"
#      PLUGINS_DIR="$OBSIDIAN_DIR/plugins"
#      mkdir -p "$PLUGINS_DIR"
#
#      while IFS='|' read -r id repo version; do
#        [ -z "$id" ] && continue
#        dest="$PLUGINS_DIR/$id"
#        installed=""
#        if [ -f "$dest/manifest.json" ]; then
#          installed="$(jq -r '.version // empty' "$dest/manifest.json")"
#        fi
#        if [ "$FORCE" -eq 0 ] && [ "$installed" = "$version" ]; then
#          echo "ok   $id ($version)"
#          continue
#        fi
#        echo "get  $id ($version) <- $repo"
#        mkdir -p "$dest"
#        base="https://github.com/$repo/releases/download/$version"
#        curl -fsSL --retry 3 -o "$dest/main.js" "$base/main.js"
#        curl -fsSL --retry 3 -o "$dest/manifest.json" "$base/manifest.json"
#        # styles.css is optional (not every plugin ships one)
#        if ! curl -fsSL --retry 3 -o "$dest/styles.css" "$base/styles.css"; then
#          rm -f "$dest/styles.css"
#        fi
#      done <<'EOF'
#      ${pluginLines}
#      EOF
#
#      # Enable the managed plugins, preserving any extra user-enabled ones.
#      managed_json="$(printf '%s\n' ${lib.concatMapStringsSep " " (p: p.id) plugins} | jq -R . | jq -s .)"
#      enabled_file="$OBSIDIAN_DIR/community-plugins.json"
#      if [ ! -f "$enabled_file" ]; then
#        echo "[]" > "$enabled_file"
#      fi
#      tmp_enabled="$(mktemp)"
#      jq --argjson m "$managed_json" '. + $m | unique' "$enabled_file" > "$tmp_enabled"
#      mv "$tmp_enabled" "$enabled_file"
#      echo "enabled $(jq 'length' "$enabled_file") plugins in community-plugins.json"
#
#      # Catppuccin theme (matches this dotfiles setup).
#      theme_dir="$OBSIDIAN_DIR/themes/${theme.name}"
#      if [ "$FORCE" -eq 1 ] || [ ! -f "$theme_dir/theme.css" ]; then
#        echo "get  theme ${theme.name} (${theme.version}) <- ${theme.repo}"
#        mkdir -p "$theme_dir"
#        raw="https://raw.githubusercontent.com/${theme.repo}/${theme.version}"
#        curl -fsSL --retry 3 -o "$theme_dir/theme.css" "$raw/theme.css"
#        curl -fsSL --retry 3 -o "$theme_dir/manifest.json" "$raw/manifest.json"
#      else
#        echo "ok   theme ${theme.name}"
#      fi
#      appearance_file="$OBSIDIAN_DIR/appearance.json"
#      if [ ! -f "$appearance_file" ]; then
#        echo '{}' > "$appearance_file"
#      fi
#      if [ "$FORCE" -eq 1 ] || [ -z "$(jq -r '.cssTheme // empty' "$appearance_file")" ]; then
#        tmp_appearance="$(mktemp)"
#        jq '.cssTheme = "${theme.name}"' "$appearance_file" > "$tmp_appearance"
#        mv "$tmp_appearance" "$appearance_file"
#      fi
#
#      echo "Done. Vault: $VAULT"
#      echo "In Obsidian: open the vault, then Settings -> Community plugins -> turn off Restricted mode."
#    '';
#  };
#in
#{
#  home.packages = [
#    pkgs.obsidian
#    syncPlugins
#  ];
#}

{ pkgs, ... }:
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

    defaultSettings = {
      #      communityPlugins = [
      #        {
      #          pkg = pkgs.callPackage ./config/plugins/obsidian-dataview { };
      #          settings = {
      #            # plugin-specific settings
      #          };
      #        }
      #
      #        {
      #          pkg = pkgs.callPackage ./config/plugins/obsidian-excalidraw { };
      #          settings = { };
      #        }
      #      ];
    };
  };
}
