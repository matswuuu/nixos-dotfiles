// Canvas + GIF composition. Needs a real browser canvas, so unlike logic.ts it
// has no unit test; it is covered by `nix build` plus the in-app smoke test.
import { GIFEncoder, applyPalette, quantize } from "gifenc";
import { FRAME_COUNT, FRAME_DATA_URLS, LOGO_BOXES, SOURCE_SIZE } from "./frames";
import {
    ART_PALETTE_COLORS,
    MAX_PALETTE_COLORS,
    MAX_RESOLUTION,
    MAX_SPEED,
    MIN_RESOLUTION,
    MIN_SPEED,
    PALETTE_SIZE,
    avatarTransform,
    circleCoverage,
    circleFor,
    clamp,
    eraseRegion,
    frameDelayMs,
    isLogoColor,
} from "./logic";

function loadImage(src: string): Promise<HTMLImageElement> {
    return new Promise((resolve, reject) => {
        const img = new Image();
        img.crossOrigin = "Anonymous";
        img.onload = () => resolve(img);
        img.onerror = () => reject(new Error(`failed to load image: ${src.slice(0, 64)}`));
        img.src = src;
    });
}

function mkCanvas(w: number, h: number): [HTMLCanvasElement, CanvasRenderingContext2D] {
    const c = document.createElement("canvas");
    c.width = w;
    c.height = h;
    const ctx = c.getContext("2d", { willReadFrequently: true });
    if (!ctx) throw new Error("2d canvas unavailable");
    return [c, ctx];
}

function dedupe(palette: number[][]): number[][] {
    const seen = new Set<string>();
    const out: number[][] = [];
    for (const c of palette) {
        const k = `${c[0]},${c[1]},${c[2]}`;
        if (seen.has(k)) continue;
        seen.add(k);
        out.push([c[0], c[1], c[2]]);
    }
    return out;
}

/** Draw the avatar into a size x size square centred on the circle, clipped to it. */
function drawAvatarInCircle(
    ctx: CanvasRenderingContext2D,
    avatar: CanvasImageSource,
    c: { cx: number; cy: number; r: number },
    size: number,
) {
    ctx.save();
    ctx.beginPath();
    ctx.arc(c.cx, c.cy, c.r, 0, Math.PI * 2);
    ctx.clip();
    ctx.drawImage(avatar, c.cx - size / 2, c.cy - size / 2, size, size);
    ctx.restore();
}

