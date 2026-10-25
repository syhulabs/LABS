#!/usr/bin/env python3
"""Fifth pass: targeted corrections from the visual logo audit.

Each override names the brand's *own* published mark: its official App Store
icon (looked up by trackId, seller verified), an asset on the brand's own site,
or a reputable icon set (Simple Icons, svgl, gilbarbara, homarr dashboard-icons,
LobeHub). Nothing is drawn or generated. `crop` only trims the published file:
"left" keeps the symbol at the left of an official lockup (symbol + wordmark),
"main" keeps the largest connected shape (drops a detached TM sign).
DELETE lists ids whose only available mark was wrong (another brand, the parent
company, or unusably low resolution); the app then falls back to its brand
glyph or monogram, which is better than a wrong logo.

Run after the other passes, then normalise the touched ids:
  python3 tool/fix_logo_overrides.py [--only id1,id2]
  python3 tool/normalize_logos.py --only <ids printed by this script>"""
import io, json, os, subprocess, sys, time, urllib.request, zipfile
from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fetch_logos as F  # noqa: E402

ROOT, OUT, SIZE = F.ROOT, F.OUT, F.SIZE
SI = "https://cdn.jsdelivr.net/npm/simple-icons@{v}/icons/{slug}.svg"
DASH = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/{}.svg"
GIL = "https://cdn.jsdelivr.net/gh/gilbarbara/logos@main/logos/{}.svg"
GPL = "https://fonts.gstatic.com/s/i/productlogos/{}/192px.svg"  # Google's own product-logo library
MAXON = "https://mxwebnuxtprod01.blob.core.windows.net/media/images/Products/{}"

def AS(track, seller, country="us"):
    return {"kind": "appstore", "id": track, "seller": seller, "country": country}

def URL(source, url, crop=None):
    return {"kind": "url", "source": source, "url": url, "crop": crop}

def SIMPLE(slug, hex_, v="16.25.0"):
    return {"kind": "simple", "slug": slug, "hex": hex_, "v": v}

