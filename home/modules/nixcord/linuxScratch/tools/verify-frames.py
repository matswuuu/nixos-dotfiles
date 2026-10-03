#!/usr/bin/env python3
"""Verify the generated frames.ts. No browser required.

Decodes the 12 PNGs inlined in frames.ts and measures them against the box
table already baked into that same file. It does NOT re-derive either table from
the source video: it never reads work/, never touches the MP4, and never re-runs
the box detector. Requires ffmpeg on PATH (12 invocations; without it this dies
with FileNotFoundError).

Asserts the asset-side invariants the renderer depends on:
  * FRAME_COUNT == len(LOGO_BOXES) == len(FRAME_DATA_URLS), and equals 12
  * FRAME_SOURCE_INDICES == range(0, 68, 6) - the sampling that justifies
    REAL_TIME_DELAY_MS (68 frames at 30fps over 12 output frames = 189ms). If a
    regeneration changed the sampling, that constant's derivation would be
    silently wrong, and nothing else here would notice.
  * every frame decodes to SOURCE_SIZE x SOURCE_SIZE
  * logo boxes are consistent and lie inside the frame
  * saturated logo pixels outside the logo box stay at or below
    SAT_OUTSIDE_MAX. This is the load-bearing one: the renderer's erase region
    IS the box (see eraseRegion in logic.ts), so logo pixels outside it are
    never erased and survive into the GIF as a blue fringe. This check is what
    catches a box that under-covers the logo.
  * the logo extends BEYOND the avatar circle - the fact that makes a
    box-bounded erase region necessary at all
  * loose chroma hits outside the box stay under 2% of the frame, bounding how
    far a too-permissive threshold could reach beyond the logo
  * art pixels (neither logo-blue nor near-white) exist inside the avatar
    circle, and near-white pixels do too. See ART_IN_CIRCLE_MIN below - these
    pin the two halves of the renderer's erase rule.

Constants are duplicated from logic.ts on purpose: CIRCLE_RATIO and the chroma
threshold must match isLogoColor there. Note the two outside-box counters are
deliberately separate - a box regression and a threshold regression both move
the loose count, so conflating them makes a failure unattributable.

Two limitations, both structural:

  * strict_logo below is duplicated from generate-frames.py, so a
    mis-specified blue predicate leaves generator and verifier agreeing and the
    suite green.
  * the GEOMETRY is not independently checked either. The boxes in frames.ts
    were measured from these same PNGs, so a systematically wrong box agrees
    with the frames it came from. This suite catches box regressions relative to
    the frames (a shrink, a drift), NOT a box that was wrong from the start.
    Cross-checking against the video would mean re-running the detector.
"""

import base64
import math
import pathlib
import re
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
FRAMES_TS = HERE.parent / "frames.ts"

# Must match logic.ts
CIRCLE_RATIO = 0.9

# Saturated logo pixels permitted outside the box, per frame.
#
# The box is built from blue connected components of >= MIN_PANE_PX pixels, so
# isolated 1-2px h264 specks are excluded by construction - and those same specks
# are then, by construction, outside the box. Measured residual: 0-4 px/frame.
#
# The failure this bound exists to catch is systematic edge under-coverage, which
# measured 67-128 px/frame as a continuous band along all four sides when the box
# was clipped to the 0.5-99.5 percentile. A bound of 8 sits ~16x below that
# failure mode while tolerating the specks, so it still goes loudly red on any
# real regression. Raising MIN_PANE_PX would remove the specks from the count but
# reintroduces the 135-138px outlier box, which is far worse.
SAT_OUTSIDE_MAX = 8

# Near-white threshold. Must match the renderer's erase rule in render.ts, which
# erases logo-blue OR (r > 200 and g > 200 and b > 200) inside the circle.
WHITE_LEVEL = 200

# Art pixels (neither logo-blue nor near-white) required inside the avatar
# circle, per frame. These are Tux's body, beak and flipper - the claw that
# reaches into the circle.
#
# This pins BOTH halves of the renderer's erase rule, which is the whole reason
# it is written as "erase logo-or-background" rather than "erase the circle":
#
#   * art > 0: there IS non-logo art inside the circle. Measured 649-2327 per
#     frame. If it were 0, erasing the entire circle interior would be safe and
#     the renderer's `if (!erase) continue` guard would be dead code. A drop to
#     0 means the asset changed and the guard no longer has anything to protect.
#   * near-white > 0: near-white must stay in the erase set. Without it the
#     avatar would show only through the four window panes (which are exactly
#     the blue pixels) instead of as a circle. Measured 1069-2135 per frame.
#
# A failure here is a prompt to re-examine the erase rule, not to edit this
# number: it is a floor on measured reality, not a tunable target.
ART_IN_CIRCLE_MIN = 1
WHITE_IN_CIRCLE_MIN = 1

