#!/usr/bin/env python3
"""Quality audit for assets/logos. Reports coverage, wrong dimensions,
blurry marks, upscaled (soft) marks, low-contrast marks and near-empty images.
tone/shape come from assets/logos/manifest.json, provenance (source) from
tool/logo_manifest.json. Files must be LOGO_SIZE (default 128) square.
Run: python3 tool/audit_logos.py [--json out.json]"""
import json, os, re, sys
from PIL import Image, ImageChops, ImageFilter, ImageStat

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")
SIZE = int(os.environ.get("LOGO_SIZE", "128"))

def flatten(img):
    """Composite onto a background that contrasts with the mark, so a
    single-colour mark on transparency still has visible edges."""
    px = [q for q in img.resize((48, 48)).getdata() if q[3] > 100]
    lum = sum(0.2126*r + 0.7152*g + 0.0722*b for r, g, b, _ in px) / len(px) / 255 if px else 0
    bg = Image.new("RGBA", img.size, (0, 0, 0, 255) if lum > 0.5 else (255, 255, 255, 255))
    return Image.alpha_composite(bg, img).convert("L"), lum

def sharpness(gray):
    return ImageStat.Stat(gray.filter(ImageFilter.FIND_EDGES)).var[0]

def fine_detail(gray):
    """Share of edge contrast that lives at the finest scale: the change made by
    a 0.7px blur relative to a 3px blur. Crisp 128px art scores ~0.15-0.25; a
    favicon upscaled from 32-64px has no 1px detail left and scores lower.
    (Compared against blurred copies rather than a plain down-then-up resample,
    which flat geometric marks survive almost unchanged.)"""
    d1 = ImageStat.Stat(ImageChops.difference(gray, gray.filter(ImageFilter.GaussianBlur(0.7)))).mean[0]
    d3 = ImageStat.Stat(ImageChops.difference(gray, gray.filter(ImageFilter.GaussianBlur(3)))).mean[0]
    return d1 / d3 if d3 > 0.5 else 1.0

def coverage(img):
    a = img.getchannel("A")
    bbox = a.getbbox()
    if not bbox: return 0.0, 0.0
    w, h = bbox[2]-bbox[0], bbox[3]-bbox[1]
    opaque = sum(1 for p in a.getdata() if p > 40) / (img.width*img.height)
    return max(w, h) / img.width, opaque

def main():
    cat = json.load(open(os.path.join(ROOT, "assets/catalog/platforms.json")))["platforms"]
    m = json.load(open(os.path.join(OUT, "manifest.json")))
    prov = json.load(open(os.path.join(ROOT, "tool", "logo_manifest.json")))
    src = lambda cid: prov.get(cid, {}).get("source", "?")
    glyphs = set(re.findall(r"^  '([^']+)':", open(os.path.join(ROOT, "lib/shared/brand/brand_icons.g.dart")).read(), re.M))
    report = {"catalog": len(cat), "png": 0, "glyph_only": [], "none": [], "bad_dims": [], "blurry": [], "upscaled": [], "low_contrast": [], "sparse": [], "orphans": [], "missing_files": [], "no_provenance": []}
    ids = {p["id"] for p in cat}
    for p in cat:
        cid = p["id"]
        if cid in m:
            report["png"] += 1
            path = os.path.join(OUT, f"{cid}.png")
            if not os.path.exists(path):
                report["missing_files"].append(cid); continue
            if cid not in prov: report["no_provenance"].append(cid)
            img = Image.open(path).convert("RGBA")
            if img.size != (SIZE, SIZE): report["bad_dims"].append((cid, img.size))
            gray, lum = flatten(img)
            s = sharpness(gray)
            ext, opaque = coverage(img)
            if opaque < 0.03 or ext < 0.5: report["sparse"].append((cid, round(ext, 2), round(opaque, 3)))
            if s < 60: report["blurry"].append((cid, round(s, 1), src(cid)))
            r = fine_detail(gray)
            if r < 0.135: report["upscaled"].append((cid, round(r, 3), src(cid)))
            if lum < 0.22 and m[cid].get("tone") != "dark": report["low_contrast"].append((cid, round(lum, 2), src(cid)))
        elif p.get("icon") in glyphs:
            report["glyph_only"].append(cid)
        else:
            report["none"].append(cid)
    report["orphans"] = sorted(set(m) - ids)
    report["blurry"].sort(key=lambda x: x[1])
    report["upscaled"].sort(key=lambda x: x[1])
    if "--json" in sys.argv:
        json.dump(report, open(sys.argv[sys.argv.index("--json")+1], "w"), indent=1)
    for k, v in report.items():
        print(f"{k}: {v if not isinstance(v, list) else len(v)}")
    for k in ("bad_dims", "missing_files", "no_provenance", "orphans", "sparse", "low_contrast"):
        if report[k]: print(f"  {k}: {report[k][:40]}")
    print("  blurry (worst 60):", report["blurry"][:60])
    print("  upscaled (worst 60):", report["upscaled"][:60])
    print("  none:", report["none"])

if __name__ == "__main__":
    main()
