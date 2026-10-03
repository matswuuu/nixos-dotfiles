#!/usr/bin/env python3
"""Verify the generated frames.ts. No browser required.

Asserts:
  * FRAME_COUNT == len(LOGO_BOXES) == len(FRAME_DATA_URLS)
  * every frame decodes and is SOURCE_SIZE x SOURCE_SIZE
  * logo boxes are consistent (~114x114) and inside the frame
  * the runtime keying predicate leaves ZERO logo-blue pixels outside the
    circle, for every frame  (CIRCLE_RATIO must match render.ts)
"""
import base64
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

    total_leftover = 0
    for k, ((x, y, w, h), url) in enumerate(zip(boxes, urls)):
        data = decode(url, size)
        if len(data) != size * size * 4:
            failures.append(f"frame {k}: decoded {len(data)} bytes, expected {size * size * 4}")
            print(f"  FAIL frame {k}: decoded {len(data)} bytes, expected {size * size * 4}")
            continue
        cx, cy = x + w / 2.0, y + h / 2.0
        rad = min(w, h) / 2.0 * CIRCLE_RATIO
        leftover = 0
        for py in range(y, y + h):
            for px in range(x, x + w):
                i = (py * size + px) * 4
                dx, dy = px + 0.5 - cx, py + 0.5 - cy
                if dx * dx + dy * dy <= rad * rad:
                    continue          # inside the avatar circle: avatar shows
                if is_logo(data[i], data[i + 1], data[i + 2]):
                    leftover += 1
        total_leftover += leftover

    check(len(failures) == 0, f"every frame decodes to {size}x{size} RGBA")
    check(total_leftover == 0,
          f"zero logo pixels survive keying (found {total_leftover})")

    print()
    if failures:
        print(f"FAILED: {len(failures)} check(s)")
        return 1
    print("all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