# Source frames sampled, and the step between them. 68 frames at 30fps over 12
# output frames gives 188.9ms, which is where REAL_TIME_DELAY_MS = 189 in
# logic.ts comes from. The step is ceil(68 / 12) = 6, so the sampling is
# 0, 6, ..., 66.
SOURCE_FRAME_COUNT = 68
SOURCE_FRAME_STEP = 6

failures = []


def check(cond, msg):
    if cond:
        print(f"  ok   {msg}")
    else:
        print(f"  FAIL {msg}")
        failures.append(msg)


def run(cmd):
    return subprocess.run(cmd, check=True, capture_output=True).stdout


def parse_ts():
    src = FRAMES_TS.read_text()
    size = int(re.search(r"SOURCE_SIZE = (\d+)", src).group(1))
    count = int(re.search(r"FRAME_COUNT = (\d+)", src).group(1))
    boxes = [
        (int(a), int(b), int(c), int(d))
        for a, b, c, d in re.findall(
            r"\{\s*x:\s*(\d+),\s*y:\s*(\d+),\s*w:\s*(\d+),\s*h:\s*(\d+)\s*\}", src)
    ]
    urls = re.findall(r'"(data:image/png;base64,[A-Za-z0-9+/=]+)"', src)
    m = re.search(r"FRAME_SOURCE_INDICES[^=]*=\s*\[([^\]]*)\]", src)
    indices = [int(v) for v in re.findall(r"\d+", m.group(1))] if m else []
    return size, count, boxes, urls, indices


def decode(data_url, size):
    raw = base64.b64decode(data_url.split(",", 1)[1])
    png = HERE.parent / "work" / "_verify.png"
    png.parent.mkdir(parents=True, exist_ok=True)
    png.write_bytes(raw)
    data = run(["ffmpeg", "-v", "error", "-i", str(png), "-f", "rawvideo",
                "-pix_fmt", "rgba", "-"])
    if len(data) != size * size * 4:
        raise SystemExit(f"frame decoded to {len(data)} bytes, expected {size * size * 4}")
    return data


def is_logo(r, g, b):
    """Runtime keying test - must match isLogoColor in logic.ts."""
    return b - (r + g) / 2.0 > 10


def is_white(r, g, b):
    """Near-white background - must match the renderer's second erase term."""
    return r > WHITE_LEVEL and g > WHITE_LEVEL and b > WHITE_LEVEL


def strict_logo(r, g, b):
    """Saturated logo blue - the offline box detector's predicate.

    Duplicated from generate-frames.py on purpose, and that duplication is a
    real limit on what this suite can detect: the saturated-outside-box check
    catches box-geometry regressions, but because generator and verifier share
    this predicate, a mis-specified predicate (too strict, so the box clips the
    logo; too loose, so noise sets the extent) would leave both agreeing and the
    suite green.
    """
    return b > 150 and b - r > 80 and b - g > 40 and r < 110