OVERRIDES = {
    # A. subscription services
    "apple-arcade": URL("site", "https://www.apple.com/v/apple-one/g/images/overview/icon_arcade__bcp3eftw1hhu_large_2x.png"),
    "apple-one": URL("site", "https://www.apple.com/v/apple-arcade/q/images/overview/full_apple_one__ggj3x96swk6e_large_2x.png", "left"),
    "adobe-express": AS(1051937863, "Adobe"),
    "nintendo-switch-online": AS(1234806557, "Nintendo"),  # the Nintendo Switch Online app, renamed "Nintendo Switch App"
    "playstation-plus": URL("site", "https://gmedia.playstation.com/is/image/SIEPDC/ps-plus-blue-bag-icon-01-22sep20?$native--t$", "main"),
    "adobe-creative-cloud": SIMPLE("adobecreativecloud", "DA1F26", "13.21.0"),  # removed from later Simple Icons releases
    # B. wrong brand
    "luma-events": AS(1546150895, "Luma Labs"),
    "iconfinder": SIMPLE("iconfinder", "1A1B1F"),
    "freepik": SIMPLE("freepik", "1273EB"),
    "magnific": URL("site", "https://media.magnific.com/magnific-favicons/favicon.svg?v=2"),
    "super-so": URL("site", "https://super-site-assets.s3.eu-central-003.backblazeb2.com/186f4256-f467-4f79-8d6f-40defe12b9b4/images/1fedca29-8b6d-4f22-835c-057d23866ff0/logo.svg"),
    "microsoft-forms": URL("site", "https://res-1.cdn.office.net/files/fabric-cdn-prod_20230815.002/assets/brand-icons/product/svg/forms_48x1.svg"),
    "dorico": URL("site", "https://ocl-steinberg-live.steinberg.net/_storage/asset/62049/storage/master/Dorico%20Logo%20generic%20red-grey.svg", "left"),
    "cloudflare-warp": AS(1423538627, "Cloudflare"),  # 1.1.1.1 + WARP
    # C. broken / poor quality
    "toon-boom-harmony": URL("site", "https://cdn3.toonboom.com/wp-content/uploads/2025/05/20181812/favicon-toonboom-dark-96x96.png"),
    "twine": URL("site", "https://cdn.jsdelivr.net/gh/klembot/twinejs@develop/icons/app-pwa.svg"),  # Twine's own repo; the site favicon is translucent
    "paramount-plus": AS(530168168, "CBS"),
    "ea-app": URL("dash", DASH.format("electronic-arts")),
    "air-india": AS(932302964, "Air India", "in"),
    "deutsche-bank-india": AS(1310646583, "Deutsche Bank", "in"),
    "hdfc-bank": URL("site", "https://www.hdfc.bank.in/content/dam/hdfcbankpws/home-page/hdfc-bank-logo.svg", "square"),
    "kotak-mahindra-bank": URL("site", "https://www.kotak.bank.in/content/dam/Kotak/svg-icons/navigation/kmbl-logo.svg", "left"),
    "bsnl": AS(6444714277, "Bharat Sanchar", "in"),
    "bank-of-baroda": URL("site", "https://bankofbaroda.bank.in/-/media/project/bob/countrywebsites/india/icons/bob-logo.svg", "left"),
    "apple-books-for-authors": AS(364709193, "Apple"),
    # D. product marks instead of the parent's
    "apple-news-plus": AS(1066498020, "Apple"),
    "apple-wallet": AS(1160481993, "Apple"),
    "apple-health": AS(1242545199, "Apple"),
    "apple-freeform": AS(6443742539, "Apple"),
    "iwork": AS(361309726, "Apple"),  # Pages; the suite has no mark of its own
    "shortcuts": AS(915249334, "Apple"),
    "apple-classroom": AS(1085319084, "Apple"),
    "apple-research": AS(1463884356, "Apple"),
    "apple-vision-pro": AS(6502614761, "Apple"),
    "imessage-facetime": AS(1146560473, "Apple"),  # Messages
    "imovie": AS(377298193, "Apple"),
    "apple-weather": AS(1069513131, "Apple"),
    "apple-maps-connect": AS(915056765, "Apple"),
    "google-business-profile": URL("site", GPL.format("google_my_business/v7")),
    "google-merchant-center": URL("site", GPL.format("merchant_center/v8")),
    "google-family-link": URL("site", GPL.format("family_link/v5")),
    "google-password-manager": URL("site", GPL.format("password_manager/v1")),
    "stadia": URL("site", GPL.format("stadia/v6")),
    "google-play-books-partner": URL("site", GPL.format("play_books/v8")),
    "google-play-pass": URL("site", GPL.format("playpass/v7")),
    "microsoft-store": URL("site", "https://apps.microsoft.com/assets/icons/logo-plated-256x256.png"),
    "msn": AS(945416273, "Microsoft"),
    "microsoft-family-safety": AS(1489209093, "Microsoft"),
    "azure-openai": {"kind": "zip", "source": "site", "url": "https://arch-center.azureedge.net/icons/Azure_Public_Service_Icons_V23.zip",
                     "member": "Azure_Public_Service_Icons/Icons/ai + machine learning/03438-icon-service-Azure-OpenAI.svg"},
    "microsoft-365-basic": {"kind": "alias", "of": "microsoft-365"},
    "cinema-4d": URL("site", MAXON.format("Cinema-4D/C4D_icon.svg")),
    "zbrush": URL("site", MAXON.format("ZBrush/ZBrush_icon.svg")),
    "adobe-audition": URL("svgl", "https://svgl.app/library/audition.svg"),
    "amazon-alexa": AS(944011620, "AMZN"),
    "amazon-photos": AS(621574163, "AMZN"),
    "zoho-books": AS(710446064, "Zoho"),
    # E. square marks instead of wide wordmarks
    "quora": AS(456034437, "Quora"),
    "behance": AS(489667151, "Adobe"),
    "mixpanel": URL("site", "https://framerusercontent.com/images/j6EPdIw4BKPE9dPx3zrTjkkAM14.png"),  # mixpanel.com apple-touch-icon
    "clickup": URL("gil", GIL.format("clickup-icon")),
    "zapier": SIMPLE("zapier", "FF4F00"),
    "hubspot": AS(1107711722, "HubSpot"),
    "pipedrive": AS(921456160, "Pipedrive"),
    "gusto": AS(1478804271, "Gusto"),
    "mention": URL("site", "https://mention.com/wp-content/uploads/2025/03/cropped-favicon-270x270.png"),
    "trustpilot": AS(1608392803, "Trustpilot"),
    "ghost": URL("site", "https://ghost.org/favicon.png"),
    "idrive": AS(427956708, "IDrive"),
    "amazon-prime-video": AS(545519333, "AMZN"),
    "coursera": AS(736535961, "Coursera"),
    "quizlet": AS(546473125, "Quizlet"),
    "amazon-s3": URL("gil", GIL.format("aws-s3")),
}

