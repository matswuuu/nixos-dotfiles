#!/usr/bin/env python3
"""Extract LinuxScratch animation frames + logo boxes from the source MP4.

Emits frames.ts. Idempotent: re-run after changing FRAME_INDICES or SOURCE_SIZE.

Requires only ffmpeg/ffprobe and the Python standard library (no numpy/PIL).
"""
import base64
import hashlib
import pathlib
import shutil
import subprocess
import sys

MP4_URL = ("https://images-ext-1.discordapp.net/external/"
            "SKWCEMu_kV8ufSWZrfLelPjNe0RZ04vKBxwIeRZPNlo/"
            "https/media.tenor.com/oFwxiOFZMMcAAAPo/linux-unix.mp4")
HERE = pathlib.Path(__file__).resolve().parent
WORK = HERE.parent / "work"
OUT_TS = HERE.parent / "frames.ts"

SOURCE_SIZE = 498
FRAME_COUNT = 12
# The logo animates across source frames 0..67 then holds static; sample the
# animated range only. ceil(68/12) = 6, giving exactly the 12 indices
# 0, 6, 12, ... 66. Real-time playback = 68/30/12 = 188.9 ms per frame.
ANIMATED_SOURCE_FRAMES = 68
FRAME_INDICES = list(
    range(0, ANIMATED_SOURCE_FRAMES,
          -(-ANIMATED_SOURCE_FRAMES // FRAME_COUNT)))[:FRAME_COUNT]
if len(FRAME_INDICES) != FRAME_COUNT or FRAME_INDICES[-1] != 66:
    raise SystemExit(f"FRAME_INDICES wrong: {FRAME_INDICES}")
PALETTE_COLORS = 32  # flat art; higher only absorbs h264 noise

# Strict blue test used for OFFLINE box detection. The runtime keying test is
# looser (see render.ts isLogoColor) - this one must NOT fire on background
# noise, so it is deliberately narrow.
def strict_blue(r, g, b):
    return b > 150 and b - r > 80 and b - g > 40 and r < 110


def run(cmd, **kw):
    return subprocess.run(cmd, check=True, capture_output=True, **kw)


def probe(path):
    out = run(["ffprobe", "-v", "error", "-select_streams", "v:0",
               "-show_entries", "stream=width,height,nb_frames",
               "-of", "csv=p=0", str(path)]).stdout.decode().strip()
    parts = out.strip().split(",")
    if len(parts) != 3 or not all(p.isdigit() for p in parts):
        raise SystemExit(f"unexpected ffprobe output: {out!r}")
    return int(parts[0]), int(parts[1]), int(parts[2])


def decode_rgba(path, size):
    data = run(["ffmpeg", "-v", "error", "-i", str(path), "-f", "rawvideo",
                "-pix_fmt", "rgba", "-"]).stdout
    if len(data) != size * size * 4:
        raise SystemExit(f"{path} decoded to {len(data)} bytes, expected {size * size * 4}")
    return data


MIN_PANE_PX = 3


def robust_box(data, w, h):
    """Union bounding box of the logo's blue panes.

    Naive min/max is wrong: isolated h264 noise pixels stretch the box (one
    frame measured w=128 against a true 120). Clipping to the 0.5-99.5
    percentile is ALSO wrong, and worse - it shrinks the box *inside* the real
    logo, leaving 67-128 saturated logo pixels per frame outside the erase
    region, which then survive into the GIF as a blue fringe.

    So: flood-fill the blue mask, keep components of at least MIN_PANE_PX
    pixels, and take the union of their bounding boxes. That rejects strays
    without clipping real extent.

    MIN_PANE_PX = 3 is measured, not guessed. At 1 or 2 the box stretches to
    135-138px wide on frame 3 because isolated noise specks survive; at 3 and
    above the widths settle to 118-122 with a spread of 4px, identical to a
    50px threshold. Below 3 there are strays, at 3 there are none.
    """
    mask = bytearray(w * h)
    for y in range(h):
        row = y * w * 4
        base = y * w
        for x in range(w):
            i = row + x * 4
            if strict_blue(data[i], data[i + 1], data[i + 2]):
                mask[base + x] = 1

    seen = bytearray(w * h)
    panes = []
    for start in range(w * h):
        if not mask[start] or seen[start]:
            continue
        stack = [start]
        seen[start] = 1
        n = 0
        x0 = y0 = 1 << 30
        x1 = y1 = -1
        while stack:
            p = stack.pop()
            n += 1
            py, px = divmod(p, w)
            if px < x0: x0 = px
            if px > x1: x1 = px
            if py < y0: y0 = py
            if py > y1: y1 = py
            # Row-bounded neighbours. Plain p-1 / p+1 would wrap from column 0
            # to the end of the previous row, silently merging unrelated
            # components and corrupting the box. Unreachable for the current
            # asset (no blue in those columns) but this is the one thing that
            # must hold for the box to mean anything.
            for q in ((p - 1) if px > 0 else -1,
                      (p + 1) if px < w - 1 else -1,
                      p - w if py > 0 else -1,
                      p + w if py < h - 1 else -1):
                if q >= 0 and mask[q] and not seen[q]:
                    seen[q] = 1
                    stack.append(q)
        if n >= MIN_PANE_PX:
            panes.append((x0, y0, x1, y1))

    if not panes:
        raise SystemExit("no logo-blue panes found")
    bx0 = min(p[0] for p in panes)
    by0 = min(p[1] for p in panes)
    bx1 = max(p[2] for p in panes)
    by1 = max(p[3] for p in panes)
    return {"x": bx0, "y": by0, "w": bx1 - bx0 + 1, "h": by1 - by0 + 1}


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    mp4 = WORK / "linux-unix.mp4"
    if not mp4.exists():
        print(f"downloading {MP4_URL}")
        # -f so an HTTP error is a non-zero exit rather than a saved HTML page
        run(["curl", "-sfL", "-o", str(mp4), MP4_URL])
    # Checked unconditionally: a previously-downloaded HTML error page would
    # otherwise fail later with a confusing ffprobe error.
    if mp4.stat().st_size < 8 or mp4.read_bytes()[4:8] != b"ftyp":
        raise SystemExit(f"{mp4} is not an MP4 (ftyp box missing); refusing to use it")

    w, h, nframes = probe(mp4)
    print(f"source: {w}x{h}, {nframes} frames")
    if (w, h) != (SOURCE_SIZE, SOURCE_SIZE):
        raise SystemExit(f"expected {SOURCE_SIZE}x{SOURCE_SIZE}, got {w}x{h}")

    mp4_sha = hashlib.sha256(mp4.read_bytes()).hexdigest()

    full = WORK / "full"
    stamp = WORK / "full.stamp"
    if stamp.exists() and stamp.read_text().strip() != mp4_sha:
        shutil.rmtree(full, ignore_errors=True)
    if not (full / f"f{nframes:03d}.png").exists():
        full.mkdir(parents=True, exist_ok=True)
        run(["ffmpeg", "-v", "error", "-i", str(mp4), str(full / "f%03d.png")])
        stamp.write_text(mp4_sha)

    pal = WORK / "pal"
    pal.mkdir(parents=True, exist_ok=True)

    boxes, urls = [], []
    for k, idx in enumerate(FRAME_INDICES):
        src = full / f"f{idx + 1:03d}.png"   # ffmpeg numbers output from 1
        dst = pal / f"f{k:02d}.png"
        run(["ffmpeg", "-v", "error", "-i", str(src), "-vf",
             f"scale={SOURCE_SIZE}:{SOURCE_SIZE}:flags=lanczos,"
             f"split[a][b];[a]palettegen=max_colors={PALETTE_COLORS}[p];"
             "[b][p]paletteuse=dither=none", str(dst)])

        # Measure the box on the QUANTIZED frame that actually ships. The
        # 32-colour palette step can nudge a pixel across the blue threshold, so
        # a box measured on the source leaves a handful of saturated pixels
        # outside the erase region - small, but it fringes the output.
        box = robust_box(decode_rgba(dst, SOURCE_SIZE), SOURCE_SIZE, SOURCE_SIZE)
        boxes.append(box)
        print(f"  k={k:>2} src={idx:>3} box={box}")

        urls.append("data:image/png;base64,"
                    + base64.b64encode(dst.read_bytes()).decode())

    lines = [
        "// AUTO-GENERATED by tools/generate-frames.py - do not edit by hand.",
        f"// Source: {MP4_URL}",
        f"// Source SHA-256: {mp4_sha}",
        "// Regenerate with: python3 tools/generate-frames.py",
        "",
        "export type LogoBox = { x: number; y: number; w: number; h: number };",
        "",
        f"export const SOURCE_SIZE = {SOURCE_SIZE};",
        f"export const FRAME_COUNT = {FRAME_COUNT};",
        "",
        "export const FRAME_SOURCE_INDICES: readonly number[] = ["
        + ", ".join(str(i) for i in FRAME_INDICES) + "];",
        "",
        "export const LOGO_BOXES: readonly LogoBox[] = [",
    ]
    for b in boxes:
        lines.append("    { x: %d, y: %d, w: %d, h: %d }," % (b["x"], b["y"], b["w"], b["h"]))
    lines += ["];", "", "export const FRAME_DATA_URLS: readonly string[] = ["]
    for u in urls:
        lines.append(f'    "{u}",')
    lines += ["];", ""]

    OUT_TS.write_text("\n".join(lines))
    total = sum(len(u) for u in urls)
    print(f"wrote {OUT_TS} ({total} base64 chars, {total / 1024:.0f} KiB)")


if __name__ == "__main__":
    sys.exit(main())
