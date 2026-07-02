{ pkgs, lib, ... }:

let
  glibc_43 = pkgs.callPackage ../glibc-2.43.nix { };

  # Pre-computed store paths used by the wrapper script.
  glibc_43_store = "${glibc_43}";
  zlib_store     = "${lib.getLib pkgs.zlib}";
  gcc_store      = "${lib.getLib pkgs.gcc.cc.lib}";
  patchelf_bin   = "${lib.getBin pkgs.patchelf}/bin/patchelf";

  # Wrapper script that patches Java's interpreter to use glibc 2.43's ld-linux.
  # This avoids rebuilding the entire OpenJDK and all its transitive dependencies
  # against a custom glibc — we just swap the ELF interpreter at runtime.
  #
  # Additionally, Cristalix downloads its OWN bundled JRE from the server to
  # ~/.cristalix/runtime/.  That JRE is linked against glibc 2.43, so we also
  # patch its java binary (and set LD_LIBRARY_PATH appropriately) so the
  # spawned subprocess uses our glibc 2.43 as well.
  #
  # IMPORTANT: glibc 2.43's ld-linux is compiled without FHS paths
  # (/usr/lib64 etc.) and with its own ld.so.cache location that the FHS env
  # doesn't populate.  So for Java processes (which use the patched glibc 2.43
  # ld-linux), we must add both $GLIBC_43/lib AND the FHS paths to
  # LD_LIBRARY_PATH.  For non-Java commands (bash, python, etc.) that use the
  # FHS env's native glibc 2.42, we MUST NOT add $GLIBC_43/lib — mixing glibc
  # versions in the same process causes "stack smashing detected" crashes.
  #
  # Options:
  #   -m, --memory <limit>   Launch via systemd-run with MemoryMax=<limit>
  #                           (e.g. --memory=4G, -m 8G)
  #
  # Behaviour:
  # - If positional arguments are provided, they are executed directly (with
  #   FHS lib paths but NO glibc 2.43 path). This allows testing/debugging
  #   without crashes.
  # - If no positional arguments, patches all known JRE binaries and launches
  #   CristalixLauncher.jar (with glibc 2.43 path included).
  runScript = pkgs.writeShellScript "cristalix-wrapper" ''
    set -euo pipefail

    GLIBC_43="${glibc_43_store}"
    ZLIB_DIR="${zlib_store}/lib"
    GCC_DIR="${gcc_store}/lib"
    PATCHELF="${patchelf_bin}"
    LAUNCHER="$HOME/Downloads/CristalixLauncher.jar"
    CRISTALIX_RUNTIME="$HOME/.cristalix/runtime"
    DOWNLOADED_JAVA="$CRISTALIX_RUNTIME/bin/java"

    # --- Library path components ---
    FHS_LIB_PATH="/usr/lib64:/usr/lib:/lib64:/lib"
    JAVA_LIB_PATH="$GLIBC_43/lib:$FHS_LIB_PATH:$ZLIB_DIR:$GCC_DIR"

    # --- Parse options ---
    MEMORY_LIMIT=
    while [ $# -gt 0 ]; do
      case "$1" in
        --memory=*)
          MEMORY_LIMIT="''${1#--memory=}"
          shift
          ;;
        -m)
          MEMORY_LIMIT="$2"
          shift 2
          ;;
        --memory)
          MEMORY_LIMIT="$2"
          shift 2
          ;;
        --help|-h)
          echo "Usage: cristalix-fhs [options] [command...]"
          echo ""
          echo "Options:"
          echo "  -m, --memory <limit>   Launch via systemd-run with MemoryMax=<limit>"
          echo "                           (e.g. -m 4G, --memory=8G)"
          echo "  -h, --help             Show this help"
          echo ""
          echo "Without positional arguments, launches the Cristalix launcher."
          echo "With positional arguments, runs them inside the FHS environment."
          exit 0
          ;;
        --)
          shift
          break
          ;;
        -*)
          echo "Unknown option: $1" >&2
          echo "Try --help for usage." >&2
          exit 1
          ;;
        *)
          break
          ;;
      esac
    done

    # --- Utility: patch a binary's interpreter to use glibc 2.43's ld-linux ---
    # Leaves the file writable so applications (like the launcher) can still
    # modify the downloaded JRE if needed.
    patch_binary() {
      local bin="$1"
      if [ -f "$bin" ] && [ -x "$bin" ]; then
        # Check if already patched
        if LANG=C readelf -l "$bin" 2>/dev/null | grep -q "$GLIBC_43/lib/ld-linux"; then
          return 0
        fi
        chmod +w "$bin" 2>/dev/null || true
        "$PATCHELF" --set-interpreter "$GLIBC_43/lib/ld-linux-x86-64.so.2" "$bin" || true
      fi
    }

    # --- Patch the downloaded JRE (if already present) ---
    # NOTE: we do NOT add $CRISTALIX_RUNTIME/lib to LD_LIBRARY_PATH here.
    # The downloaded JRE's java binary already has RPATH=$ORIGIN:$ORIGIN/../lib
    # which finds its own native libraries.  Adding them globally would conflict
    # with the system OpenJDK's native libraries (different versions).
    if [ -f "$DOWNLOADED_JAVA" ]; then
      patch_binary "$DOWNLOADED_JAVA"
    fi

    # --- Start a background watcher for the downloaded JRE ---
    # On first run, the launcher downloads the JRE to ~/.cristalix/runtime/
    # after we've already started.  We watch for the java binary to appear
    # and patch it immediately so the subprocess uses our glibc 2.43.
    if ! [ -f "$DOWNLOADED_JAVA" ]; then
      # Watch the .cristalix directory for the downloaded java binary.
      # We use a brief poll loop since inotifywait may not always be reliable
      # inside the FHS sandbox.
      (
        for i in $(seq 1 60); do
          if [ -f "$DOWNLOADED_JAVA" ]; then
            patch_binary "$DOWNLOADED_JAVA"
            break
          fi
          sleep 1
        done
      ) &
    fi

    # If positional arguments remain, run those instead of the default launcher.
    # Use ONLY FHS paths here (no glibc 2.43), so FHS-native tools (bash,
    # python, etc.) don't crash from mixing glibc versions.
    if [ $# -gt 0 ]; then
      export LD_LIBRARY_PATH="$FHS_LIB_PATH''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec "$@"
    fi

    # --- Default: run Cristalix launcher with patched system Java ---
    JAVA_BIN="$(readlink -f "$(type -p java)")"
    PATCHED_JAVA="/tmp/.cristalix-java.$$"

    # Copy, make writable, and patch the system java binary to use glibc 2.43's
    # dynamic linker.  We use a PID-tagged temp file so concurrent launches
    # don't collide.
    if ! [ -f "$PATCHED_JAVA" ]; then
      cp "$JAVA_BIN" "$PATCHED_JAVA"
      chmod +w "$PATCHED_JAVA"
      "$PATCHELF" \
        --set-interpreter "$GLIBC_43/lib/ld-linux-x86-64.so.2" \
        "$PATCHED_JAVA"
      chmod -w "$PATCHED_JAVA"
    fi

    # Set the full Java lib path (glibc 2.43 + FHS) and launch.
    # Unset WAYLAND_DISPLAY so that LWJGL/GLFW uses X11 instead of Wayland.
    # The Wayland compositor connection can fail inside the FHS sandbox, causing
    # GLFW init to fail even though X11 works fine.
    unset WAYLAND_DISPLAY
    export LD_LIBRARY_PATH="$JAVA_LIB_PATH''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    if [ -n "$MEMORY_LIMIT" ]; then
      SYSTEMD_RUN="/run/current-system/sw/bin/systemd-run"
      if [ -x "$SYSTEMD_RUN" ]; then
        exec "$SYSTEMD_RUN" --user --scope -p "MemoryMax=$MEMORY_LIMIT" \
          "$PATCHED_JAVA" -jar "$LAUNCHER"
      else
        echo "Warning: systemd-run not found at $SYSTEMD_RUN, ignoring --memory" >&2
        exec "$PATCHED_JAVA" -jar "$LAUNCHER"
      fi
    else
      exec "$PATCHED_JAVA" -jar "$LAUNCHER"
    fi
  '';

in
pkgs.buildFHSEnv {
  pname = "cristalix-fhs";
  version = "0.6";

  meta = {
    description = "FHS environment for Cristalix launcher (glibc 2.43)";
    platforms = lib.platforms.linux;
  };

  # 64-bit target packages — these get symlinked into the FHS rootfs.
  targetPkgs = p: with p; [
    # Java runtime
    openjdk

    # X11 & graphics libraries (needed by JavaFX / LWJGL)
    libx11
    libxext
    libxcursor
    libxrandr
    libxxf86vm
    libxi
    libxtst
    libXrender
    libXcomposite
    libXdamage
    libXinerama
    libGL
    libGLU

    # GTK3 + transitive deps (needed by JavaFX glass GTK library).
    # buildFHSEnv does NOT automatically pull transitive deps, so we must
    # list them all explicitly.
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    harfbuzz
    at-spi2-atk          # provides libatk-1.0.so
    libepoxy

    # Audio
    alsa-lib
    libpulseaudio

    # Fonts & text
    fontconfig
    freetype

    # Input & rendering
    libxkbcommon
    libdrm

    # Game/GL libraries (used by LWJGL in game client)
    glfw
    glew

    # stdc++ & zlib (needed by many native libs, including downloaded JRE)
    gcc.cc.lib
    zlib

    # General utilities + patchelf for our wrapper
    bash
    coreutils
    patchelf
  ];

  # 32-bit packages (disabled — multiArch defaults to false)
  multiPkgs = p: [ ];

  inherit runScript;
}
