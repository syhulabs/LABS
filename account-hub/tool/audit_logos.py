#!/usr/bin/env python3
"""Quality audit for assets/logos. Reports coverage, wrong dimensions,
blurry (upscaled) marks, low-contrast marks and near-empty images.
Run: python3 tool/audit_logos.py [--json out.json]"""
import json, os, re, sys
from PIL import Image, ImageFilter, ImageStat

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")

def sharpness(img):
    g = img.convert("L").filter(ImageFilter.FIND_EDGES)
    return ImageStat.Stat(g).var[0]

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
    glyphs = set(re.findall(r"^  '([^']+)':", open(os.path.join(ROOT, "lib/shared/brand/brand_icons.g.dart")).read(), re.M))
    report = {"catalog": len(cat), "png": 0, "glyph_only": [], "none": [], "bad_dims": [], "blurry": [], "low_contrast": [], "sparse": [], "orphans": [], "missing_files": []}
    ids = {p["id"] for p in cat}
    for p in cat:
        cid = p["id"]
        if cid in m:
            report["png"] += 1
            path = os.path.join(OUT, f"{cid}.png")
            if not os.path.exists(path):
                report["missing_files"].append(cid); continue
            img = Image.open(path).convert("RGBA")
            if img.size != (256, 256): report["bad_dims"].append((cid, img.size))
            s = sharpness(img)
            ext, opaque = coverage(img)
            if opaque < 0.03 or ext < 0.5: report["sparse"].append((cid, round(ext, 2), round(opaque, 3)))
            if s < 60: report["blurry"].append((cid, round(s, 1), m[cid]["source"]))
            px = [q for q in img.resize((48, 48)).getdata() if q[3] > 100]
            if px:
                lum = sum(0.2126*r+0.7152*g+0.0722*b for r, g, b, _ in px)/len(px)/255
                if lum < 0.22 and m[cid].get("tone") != "dark": report["low_contrast"].append((cid, round(lum, 2), m[cid]["source"]))
        elif p.get("icon") in glyphs:
            report["glyph_only"].append(cid)
        else:
            report["none"].append(cid)
    report["orphans"] = sorted(set(m) - ids)
    report["blurry"].sort(key=lambda x: x[1])
    if "--json" in sys.argv:
        json.dump(report, open(sys.argv[sys.argv.index("--json")+1], "w"), indent=1)
    for k, v in report.items():
        print(f"{k}: {v if not isinstance(v, list) else len(v)}")
    for k in ("bad_dims", "missing_files", "orphans", "sparse", "low_contrast"):
        if report[k]: print(f"  {k}: {report[k][:40]}")
    print("  blurry (worst 60):", report["blurry"][:60])
    print("  none:", report["none"])

if __name__ == "__main__":
    main()