DELETE = {
    "koo": "Koo shut down; the file was Wix's favicon and no icon set carries an official Koo mark",
    "mojang-studios": "only the Minecraft creeper is published (mojang.com redirects to minecraft.net); no Mojang mark in any icon set",
    "nest": "file was the Google Store bag; no official Nest mark file found (Google Home is a different product)",
    "levelplay": "file was the Unity logo; LevelPlay publishes no mark of its own (levelplay.com/is.com serve Unity's icons)",
    "rodin": "the only published mark (hyper3d.ai apple-touch-icon) is itself pixelated",
    "apple-card": "no Apple Card product icon is published (apple.com shows card photos and the Apple logo)",
    "apple-cash": "no Apple Cash product icon is published (apple.com shows the Apple logo lockup only)",
    "time-machine": "macOS-only feature with no App Store icon; Apple Support only shows a menu-bar glyph",
    "google-takeout": "file was the Google G; takeout.google.com publishes no icon of its own",
    "google-workspace": "Google Workspace has only a wide wordmark; workspace.google.com uses the Google G",
    "microsoft-advertising": "file was the Microsoft logo; Microsoft Advertising has no mark of its own",
    "playfab": "file was the Microsoft logo; no official PlayFab mark found on playfab.com or Microsoft Learn",
    "adobe-substance-3d": "file was the Adobe A; no Substance 3D collection mark in Adobe's site or icon sets (only per-app icons)",
}

UA = "SYHUAccountHub/0.1 logo-fetch"

def get(url):
    for attempt in range(4):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": F.UA if "apple.com" in url or "playstation" in url else UA})
            with urllib.request.urlopen(req, timeout=60) as r:
                return r.read()
        except Exception as e:  # noqa: BLE001
            err = e
            time.sleep(5 * (attempt + 1))
    raise err

def raster(data, height=768):
    """Rasterise SVG with librsvg (height fixed so wide lockups keep a sharp symbol); decode bitmaps as-is."""
    if data.lstrip()[:5] in (b"<svg ", b"<?xml") or b"<svg" in data[:300]:
        png = subprocess.run(["rsvg-convert", "-h", str(height), "--keep-aspect-ratio"], input=data, capture_output=True, timeout=60)
        if png.returncode != 0 or not png.stdout:
            raise RuntimeError(png.stderr.decode(errors="ignore")[:200])
        data = png.stdout
    return Image.open(io.BytesIO(data)).convert("RGBA")

def crop_left(img):
    """Keep the first run of occupied columns (the symbol of a symbol+wordmark lockup)."""
    a = img.getchannel("A").point(lambda v: 255 if v > 20 else 0)
    w, h = img.size
    cols = [a.crop((x, 0, x + 1, h)).getbbox() is not None for x in range(w)]
    start = cols.index(True)
    end = start
    while end < w and cols[end]:
        end += 1
    return img.crop((start, 0, end, h))

def crop_square(img):
    """Keep the left square (symbol boxed at the left of a full-height lockup)."""
    return img.crop((0, 0, img.height, img.height))

def crop_main(img):
    """Keep the bounding box of the largest connected shape."""
    small = img.getchannel("A").resize((160, 160)).point(lambda v: 255 if v > 40 else 0)
    px, seen, best = small.load(), set(), None
    for y in range(160):
        for x in range(160):
            if px[x, y] and (x, y) not in seen:
                stack, comp = [(x, y)], []
                seen.add((x, y))
                while stack:
                    cx, cy = stack.pop()
                    comp.append((cx, cy))
                    for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                        if 0 <= nx < 160 and 0 <= ny < 160 and px[nx, ny] and (nx, ny) not in seen:
                            seen.add((nx, ny))
                            stack.append((nx, ny))
                if best is None or len(comp) > len(best):
                    best = comp
    sx, sy = img.width / 160, img.height / 160
    xs, ys = [p[0] for p in best], [p[1] for p in best]
    return img.crop((int(min(xs) * sx), int(min(ys) * sy), int((max(xs) + 1) * sx), int((max(ys) + 1) * sy)))

