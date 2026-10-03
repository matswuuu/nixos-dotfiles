#!/usr/bin/env python3
"""Verify the generated frames.ts. No browser required.

Asserts the asset-side invariants the renderer depends on:
  * FRAME_COUNT == len(LOGO_BOXES) == len(FRAME_DATA_URLS), and equals 12
  * every frame decodes to SOURCE_SIZE x SOURCE_SIZE
  * logo boxes are consistent (~114x114) and lie inside the frame
  * the logo extends BEYOND the avatar circle - the fact that makes a
    box-bounded erase region mandatory (see eraseRegion in logic.ts)
  * the chroma test barely fires outside the logo box, so keying can never
    reach Tux, the LINUX text, or the background

CIRCLE_RATIO must match logic.ts; the chroma threshold must match
isLogoColor in logic.ts.

Deliberately NOT asserted: "zero leftover logo pixels". Modelled faithfully
that is true by construction - the renderer erases every flagged pixel it
visits - so such a check would assert nothing. The two invariants above are
the falsifiable guards.
"""

import base64
import math
import pathlib
import re
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
FRAMES_TS = HERE.parent / "frames.ts"

# Must match render.ts
CIRCLE_RATIO = 0.9

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
    return run(["ffmpeg", "-v", "error", "-i", str(png), "-f", "rawvideo",
                "-pix_fmt", "rgba", "-"])


def is_logo(r, g, b):
    """Runtime keying test - must match render.ts isLogoColor."""
    return b - (r + g) / 2.0 > 10


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
        data = decode(url, size)
        if len(data) != size * size * 4:
            failures.append(f"frame {k}: decoded {len(data)} bytes, expected {size * size * 4}")
            print(f"  FAIL frame {k}: decoded {len(data)} bytes, expected {size * size * 4}")
            continue
        cx, cy = x + w / 2.0, y + h / 2.0
        rad = min(w, h) / 2.0 * CIRCLE_RATIO
        outside = 0        # flagged outside the box: must stay negligible
        max_r = 0.0        # farthest flagged pixel from the box centre
        for py in range(size):
            for px in range(size):
                i = (py * size + px) * 4
                if not is_logo(data[i], data[i + 1], data[i + 2]):
                    continue
                if x <= px < x + w and y <= py < y + h:
                    max_r = max(max_r, math.hypot(px + 0.5 - cx, py + 0.5 - cy))
                else:
                    outside += 1
        if max_r <= rad * 1.05:
            print(f"  FAIL frame {k}: logo reaches only {max_r:.1f}px vs circle "
                  f"{rad:.1f}px - if the logo ever fit inside the circle a "
                  f"circle-bounded erase region would become correct")
            failures.append(f"frame {k}: logo does not extend past the circle")
        # ~886 hits/frame observed, from h264 noise on white. 2% of the frame
        # is a wide bound that a too-permissive threshold overruns by ~250x.
        if outside > 0.02 * size * size:
            print(f"  FAIL frame {k}: chroma test flagged {outside} pixels "
                  f"outside the logo box "
                  f"({100.0 * outside / (size * size):.1f}% of frame) - "
                  f"threshold too permissive")
            failures.append(f"frame {k}: {outside} stray keying hits")

    check(len(failures) == 0, "per-frame invariants hold")

    print()
    if failures:
        print(f"FAILED: {len(failures)} check(s)")
        return 1
    print("all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