def main():
    size, count, boxes, urls, indices = parse_ts()
    print(f"SOURCE_SIZE={size} FRAME_COUNT={count} "
          f"boxes={len(boxes)} urls={len(urls)}")

    check(count == 12, "FRAME_COUNT is 12")
    check(len(boxes) == count, "box count matches FRAME_COUNT")
    check(len(urls) == count, "data URL count matches FRAME_COUNT")
    check(indices == list(range(0, SOURCE_FRAME_COUNT, SOURCE_FRAME_STEP)),
          f"FRAME_SOURCE_INDICES is range(0, {SOURCE_FRAME_COUNT}, "
          f"{SOURCE_FRAME_STEP}): {indices}")

    widths = [b[2] for b in boxes]
    heights = [b[3] for b in boxes]
    check(all(100 <= v <= 130 for v in widths),
          f"box widths in [100,130]: {min(widths)}..{max(widths)}")
    check(all(100 <= v <= 130 for v in heights),
          f"box heights in [100,130]: {min(heights)}..{max(heights)}")
    check(max(widths) - min(widths) <= 4 and max(heights) - min(heights) <= 4,
          "box sizes consistent across frames")
    check(all(0 <= x and 0 <= y and x + w <= size and y + h <= size
              for x, y, w, h in boxes),
          "all boxes lie inside the frame")

    for k, ((x, y, w, h), url) in enumerate(zip(boxes, urls)):
        # decode() raises SystemExit on a length mismatch, so no re-check here.
        data = decode(url, size)
        cx, cy = x + w / 2.0, y + h / 2.0
        rad = min(w, h) / 2.0 * CIRCLE_RATIO
        loose_outside = 0   # loosely-flagged outside the box: bounded, not zero
        sat_outside = 0     # saturated logo outside the box: must be exactly 0
        max_r = 0.0         # farthest flagged pixel from the box centre
        in_circle = 0       # pixels inside the avatar circle
        in_logo = 0         #   of which logo-blue: always erased
        in_white = 0        #   of which near-white: erased, so the avatar shows
        in_art = 0          #   of which neither: Tux, preserved opaque
        for py in range(size):
            for px in range(size):
                i = (py * size + px) * 4
                r, g, b = data[i], data[i + 1], data[i + 2]
                if math.hypot(px + 0.5 - cx, py + 0.5 - cy) <= rad:
                    in_circle += 1
                    if is_logo(r, g, b):
                        in_logo += 1
                    elif is_white(r, g, b):
                        in_white += 1
                    else:
                        in_art += 1
                loose = is_logo(r, g, b)
                if not loose and not strict_logo(r, g, b):
                    continue
                inside = x <= px < x + w and y <= py < y + h
                if inside:
                    if loose:
                        max_r = max(max_r, math.hypot(px + 0.5 - cx, py + 0.5 - cy))
                else:
                    if loose:
                        loose_outside += 1
                    if strict_logo(r, g, b):
                        sat_outside += 1
        print(f"  frame {k:>2}: logo overhang {max_r / rad:.2f}x circle, "
              f"saturated outside box {sat_outside}, "
              f"loose outside box {loose_outside} "
              f"({100.0 * loose_outside / (size * size):.2f}% of frame)")
        print(f"           in circle {in_circle}: logo {in_logo}, white {in_white}, "
              f"art {in_art} ({100.0 * in_art / in_circle:.1f}% preserved)")
        if sat_outside > SAT_OUTSIDE_MAX:
            print(f"  FAIL frame {k}: {sat_outside} saturated logo pixels lie "
                  f"OUTSIDE the logo box (max {SAT_OUTSIDE_MAX}) - the erase "
                  f"region is the box, so these are never erased and will "
                  f"fringe the output")
            failures.append(f"frame {k}: {sat_outside} saturated logo px outside box")
        if max_r <= rad * 1.05:
            print(f"  FAIL frame {k}: logo reaches only {max_r:.1f}px vs circle "
                  f"{rad:.1f}px - the logo no longer extends past the circle")
            failures.append(f"frame {k}: logo does not extend past the circle")
        if in_art < ART_IN_CIRCLE_MIN:
            print(f"  FAIL frame {k}: only {in_art} art pixels inside the circle - "
                  f"the renderer's `if (!erase) continue` guard would have nothing "
                  f"to protect, so erasing the whole circle interior would be safe "
                  f"again. Re-examine the erase rule.")
            failures.append(f"frame {k}: no art inside circle")
        if in_white < WHITE_IN_CIRCLE_MIN:
            print(f"  FAIL frame {k}: no near-white inside the circle - dropping "
                  f"white from the erase set would no longer turn the avatar into "
                  f"four window panes, so that half of the rule is unverified")
            failures.append(f"frame {k}: no near-white inside circle")
        # ~570 non-logo hits/frame observed (watermark/antialiasing). 2% of the
        # frame is a wide bound a too-permissive threshold overruns by ~250x.
        if loose_outside > 0.02 * size * size:
            print(f"  FAIL frame {k}: chroma test flagged {loose_outside} pixels "
                  f"outside the logo box ({100.0 * loose_outside / (size * size):.1f}% "
                  f"of frame) - threshold too permissive")
            failures.append(f"frame {k}: {loose_outside} loose keying hits")

    check(len(failures) == 0, "per-frame invariants hold")

    print()
    if failures:
        print(f"FAILED: {len(failures)} check(s)")
        return 1
    print("all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
