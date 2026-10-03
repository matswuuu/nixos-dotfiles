// logic.test.mjs - run with: node logic.test.mjs
import assert from "node:assert/strict";
import {
    CIRCLE_RATIO, REAL_TIME_DELAY_MS, ANIMATION_FRAMES, PALETTE_SIZE,
    MIN_RESOLUTION, MAX_RESOLUTION, DEFAULT_RESOLUTION,
    MIN_SPEED, MAX_SPEED, DEFAULT_SPEED, MIN_DELAY_MS,
    ART_PALETTE_COLORS, MAX_PALETTE_COLORS,
    isLogoColor, clamp, scaleForFrame, circleFor, circleCoverage,
    frameDelayMs, avatarTransform, eraseRegion,
} from "./logic.ts";
import { SOURCE_SIZE, FRAME_COUNT, LOGO_BOXES } from "./frames.ts";

let failed = 0;
function t(name, fn) {
    try { fn(); console.log(`  ok   ${name}`); }
    catch (e) { console.log(`  FAIL ${name}\n       ${e.message}`); failed++; }
}

console.log("constants");
t("CIRCLE_RATIO is 0.9", () => assert.equal(CIRCLE_RATIO, 0.9));
t("REAL_TIME_DELAY_MS is 189", () => assert.equal(REAL_TIME_DELAY_MS, 189));
t("FRAME_COUNT is 12", () => assert.equal(FRAME_COUNT, 12));
t("ANIMATION_FRAMES tracks frames.ts FRAME_COUNT", () => {
    assert.equal(ANIMATION_FRAMES, FRAME_COUNT,
        "logic.ts and frames.ts disagree on the frame count");
});
t("resolution bounds are 64..498, default 256", () => {
    assert.equal(MIN_RESOLUTION, 64);
    assert.equal(MAX_RESOLUTION, 498);
    assert.equal(DEFAULT_RESOLUTION, 256);
});
t("MAX_RESOLUTION tracks the native source size", () => {
    assert.equal(MAX_RESOLUTION, SOURCE_SIZE,
        "art must never be upscaled; keep this equal to frames.ts SOURCE_SIZE");
});
t("speed bounds are 0.25..4, default 1", () => {
    assert.equal(MIN_SPEED, 0.25);
    assert.equal(MAX_SPEED, 4);
    assert.equal(DEFAULT_SPEED, 1);
});
t("PALETTE_SIZE is sane and below the source size", () => {
    assert.ok(PALETTE_SIZE > 0 && PALETTE_SIZE < SOURCE_SIZE);
    assert.equal(PALETTE_SIZE, 120);
});
t("palette budget leaves room for the art", () => {
    assert.equal(ART_PALETTE_COLORS, 32);
    assert.equal(MAX_PALETTE_COLORS, 255);
    assert.ok(ART_PALETTE_COLORS < MAX_PALETTE_COLORS);
});

console.log("isLogoColor");
t("logo blue #0076D2 is logo", () => assert.ok(isLogoColor(0x00, 0x76, 0xD2)));
t("white is not logo", () => assert.ok(!isLogoColor(255, 255, 255)));
t("penguin black is not logo", () => assert.ok(!isLogoColor(0, 0, 0)));
t("belly grey #E4E4E1 is not logo", () => assert.ok(!isLogoColor(0xE4, 0xE4, 0xE1)));
t("beak orange is not logo", () => assert.ok(!isLogoColor(0xF8, 0xA0, 0x08)));
t("faint blue-white blend IS logo (fringe guard)", () =>
    assert.ok(isLogoColor(0xE0, 0xEE, 0xF9)));
t("mid blue-white blend is logo", () =>
    assert.ok(isLogoColor(0x80, 0xBC, 0xE9)));

console.log("clamp");
t("clamps low", () => assert.equal(clamp(-5, 10, 20), 10));
t("clamps high", () => assert.equal(clamp(99, 10, 20), 20));
t("passes through", () => assert.equal(clamp(15, 10, 20), 15));

console.log("scaleForFrame");
t("ramps up to the midpoint then back down", () => {
    assert.deepEqual(
        Array.from({ length: FRAME_COUNT }, (_, i) => scaleForFrame(i, FRAME_COUNT)),
        [0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1]);
});
t("is zero at the first frame", () =>
    assert.equal(scaleForFrame(0, FRAME_COUNT), 0));

