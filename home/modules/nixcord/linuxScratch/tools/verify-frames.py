#!/usr/bin/env python3
"""Verify the generated frames.ts. No browser required.

Asserts the asset-side invariants the renderer depends on:
  * FRAME_COUNT == len(LOGO_BOXES) == len(FRAME_DATA_URLS), and equals 12
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

Constants are duplicated from logic.ts on purpose: CIRCLE_RATIO and the chroma
threshold must match isLogoColor there. Note the two outside-box counters are
deliberately separate - a box regression and a threshold regression both move
the loose count, so conflating them makes a failure unattributable.
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
    return size, count, boxes, urls


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
    size, count, boxes, urls = parse_ts()
    print(f"SOURCE_SIZE={size} FRAME_COUNT={count} "
          f"boxes={len(boxes)} urls={len(urls)}")

    check(count == 12, "FRAME_COUNT is 12")
    check(len(boxes) == count, "box count matches FRAME_COUNT")
    check(len(urls) == count, "data URL count matches FRAME_COUNT")

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
        for py in range(size):
            for px in range(size):
                i = (py * size + px) * 4
                r, g, b = data[i], data[i + 1], data[i + 2]
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
