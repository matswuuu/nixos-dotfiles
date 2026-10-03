import type { LogoBox } from "./frames";

// CIRCLE_RATIO and the isLogoColor threshold below are mirrored verbatim in
// tools/verify-frames.py. That script is an independent reimplementation and
// asserts the logo overhangs this circle by 1.31-1.53x, and that stray chroma
// hits outside LOGO_BOXES stay under 2% - guarantees that stop meaning anything
// if the copies drift apart.
export const CIRCLE_RATIO = 0.9;

/** 68 animated source frames at 30fps spread over 12 output frames: 188.9ms. */
export const REAL_TIME_DELAY_MS = 189;
/** Must equal FRAME_COUNT in frames.ts; logic.test.mjs guards against drift. */
export const ANIMATION_FRAMES = 12;

export const MIN_RESOLUTION = 64;
/** Native source size. Above this the art would be upscaled. */
export const MAX_RESOLUTION = 498;
export const DEFAULT_RESOLUTION = 256;

export const MIN_SPEED = 0.25;
export const MAX_SPEED = 4;
export const DEFAULT_SPEED = 1;

/** Chromium and Firefox misrender frame delays below 20ms. */
export const MIN_DELAY_MS = 20;

export const ART_PALETTE_COLORS = 32;
/** GIF tops out at 256 entries; 255 rounds up to a 256-entry table. */
export const MAX_PALETTE_COLORS = 255;

export const PALETTE_SIZE = 120;

export type Circle = { cx: number; cy: number; r: number };
export type Rect = { x: number; y: number; size: number };
export type Region = { x0: number; y0: number; x1: number; y1: number };

/**
 * Windows-logo chroma test. Uses "blueness" (blue above the red/green
 * midpoint) rather than a blue range, so antialiased edges blending toward
 * white are still caught - a naive range test leaves a visible light-blue
 * fringe around the logo.
 *
 * Mirrored in tools/verify-frames.py; see the note on CIRCLE_RATIO.
 */
export function isLogoColor(r: number, g: number, b: number): boolean {
    return b - (r + g) / 2 > 10;
}

export function clamp(n: number, lo: number, hi: number): number {
    return n < lo ? lo : n > hi ? hi : n;
}

/**
 * Coerce a slash-command option to a number, falling back when it is absent or
 * unusable. This is the ONLY guard against NaN reaching the renderer: clamp()
 * would propagate it, since both of its comparisons are false for NaN.
 */
export function num(value: unknown, fallback: number): number {
    // A blank string is an absent option, not a zero: Number("") is 0, which is
    // finite, so without this an empty resolution would clamp to the MINIMUM
    // rather than fall back to the default.
    if (typeof value === "string" && value.trim() === "") return fallback;
    const n = typeof value === "string" ? Number(value) : value;
    return typeof n === "number" && Number.isFinite(n) ? n : fallback;
}

/** Squash amount per frame: ramps up to the midpoint, then back down. */
export function scaleForFrame(i: number, frameCount: number): number {
    return i < frameCount / 2 ? i : frameCount - i;
}

export function circleFor(box: LogoBox, scale: number): Circle {
    return {
        cx: (box.x + box.w / 2) * scale,
        cy: (box.y + box.h / 2) * scale,
        r: (Math.min(box.w, box.h) / 2) * CIRCLE_RATIO * scale,
    };
}

/**
 * How much of a pixel at offset (dx,dy) from the circle centre is covered, in
 * pixels: 1 well inside, 0 outside, fractional across a 1px antialiased rim.
 * Shared by the avatar transform (so the fill matches the hole) and the tests.
 */
export function circleCoverage(dx: number, dy: number, r: number): number {
    const d = Math.sqrt(dx * dx + dy * dy);
    if (d <= r - 1) return 1;
    if (d >= r) return 0;
    return r - d;
}

export function frameDelayMs(speed: number): number {
    return Math.max(MIN_DELAY_MS, Math.round(REAL_TIME_DELAY_MS / speed));
}

/**
 * Region the chroma-key loop must visit, clamped to a `limit`-sized canvas.
 *
 * This is the whole logo BOX, deliberately NOT the circle's bounding box. The
 * logo is a rotated square whose pixels reach ~1.5x the circle radius from the
 * box centre (measured), so circle-derived loop bounds leave roughly 1800
 * saturated logo pixels per frame unvisited and they survive into the finished
 * GIF as blue fragments around the avatar.
 */
export function eraseRegion(box: LogoBox, scale: number, limit: number): Region {
    return {
        x0: Math.max(0, Math.floor(box.x * scale) - 1),
        y0: Math.max(0, Math.floor(box.y * scale) - 1),
        x1: Math.min(limit, Math.ceil((box.x + box.w) * scale) + 1),
        y1: Math.min(limit, Math.ceil((box.y + box.h) * scale) + 1),
    };
}

/**
 * Square the avatar is drawn into: sized to fully cover the circle (with
 * margin for the antialiased rim) and nudged outward for the squash.
 */
export function avatarTransform(i: number, box: LogoBox, scale: number): Rect {
    const { cx, cy, r } = circleFor(box, scale);
    const size = r * 2 * (1 + scaleForFrame(i, ANIMATION_FRAMES) * 0.04);
    return { x: cx - size / 2, y: cy - size / 2, size };
}