console.log("circleFor");
t("centres on the logo box", () => {
    const c = circleFor({ x: 100, y: 200, w: 114, h: 114 }, 1);
    assert.equal(c.cx, 157);
    assert.equal(c.cy, 257);
});
t("radius is ratio * half the shorter side", () => {
    const c = circleFor({ x: 0, y: 0, w: 114, h: 100 }, 1);
    assert.ok(Math.abs(c.r - 100 / 2 * CIRCLE_RATIO) < 1e-9);
});
t("scales linearly", () => {
    const box = LOGO_BOXES[0];
    const a = circleFor(box, 1);
    const b = circleFor(box, 0.5);
    assert.ok(Math.abs(b.cx - a.cx * 0.5) < 1e-9);
    assert.ok(Math.abs(b.r - a.r * 0.5) < 1e-9);
});
t("circle stays inside the logo box at 0.9", () => {
    for (const [k, box] of LOGO_BOXES.entries()) {
        const c = circleFor(box, 1);
        assert.ok(c.cx - c.r >= box.x, `frame ${k}: left edge`);
        assert.ok(c.cy - c.r >= box.y, `frame ${k}: top edge`);
        assert.ok(c.cx + c.r <= box.x + box.w, `frame ${k}: right edge`);
        assert.ok(c.cy + c.r <= box.y + box.h, `frame ${k}: bottom edge`);
    }
});

console.log("circleCoverage");
t("centre is fully covered", () => assert.equal(circleCoverage(0, 0, 10), 1));
t("well inside is 1", () => assert.equal(circleCoverage(5, 0, 10), 1));
t("outside is 0", () => assert.equal(circleCoverage(20, 0, 10), 0));
t("just inside the rim is fractional", () => {
    const v = circleCoverage(9.5, 0, 10);
    assert.ok(v > 0 && v < 1, `got ${v}`);
});
t("exactly on the rim is 0", () => assert.equal(circleCoverage(10, 0, 10), 0));
t("is monotonic outward", () => {
    let prev = Infinity;
    for (let d = 0; d <= 12; d += 0.5) {
        const v = circleCoverage(d, 0, 10);
        assert.ok(v <= prev, `coverage must not increase at d=${d}`);
        prev = v;
    }
});

console.log("frameDelayMs");
t("speed 1 is real time", () => assert.equal(frameDelayMs(1), 189));
t("speed 2 is double time", () => assert.equal(frameDelayMs(2), 95));
t("speed 0.5 is half time", () => assert.equal(frameDelayMs(0.5), 378));
t("never drops below the 20ms floor", () => {
    assert.equal(frameDelayMs(4), 47);
    assert.equal(frameDelayMs(1e6), MIN_DELAY_MS);
});
t("every in-range speed yields a sane finite delay", () => {
    for (let s = MIN_SPEED; s <= MAX_SPEED; s += 0.05) {
        const d = frameDelayMs(s);
        assert.ok(Number.isFinite(d), `speed ${s} gave ${d}`);
        assert.ok(d >= MIN_DELAY_MS, `speed ${s} gave ${d}`);
    }
});

console.log("avatarTransform");
t("returns a centred square matching the circle", () => {
    const box = LOGO_BOXES[0];
    const c = circleFor(box, 1);
    const r = avatarTransform(0, box, 1);
    assert.equal(r.size, c.r * 2);
    assert.ok(Math.abs((r.x + r.size / 2) - c.cx) < 1e-9);
    assert.ok(Math.abs((r.y + r.size / 2) - c.cy) < 1e-9);
});
t("grows with frame scale", () => {
    const box = LOGO_BOXES[0];
    assert.ok(avatarTransform(3, box, 1).size > avatarTransform(0, box, 1).size);
});
t("square fully covers the circle at every frame", () => {
    // Deliberately oversized: the square is clipped to the circle, so growing
    // it zooms the fill instead of leaving transparent corners.
    for (const [k, box] of LOGO_BOXES.entries()) {
        const c = circleFor(box, 1);
        for (let i = 0; i < FRAME_COUNT; i++) {
            const r = avatarTransform(i, box, 1);
            assert.ok(r.size / 2 >= c.r, `frame ${k} step ${i}: must cover the radius`);
            assert.ok(r.size / 2 <= c.r * 1.3, `frame ${k} step ${i}: must not wildly overshoot`);
        }
    }
});
t("scales with resolution", () => {
    const box = LOGO_BOXES[0];
    const a = avatarTransform(0, box, 1);
    const b = avatarTransform(0, box, 256 / SOURCE_SIZE);
    assert.ok(Math.abs(b.size - a.size * 256 / SOURCE_SIZE) < 1e-9);
});