export async function renderGif(opts: {
    avatarUrl: string;
    resolution: number;
    speed: number;
}): Promise<File> {
    const res = clamp(Math.round(opts.resolution), MIN_RESOLUTION, MAX_RESOLUTION);
    const speed = clamp(opts.speed, MIN_SPEED, MAX_SPEED);
    const scale = res / SOURCE_SIZE;
    const delay = frameDelayMs(speed);
    const ps = PALETTE_SIZE / SOURCE_SIZE;

    const [avatar, frames] = await Promise.all([
        loadImage(opts.avatarUrl),
        Promise.all(FRAME_DATA_URLS.map(loadImage)),
    ]);

    const [avatarCanvas, avatarCtx] = mkCanvas(res, res);
    const [frameCanvas, frameCtx] = mkCanvas(res, res);
    const [, outCtx] = mkCanvas(res, res);

    // Palette. The art is quantised SEPARATELY so the ~79% white background
    // only claims a few of its 32 slots instead of taking a share of the
    // avatar's - quantize() ignores alpha outside format:"rgba4444", so making
    // white transparent would not exclude it; a separate call is the only way to
    // reserve budget. Avatar entries come first so they are preferred in the
    // dedupe. Note 223 + 32 == MAX_PALETTE_COLORS, so slice() is a safety net
    // rather than a real trim: dedupe can only shorten the list.
    const [, palCtx] = mkCanvas(PALETTE_SIZE, PALETTE_SIZE);
    // White-filled so the quantiser sees the colour those pixels actually render
    // as, and so correctness does not depend on quantize()'s bin-merge internals.
    // It reads alpha only under format:"rgba4444", so leaving the canvas
    // transparent cannot exclude them. (It is PNN error-merge, not
    // popularity-based, so the black would NOT have stolen avatar slots — but
    // that is an implementation detail we should not be relying on.)
    palCtx.fillStyle = "#fff";
    palCtx.fillRect(0, 0, PALETTE_SIZE, PALETTE_SIZE);
    const c0 = circleFor(LOGO_BOXES[0], ps);
    drawAvatarInCircle(palCtx, avatar, c0, c0.r * 2);
    const avatarData = palCtx.getImageData(0, 0, PALETTE_SIZE, PALETTE_SIZE).data;

    const [, artCtx] = mkCanvas(PALETTE_SIZE, PALETTE_SIZE);
    artCtx.drawImage(frames[0], 0, 0, PALETTE_SIZE, PALETTE_SIZE);
    const artData = artCtx.getImageData(0, 0, PALETTE_SIZE, PALETTE_SIZE).data;

    const palette = dedupe([
        ...quantize(avatarData, MAX_PALETTE_COLORS - ART_PALETTE_COLORS),
        ...quantize(artData, ART_PALETTE_COLORS),
    ]).slice(0, MAX_PALETTE_COLORS);

    const gif = GIFEncoder();

    // Loop-invariant: set once so it is not reassigned on every frame.
    avatarCtx.fillStyle = "#fff";

    for (let i = 0; i < FRAME_COUNT; i++) {
        const box = LOGO_BOXES[i];
        const c = circleFor(box, scale);
        const rect = avatarTransform(i, box, scale);

        // A: the avatar, clipped to this frame's circle. White-filled first so
        // a PNG avatar with transparency cannot put unintended alpha into a GIF
        // that is written as opaque.
        avatarCtx.fillRect(0, 0, res, res);
        drawAvatarInCircle(avatarCtx, avatar, c, rect.size);

        // B: the frame, with a transparent hole inside the circle and any
        // leftover logo blue outside it painted to background white
        frameCtx.clearRect(0, 0, res, res);
        frameCtx.drawImage(frames[i], 0, 0, res, res);
        const img = frameCtx.getImageData(0, 0, res, res);
        const d = img.data;
        // Erase over the whole logo BOX, never the circle's bounding box - see
        // eraseRegion(). Circle-derived bounds would leave ~1800 saturated logo
        // pixels per frame unvisited, surviving as blue fragments.
        const { x0, y0, x1, y1 } = eraseRegion(box, scale, res);
        for (let y = y0; y < y1; y++) {
            for (let x = x0; x < x1; x++) {
                const p = (y * res + x) * 4;
                const cov = circleCoverage(x + 0.5 - c.cx, y + 0.5 - c.cy, c.r);
                // Whiten FIRST, then modulate alpha. Order matters: the logo is
                // a rotated square whose corners reach ~1.5x the circle radius,
                // so the 1px band just inside the rim is solid logo blue in the
                // sectors near those corners. Whitening only in the `cov === 0`
                // branch let that blue survive at partial alpha, tinting the
                // avatar's outer pixel - and flickering as the square rotates
                // frame to frame.
                if (isLogoColor(d[p], d[p + 1], d[p + 2])) {
                    d[p] = 255;
                    d[p + 1] = 255;
                    d[p + 2] = 255;
                }
                if (cov >= 1) {
                    d[p + 3] = 0;
                } else if (cov > 0) {
                    d[p + 3] = Math.round(d[p + 3] * (1 - cov));
                }
            }
        }
        frameCtx.putImageData(img, 0, 0);

        // C: composite. The avatar shows through the hole, and Tux's flipper
        // stays on top because it is opaque in the frame.
        outCtx.clearRect(0, 0, res, res);
        outCtx.drawImage(avatarCanvas, 0, 0);
        outCtx.drawImage(frameCanvas, 0, 0);

        const { data } = outCtx.getImageData(0, 0, res, res);
        gif.writeFrame(applyPalette(data, palette), res, res, {
            delay,
            palette: i === 0 ? palette : undefined,
        });
    }

    gif.finish();
    return new File([gif.bytesView()], "linux-scratch.gif", { type: "image/gif" });
}
