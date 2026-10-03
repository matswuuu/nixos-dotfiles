# LinuxScratch

A Vencord/Equicord user plugin that adds `/linux-scratch`, which renders an
animated GIF of Tux scratching a user's avatar in place of the Windows logo.
The GIF is **attached to the message composer, not sent**.

## Usage

```
/linux-scratch user:@someone resolution:256 speed:1
```

| Option | Type | Default | Range | Meaning |
|---|---|---|---|---|
| `user` | user | — | — | Whose avatar to use (required) |
| `resolution` | integer | 256 | 64–498 | Output size in px (square) |
| `speed` | number | 1 | 0.25–4 | Playback multiplier. 1 = real time, 2 = double |

`resolution` is capped at 498 because that is the native size of the source
art; anything larger would just upscale it. Values outside either range are
clamped rather than rejected.

`speed` is a multiplier rather than a raw delay: real-time playback is 189 ms
per frame, derived from the source animation (68 frames at 30 fps spread over
12 output frames). The delay is additionally floored at 20 ms, because
Chromium and Firefox misrender shorter GIF frame delays — but `speed: 4`, the
maximum, still yields 47 ms, so the floor is a guard rather than something the
legal range can reach.

## How it works

The source animation is pre-extracted into 12 PNG frames which are inlined
into `frames.ts` as base64 data URLs, alongside a table of the Windows logo's
bounding box in each frame (it moves, because the artwork is a redrawn
flipbook). `frames.ts` is auto-generated and is the bulk of this directory
(~300 KB).

At render time each frame is composited on a canvas:

1. the avatar is drawn clipped to a circle over the logo's bounding box;
2. the frame is drawn and the logo is chroma-keyed to a transparent hole
   inside that circle, with any leftover logo blue painted to background
   white;
3. the two are composited so the avatar shows through the hole.

Drawing the avatar *underneath* is deliberate: Tux's flipper overlaps the logo,
so painting the avatar on top would smear over the claw.

The chroma key (`isLogoColor` in `logic.ts`) tests *blueness* — blue above the
red/green midpoint — rather than a blue range, so the antialiased edges where
the logo blends into the white background are still caught. A naive range test
leaves a visible light-blue fringe around the avatar.

The logo is a rotated square whose pixels reach ~1.5x the circle radius from
the box centre, so the keying loop runs over the whole logo **box**, never the
circle's bounding box, and it whitens before it sets alpha. Both details are
load-bearing; the comments on `eraseRegion` and in `render.ts` explain what
breaks if they are changed.

The result is encoded with [`gifenc`](https://github.com/mattdesl/gifenc) and
handed to Discord via `UploadHandler.promptToUpload`. `gifenc` resolves out of
Vencord's and Equicord's own dependencies, so there is no `package.json` here
to declare it.

Two details in `index.ts` are load-bearing and easy to undo by accident:

- the upload is deferred by `setTimeout(..., 10)`, because Discord clears
  slash-command input and pending attachments the moment the command resolves;
- the upload runs *outside* the command's `try`/`catch` (it has its own), so a
  late rejection cannot escape as an unhandled promise.

## Deploying

The plugin is compiled into the client by the mod build, so it is only present
after a rebuild **and a relaunch** — reloading the client in place is not
enough.

```bash
nixos-rebuild switch --flake .#main
```

## Regenerating the frames

Frames come from a fixed source video. To rebuild them (e.g. after changing the
frame count or sampling):

```bash
cd home/modules/nixcord/linuxScratch
python3 tools/generate-frames.py
python3 tools/verify-frames.py
```

`generate-frames.py` needs `ffmpeg`/`ffprobe`, `curl`, and Python 3 (standard
library only — no numpy or PIL). Downloads and extracted frames are cached in
`work/`, which is gitignored.

`verify-frames.py` re-derives the frame table and box table from the source
video and asserts the per-frame invariants the renderer depends on (box sizes,
boxes inside the frame, logo overhang, stray chroma outside the box). It also
holds a second, deliberately stricter copy of the offline blue detector used
for box detection — the runtime keying test in `logic.ts` is looser than that,
and the two must not be confused.

`CIRCLE_RATIO` and `isLogoColor` in `logic.ts` are mirrored in
`tools/verify-frames.py`. If you change one, change both; the verifier exists
to catch the drift.

## Tests

```bash
node logic.test.mjs              # geometry, clamping, chroma-key, timing
python3 tools/verify-frames.py   # baked frame table and box table
```

`logic.test.mjs` runs under Node's native TypeScript type stripping — no
bundler or test framework needed. It imports only `logic.ts` and `frames.ts`,
neither of which has runtime imports, so no bundler resolution is involved.

`render.ts` holds the canvas and GIF encoding and cannot run outside a browser;
it is covered by `nix build` plus the in-app smoke test.

## nixcord wiring

Enabled from `home/modules/nixcord/default.nix`:

```nix
programs.nixcord = {
  userPlugins.linuxScratch = ./linuxScratch;
  extraConfig.plugins.linuxScratch.enable = true;
};
```

nixcord rewrites both halves when it generates `settings.json`, and both
rewrites matter:

- the plugin key `linuxScratch` becomes `LinuxScratch`, which must match the
  plugin's `name` exactly;
- the inner `enable` becomes `enabled`, the key Vencord actually reads.

Plugin key names must be lowerCamel for nixcord to apply that capitalisation,
and must not contain `.` — a Nix attribute name cannot hold one, so the plugin
could not be enabled at all.

## Credits

Animation by Artem. The watermark in the top-left of each frame reads
"Made by Artem / Telegram: furazane / Insta: furazane" and is part of the
source artwork, so it is preserved in the output rather than cropped out.