CROPS = {"left": crop_left, "square": crop_square, "main": crop_main}

def rounded(img):
    img = img.convert("RGBA").resize((SIZE, SIZE), Image.LANCZOS)
    mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, SIZE - 1, SIZE - 1), radius=int(SIZE * 0.22), fill=255)
    img.putalpha(mask)
    return img

def build(cid, spec, manifest):
    k = spec["kind"]
    if k == "appstore":
        d = json.loads(get(f"https://itunes.apple.com/lookup?id={spec['id']}&country={spec['country']}"))
        r = (d.get("results") or [None])[0]
        if not r or spec["seller"].lower() not in (r.get("sellerName", "") + " " + r.get("artistName", "")).lower():
            raise RuntimeError(f"seller mismatch for {spec['id']}: {r and r.get('sellerName')}")
        art = r.get("artworkUrl512") or r["artworkUrl100"].replace("100x100", "512x512")
        time.sleep(1.5)
        return rounded(Image.open(io.BytesIO(get(art)))), {"source": "appstore", "url": art, "app": r.get("trackName"), "seller": r.get("sellerName")}
    if k == "alias":
        parent = manifest[spec["of"]]
        return Image.open(os.path.join(OUT, f"{spec['of']}.png")).convert("RGBA"), {"source": f"alias:{spec['of']}", "url": parent["url"]}
    if k == "lobe":
        img, url = F.fetch("lobe", spec["ref"])
        return img, {"source": "lobe", "url": url}
    if k == "simple":
        url = SI.format(v=spec["v"], slug=spec["slug"])
        svg = get(url).replace(b"<svg ", f'<svg fill="#{spec["hex"]}" '.encode(), 1)
        return raster(svg), {"source": "simple", "url": url}
    if k == "zip":
        z = zipfile.ZipFile(io.BytesIO(get(spec["url"])))
        return raster(z.read(spec["member"])), {"source": spec["source"], "url": spec["url"] + "#" + spec["member"].rsplit("/", 1)[-1]}
    img = raster(get(spec["url"]))
    if spec.get("crop"):
        img = CROPS[spec["crop"]](img)
    meta = {"source": spec["source"], "url": spec["url"]}
    if spec.get("crop"):
        meta["crop"] = spec["crop"]
    return img, meta

def main():
    only = set(sys.argv[sys.argv.index("--only") + 1].split(",")) if "--only" in sys.argv else None
    mpath = os.path.join(ROOT, "tool", "logo_manifest.json")
    manifest = json.load(open(mpath))
    done, failed = [], []
    for cid, why in DELETE.items():
        if only and cid not in only:
            continue
        path = os.path.join(OUT, f"{cid}.png")
        if os.path.exists(path):
            os.remove(path)
        if manifest.pop(cid, None) is not None:
            print(f"del  {cid:26s} {why}")
    for cid, spec in OVERRIDES.items():
        if only and cid not in only:
            continue
        try:
            img, meta = build(cid, spec, manifest)
            F.fit_canvas(img).save(os.path.join(OUT, f"{cid}.png"), optimize=True)
            prev = manifest.get(cid, {})
            manifest[cid] = {"file": f"assets/logos/{cid}.png", "tone": prev.get("tone", "color"), **meta}
            done.append(cid)
            print(f"ok   {cid:26s} {meta['source']:9s} {meta.get('app') or ''} {meta['url'][:90]}")
        except Exception as e:  # noqa: BLE001
            failed.append((cid, str(e)[:120]))
            print(f"FAIL {cid}: {e}", file=sys.stderr)
    json.dump(dict(sorted(manifest.items())), open(mpath, "w"), indent=1)
    print(f"\n{len(done)} replaced, {len(failed)} failed; normalise with:\n  python3 tool/normalize_logos.py --only {','.join(done)}", file=sys.stderr)

if __name__ == "__main__":
    main()
