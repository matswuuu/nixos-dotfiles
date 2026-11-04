{ lib, ... }:

let
  # Enforced in ~/.gradle/gradle.properties, which also holds credentials and
  # therefore can't be generated into the Nix store. Only these keys are
  # rewritten; every other line in the file is preserved.
  # User-home properties take precedence over project ones, so jvmargs and
  # worker counts are deliberately left to each project.
  properties = {
    # Daemon is started via `nice -n 10`; workers and the Kotlin daemon
    # it forks inherit the niceness.
    "org.gradle.priority" = "low";
    # 10 min instead of 3 h: idle daemons (one per Gradle version / JDK /
    # jvmargs combination, each with -Xmx4g) were pushing the system into swap.
    "org.gradle.daemon.idletimeout" = toString (10 * 60 * 1000);
  };

  beginMarker = "# BEGIN home-manager managed";
  endMarker = "# END home-manager managed";

  deleteKeys = lib.concatMapStrings (
    key: " -e '/^[[:space:]]*${lib.escapeRegex key}[[:space:]]*[=:]/d'"
  ) (lib.attrNames properties);

  block = lib.concatStringsSep "\n" (
    [ beginMarker ] ++ lib.mapAttrsToList (k: v: "${k}=${v}") properties ++ [ endMarker ]
  );
in
{
  home.activation.gradleProperties = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    gradleProps="''${GRADLE_USER_HOME:-$HOME/.gradle}/gradle.properties"
    run mkdir -p "$(dirname "$gradleProps")"
    [ -e "$gradleProps" ] || run install -m 600 /dev/null "$gradleProps"

    if [ -e "$gradleProps" ]; then
      gradleTmp="$(mktemp "$gradleProps.XXXXXX")"
      sed -e '/^${beginMarker}$/,/^${endMarker}$/d'${deleteKeys} -e '$a\' "$gradleProps" > "$gradleTmp"
      cat >> "$gradleTmp" <<'EOF'
    ${block}
    EOF
      if ! cmp -s "$gradleTmp" "$gradleProps"; then
        run chmod --reference="$gradleProps" "$gradleTmp"
        run mv "$gradleTmp" "$gradleProps"
      fi
      rm -f "$gradleTmp"
    fi
  '';
}
