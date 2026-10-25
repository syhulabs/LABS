#!/usr/bin/env python3
"""Import logo files supplied by the account owner (e.g. a zip of icons).

Files may be named <catalog-id>.<ext> or NNN_<slug>.<ext>, where <slug> is the
catalog id or a slug of the platform name ("077_reaper.ico",
"064_pan-nsdl-utiitsl.png"). Supported: svg, png, webp, ico (largest frame).
Only the ids passed with --only are imported, so every file is reviewed by
eye first (right brand, not a parent or other company's mark, sharp enough).

  python3 tool/import_owner_logos.py <folder> --only id1,id2 [--label "icons.zip, 2026-10-25"]
  python3 tool/normalize_logos.py --only <same ids>

Each file is fitted (and enlarged when smaller) to the logo size, written to
assets/logos/<id>.png, and recorded in tool/logo_manifest.json and
docs/LOGO_SOURCES.md with source "owner" and the original file name.
Nothing is drawn or generated."""
import json, os, re, subprocess, sys, tempfile
from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")
SIZE = int(os.environ.get("LOGO_SIZE", "128"))
ALIASES = {"pan-nsdl-utiitsl": "pan-india", "ip-india-trademarks": "ip-india", "copyright-office-india": "copyright-india",
           "ironsource-levelplay": "levelplay", "rodin-hyper3d": "rodin", "upi-npci": "upi", "time-machine-local": "time-machine",
           "fortnite-uefn": "fortnite", "comixology-amazon": "comixology"}


def slug(s):
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def load(path):
    ext = path.rsplit(".", 1)[-1].lower()
    if ext == "svg":
        with tempfile.NamedTemporaryFile(suffix=".png") as t:
            subprocess.run(["rsvg-convert", "-w", str(SIZE * 4), "-h", str(SIZE * 4), "--keep-aspect-ratio", path, "-o", t.name], check=True, capture_output=True)
            return Image.open(t.name).convert("RGBA"), "vector"
    im = Image.open(path)
    if ext == "ico":
        sizes = sorted(im.info.get("sizes", {im.size}), key=lambda s: s[0])
        im.size = sizes[-1]
        im.load()
    return im.convert("RGBA"), f"{im.size[0]}px"


def fit(img):
    bbox = img.getchannel("A").getbbox()
    if bbox:
        img = img.crop(bbox)
    scale = SIZE / max(img.size)
    img = img.resize((max(1, round(img.width * scale)), max(1, round(img.height * scale))), Image.LANCZOS)
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    canvas.paste(img, ((SIZE - img.width) // 2, (SIZE - img.height) // 2), img)
    return canvas


def update_sources_doc(rows):
    path = os.path.join(ROOT, "docs", "LOGO_SOURCES.md")
    lines = open(path).read().split("\n")
    head_end = next(i for i, l in enumerate(lines) if l.startswith("| --- "))
    table_end = next(i for i in range(head_end + 1, len(lines)) if not lines[i].startswith("| "))
    table = {l.split("|")[1].strip(): l for l in lines[head_end + 1:table_end]}
    for cid, url, tone in rows:
        table[cid] = f"| {cid} | owner | {url} | {tone} |"
    new = [table[k] for k in sorted(table)]
    open(path, "w").write("\n".join(lines[:head_end + 1] + new + lines[table_end:]))


def main():
    folder = sys.argv[1]
    only = set(sys.argv[sys.argv.index("--only") + 1].split(",")) if "--only" in sys.argv else set()
    label = sys.argv[sys.argv.index("--label") + 1] if "--label" in sys.argv else "supplied by the account owner"
    if not only:
        sys.exit("pass --only with the reviewed catalog ids")
    catalog = json.load(open(os.path.join(ROOT, "assets/catalog/platforms.json")))["platforms"]
    ids = {p["id"] for p in catalog}
    by_name = {slug(p["name"]): p["id"] for p in catalog}
    files = {}
    for f in sorted(os.listdir(folder)):
        m = re.match(r"(?:\d+_)?(.+)\.(svg|png|webp|ico)$", f, re.I)
        if not m:
            continue
        s = m.group(1).lower()
        cid = s if s in ids else ALIASES.get(s) or by_name.get(s)
        if cid:
            files[cid] = f
    missing = sorted(only - set(files))
    if missing:
        sys.exit(f"no file found for: {', '.join(missing)}")
    mpath = os.path.join(ROOT, "tool", "logo_manifest.json")
    manifest = json.load(open(mpath))
    rows = []
    for cid in sorted(only):
        img, native = load(os.path.join(folder, files[cid]))
        fit(img).save(os.path.join(OUT, f"{cid}.png"), optimize=True)
        url = f"{label}: {files[cid]} ({native})"
        entry = manifest.get(cid, {})
        entry.update({"file": f"assets/logos/{cid}.png", "source": "owner", "url": url})
        manifest[cid] = entry
        rows.append((cid, url, entry.get("tone", "color")))
        print(f"{cid:24} <- {files[cid]} ({native})")
    json.dump(manifest, open(mpath, "w"), indent=1, ensure_ascii=False)
    update_sources_doc(rows)
    print("normalise next: python3 tool/normalize_logos.py --only " + ",".join(sorted(only)))


if __name__ == "__main__":
    main()
