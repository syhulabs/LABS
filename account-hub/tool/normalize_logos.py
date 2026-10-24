#!/usr/bin/env python3
"""Normalise every logo PNG: crop to the *visible* (alpha) bounding box, fit to
a 256px canvas, then record tone and shape in manifest.json.
  tone  : dark | light | color   (dark marks get a light tile in dark mode)
  shape : square (full-bleed app-style icon, rendered edge to edge) | mark
Run: python3 tool/normalize_logos.py"""
import json, os
from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")
SIZE = 256

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
    m = json.load(open(os.path.join(OUT, "manifest.json")))
    changed = 0
    for cid, meta in m.items():
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
        canvas.save(path, optimize=True)
        if meta.get("tone") != tone or meta.get("shape") != shape:
            changed += 1
        meta["tone"], meta["shape"] = tone, shape
    json.dump(dict(sorted(m.items())), open(os.path.join(OUT, "manifest.json"), "w"), indent=1)
    from collections import Counter
    print(len(m), "normalised;", changed, "tone/shape updates;", Counter(v["tone"] for v in m.values()), Counter(v["shape"] for v in m.values()))

if __name__ == "__main__":
    main()
