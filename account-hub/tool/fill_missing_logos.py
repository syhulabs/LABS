#!/usr/bin/env python3
"""Third pass: for every catalog entry that still has no logo file, try the
same sources as fetch_logos.py by exact (normalised) name match, then the
brand's own website icon, then App Store artwork (only when the seller name
contains a distinctive word of the brand name). Entries that only have a
Simple Icons glyph are upgraded to a coloured mark when a vector set or the
website provides one. Run: python3 tool/fill_missing_logos.py"""
import concurrent.futures as cf
import json
import os
import re
import sys
import time
import urllib.parse
import urllib.request

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fetch_logos as F  # noqa: E402
from PIL import Image, ImageDraw  # noqa: E402

ROOT = F.ROOT
OUT = F.OUT
SRC = F.SRC

def norm(s):
    return re.sub(r"[^a-z0-9]", "", s.lower())

def load_inventories():
    dash = [l.strip()[:-4] for l in open(f"{SRC}/dash_svgs.txt") if l.strip().endswith(".svg")]
    gil = [l.strip()[:-4] for l in open(f"{SRC}/gil_svgs.txt") if l.strip().endswith(".svg")]
    lobe = [f[:-4] for f in os.listdir(F.LOBE_DIR) if f.endswith(".svg")]
    svgl = json.load(open(f"{SRC}/svgl.json"))
    return dash, gil, lobe, svgl

DASH, GIL, LOBE, SVGL = load_inventories()
DASHN = {norm(x): x for x in DASH if not x.endswith(("-light", "-dark"))}
GILN = {norm(x): x for x in GIL}
LOBEN = {norm(x): x for x in LOBE}
SVGLN = {}
for e in SVGL:
    r = e["route"]
    url = r if isinstance(r, str) else r.get("light") or r.get("dark")
    SVGLN[norm(e["title"])] = url

STOP = {"the", "for", "and", "app", "inc", "ltd", "com", "music", "bank", "cloud", "studio", "pro", "india", "online", "store", "games", "game", "ai", "io", "tv", "plus", "account", "developer", "program", "connect", "console", "business", "payments", "pay"}

def candidates(p):
    name, cid, web = p["name"], p["id"], p.get("website") or ""
    keys = [norm(name), norm(cid), norm(re.sub(r"\(.*?\)", "", name))]
    out = []
    for k in keys:
        if k in LOBEN or k + "color" in LOBEN:
            out.append(("lobe", LOBEN.get(k + "color", LOBEN.get(k))))
    for k in keys:
        if k in DASHN:
            out.append(("dash", DASHN[k]))
    for k in keys:
        for suffix in ("icon", ""):
            if k + suffix in GILN:
                out.append(("gil", GILN[k + suffix]))
    for k in keys:
        if k in SVGLN:
            out.append(("svgl", SVGLN[k]))
    if web:
        host = urllib.parse.urlparse(web).netloc
        if host:
            out.append(("site", host))
    seen, uniq = set(), []
    for c in out:
        if c not in seen:
            seen.add(c)
            uniq.append(c)
    return uniq

def appstore(p):
    name = re.sub(r"\(.*?\)", "", p["name"]).strip()
    tokens = [t for t in re.split(r"[^a-z0-9]+", name.lower()) if len(t) >= 4 and t not in STOP]
    if not tokens:
        return None
    q = urllib.parse.quote(name)
    for country in ("us", "in"):
        try:
            d = json.loads(F.http_get(f"https://itunes.apple.com/search?term={q}&country={country}&entity=software&limit=6"))
        except Exception:
            return None
        for r in d.get("results", []):
            seller = (r.get("sellerName", "") + " " + r.get("artistName", "")).lower()
            if any(t in seller for t in tokens) and any(t in r.get("trackName", "").lower() for t in tokens):
                art = r.get("artworkUrl512") or r.get("artworkUrl100", "").replace("100x100", "512x512")
                img = Image.open(io.BytesIO(F.http_get(art))).convert("RGBA").resize((F.SIZE, F.SIZE), Image.LANCZOS)
                mask = Image.new("L", (F.SIZE, F.SIZE), 0)
                ImageDraw.Draw(mask).rounded_rectangle((0, 0, F.SIZE - 1, F.SIZE - 1), radius=int(F.SIZE * 0.22), fill=255)
                img.putalpha(mask)
                return img, art, r.get("trackName"), r.get("sellerName")
        time.sleep(0.6)
    return None

import io  # noqa: E402

def process(args):
    p, allow_appstore = args
    cid = p["id"]
    errors = []
    for kind, ref in candidates(p):
        try:
            img, url = F.fetch(kind, ref)
            img = F.fit_canvas(img)
            tone = F.tone_of(img)
            if tone == "empty":
                raise RuntimeError("blank")
            return cid, img, {"file": f"assets/logos/{cid}.png", "tone": tone, "source": kind, "url": url}
        except Exception as e:  # noqa: BLE001
            errors.append(f"{kind}:{ref}:{str(e)[:60]}")
    if allow_appstore:
        try:
            r = appstore(p)
            if r:
                img, art, track, seller = r
                return cid, img, {"file": f"assets/logos/{cid}.png", "tone": "color", "source": "appstore", "url": art, "app": track, "seller": seller}
        except Exception as e:  # noqa: BLE001
            errors.append(f"appstore:{str(e)[:60]}")
    return cid, None, errors

def main():
    cat = json.load(open(os.path.join(ROOT, "assets", "catalog", "platforms.json")))["platforms"]
    mpath = os.path.join(ROOT, "tool", "logo_manifest.json")
    manifest = json.load(open(mpath))
    glyphs = set(re.findall(r"^  '([^']+)':", open(os.path.join(ROOT, "lib", "shared", "brand", "brand_icons.g.dart")).read(), re.M))
    todo = []
    for p in cat:
        if p["id"] in manifest:
            continue
        has_glyph = bool(p.get("icon")) and p["icon"] in glyphs
        todo.append((p, not has_glyph))
    print(f"{len(todo)} entries to fill ({sum(1 for _, a in todo if a)} without any mark)", file=sys.stderr)
    done, failed = 0, []
    with cf.ThreadPoolExecutor(max_workers=6) as ex:
        for cid, img, meta in ex.map(process, todo):
            if img is None:
                failed.append((cid, meta[-1] if meta else "no candidates"))
                continue
            img.save(os.path.join(OUT, f"{cid}.png"), optimize=True)
            manifest[cid] = meta
            done += 1
            print(f"ok   {cid:30s} {meta['source']:8s} {meta['tone']:5s} {meta.get('app', '')} {meta['url'][:80]}")
    json.dump(dict(sorted(manifest.items())), open(mpath, "w"), indent=1)
    with open(os.path.join(ROOT, "docs", "LOGO_SOURCES.md"), "w") as f:
        f.write("# Logo sources\n\nGenerated by `tool/fetch_logos.py`, `tool/fetch_appstore_icons.py` and `tool/fill_missing_logos.py`. Each file is the brand's own mark as published by the listed source, rasterised to 256px. Trademarks belong to their owners; the marks identify services inside a personal organiser.\n\n")
        f.write("| Catalog id | Source | URL | Tone |\n| --- | --- | --- | --- |\n")
        for cid, meta in sorted(manifest.items()):
            f.write(f"| {cid} | {meta['source']} | {meta['url']} | {meta['tone']} |\n")
    print(f"\n{done} written, {len(failed)} still missing", file=sys.stderr)
    for cid, why in failed:
        print(f"  {cid}: {why}", file=sys.stderr)

if __name__ == "__main__":
    main()
