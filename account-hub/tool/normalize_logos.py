#!/usr/bin/env python3
"""Normalise every logo PNG: crop to the *visible* (alpha) bounding box, fit to
a 256px canvas, then record tone and shape in manifest.json.
  tone  : dark | light | color   (dark marks get a light tile in dark mode)
  shape : square (full-bleed app-style icon, rendered edge to edge) | mark
Run: python3 tool/normalize_logos.py [--only id1,id2]  (--only re-processes just those files)"""
import json, os, sys
from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")
SIZE = int(os.environ.get("LOGO_SIZE", "128"))  # 128px keeps mobile bundles small; tiles are at most 72 logical px

def analyse(img):
    small = img.resize((64, 64))
    px = [p for p in small.getdata() if p[3] > 100]
    if not px:
        return "empty", "mark", 0.0
    lum = sum(0.2126*r + 0.7152*g + 0.0722*b for r, g, b, _ in px) / len(px) / 255
    sat = sum((max(r, g, b) - min(r, g, b)) / 255 for r, g, b, _ in px) / len(px)
    tone = "dark" if lum < 0.25 else ("light" if lum > 0.85 and sat < 0.12 else "color")
    opaque = len(px) / (64 * 64)
    # Full-bleed icons fill nearly the whole square (corners may be rounded).
    shape = "square" if opaque > 0.80 else "mark"
    return tone, shape, opaque

def main():
    full_path = os.path.join(ROOT, "tool", "logo_manifest.json")
    m = json.load(open(full_path))
    only = set(sys.argv[sys.argv.index("--only") + 1].split(",")) if "--only" in sys.argv else None
    changed = 0
    for cid, meta in m.items():
        if only is not None and cid not in only:
            continue
        path = os.path.join(OUT, f"{cid}.png")
        img = Image.open(path).convert("RGBA")
        a = img.getchannel("A").point(lambda v: 255 if v > 8 else 0)
        bbox = a.getbbox()
        if bbox:
            img = img.crop(bbox)
        # Scale to fill the canvas (upscaling small favicons too: at tile size they stay crisp enough).
        ratio = SIZE / max(img.width, img.height)
        img = img.resize((max(1, round(img.width * ratio)), max(1, round(img.height * ratio))), Image.LANCZOS)
        canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
        canvas.paste(img, ((SIZE - img.width) // 2, (SIZE - img.height) // 2), img)
        tone, shape, opaque = analyse(canvas)
        # 8-bit palette keeps icons crisp at tile size and roughly quarters the bundle weight.
        canvas.quantize(colors=256, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE).save(path, optimize=True)
        if meta.get("tone") != tone or meta.get("shape") != shape:
            changed += 1
        meta["tone"], meta["shape"] = tone, shape
    # Full provenance stays in tool/; the app bundle only ships tone + shape.
    json.dump(dict(sorted(m.items())), open(full_path, "w"), indent=1)
    slim = {cid: {"tone": v["tone"], "shape": v["shape"]} for cid, v in sorted(m.items())}
    json.dump(slim, open(os.path.join(OUT, "manifest.json"), "w"), separators=(",", ":"))
    from collections import Counter
    print(len(only) if only is not None else len(m), "normalised;", changed, "tone/shape updates;", Counter(v["tone"] for v in m.values()), Counter(v["shape"] for v in m.values()))

if __name__ == "__main__":
    main()