console.log("eraseRegion");
t("covers the whole logo box", () => {
    for (const [k, box] of LOGO_BOXES.entries()) {
        const r = eraseRegion(box, 1, SOURCE_SIZE);
        assert.ok(r.x0 <= box.x, `frame ${k}: x0`);
        assert.ok(r.y0 <= box.y, `frame ${k}: y0`);
        assert.ok(r.x1 >= box.x + box.w, `frame ${k}: x1`);
        assert.ok(r.y1 >= box.y + box.h, `frame ${k}: y1`);
    }
});
t("is strictly larger than the circle in BOTH axes", () => {
    // The regression this guards: bounds derived from the circle leave the
    // logo's rotated corners unvisited, so blue survives into the GIF.
    for (const [k, box] of LOGO_BOXES.entries()) {
        const r = eraseRegion(box, 1, SOURCE_SIZE);
        const c = circleFor(box, 1);
        assert.ok(r.x1 - r.x0 > 2 * c.r, `frame ${k}: width ${r.x1 - r.x0} > ${2 * c.r}`);
        assert.ok(r.y1 - r.y0 > 2 * c.r, `frame ${k}: height ${r.y1 - r.y0} > ${2 * c.r}`);
    }
});
t("is bounded - it must not inflate to the whole canvas", () => {
    // The spec forbids inflation as well as shrinking. Without an upper bound a
    // region of {0,0,limit,limit} satisfies every other assertion here.
    for (const [k, box] of LOGO_BOXES.entries()) {
        const r = eraseRegion(box, 1, SOURCE_SIZE);
        assert.ok(r.x1 - r.x0 <= box.w + 3, `frame ${k}: width must stay near the box`);
        assert.ok(r.y1 - r.y0 <= box.h + 3, `frame ${k}: height must stay near the box`);
    }
});
t("pads the box by exactly 1px on each side", () => {
    // Only <= was asserted before, so a margin of 0 or 50 both passed. verify-
    // frames.py tolerates 8 stray pixels per frame, so a lost margin would not
    // have been caught there either.
    for (const [k, box] of LOGO_BOXES.entries()) {
        if (box.x <= 1 || box.y <= 1) continue;   // clamped at the canvas edge
        const r = eraseRegion(box, 1, SOURCE_SIZE);
        assert.equal(r.x0, box.x - 1, `frame ${k}: x0 margin`);
        assert.equal(r.y0, box.y - 1, `frame ${k}: y0 margin`);
        assert.equal(r.x1, box.x + box.w + 1, `frame ${k}: x1 margin`);
        assert.equal(r.y1, box.y + box.h + 1, `frame ${k}: y1 margin`);
    }
});
t("is clamped to the canvas", () => {
    const r = eraseRegion(LOGO_BOXES[0], 1, SOURCE_SIZE);
    assert.ok(r.x0 >= 0 && r.y0 >= 0);
    assert.ok(r.x1 <= SOURCE_SIZE && r.y1 <= SOURCE_SIZE);
    const tight = eraseRegion({ x: 0, y: 0, w: SOURCE_SIZE, h: SOURCE_SIZE }, 1, SOURCE_SIZE);
    assert.ok(tight.x1 === SOURCE_SIZE && tight.y1 === SOURCE_SIZE);
});
t("scales with resolution", () => {
    const box = LOGO_BOXES[0];
    const a = eraseRegion(box, 1, SOURCE_SIZE);
    const b = eraseRegion(box, 256 / SOURCE_SIZE, 256);
    const wA = a.x1 - a.x0, wB = b.x1 - b.x0;
    assert.ok(Math.abs(wB - wA * 256 / SOURCE_SIZE) <= 2,
        `${wB} ~ ${wA * 256 / SOURCE_SIZE}`);
});

console.log();
if (failed) { console.log(`FAILED: ${failed} test(s)`); process.exit(1); }
console.log("all tests passed");
