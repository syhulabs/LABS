#!/usr/bin/env python3
"""Fetch coloured original brand logos for the catalog.

Sources, in priority order per brand (see tool/logo_targets.py):
  lobe  @lobehub/icons-static-svg (MIT; brand marks as published by LobeHub)
  dash  homarr-labs/dashboard-icons (jsDelivr CDN)
  gil   gilbarbara/logos (jsDelivr CDN)
  svgl  svgl.app library
  site  the brand's own website icon (apple-touch-icon / <link rel=icon>), then
        Google's favicon service as a last resort (>=64px only)

Every vector is rasterised with librsvg to a 256px PNG so rendering is
identical on every platform; nothing is redrawn or "AI-generated".
Outputs assets/logos/<catalog-id>.png, assets/logos/manifest.json (tone per
logo so dark marks get a light tile) and assets/logos/SOURCES.md.

Run: python3 tool/fetch_logos.py [--only id1,id2]
"""
import concurrent.futures as cf
import html.parser
import io
import json
import os
import re
import subprocess
import sys
import tempfile
import urllib.parse
import urllib.request

from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from logo_targets import T  # noqa: E402

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")
SRC = os.environ.get("LOGO_SRC", "/tmp/claude-0/-home-user-LABS/fd9cf3b3-0ed6-5787-9ad3-4d88021a57fb/scratchpad/logos-src")
LOBE_DIR = os.path.join(SRC, "lobe", "package", "icons")
SIZE = 256
UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/537.36 (KHTML, like Gecko) Safari/605.1.15 SYHUAccountHub/0.1 logo-fetch"

# Corrections discovered against the live inventories.
FIX = {
    "character-ai": {"site": "character.ai"},
    "google-ai-studio": {"gil": "google-aistudio", "site": "aistudio.google.com"},
    "lm-studio": {"lobe": "lmstudio", "site": "lmstudio.ai"},
    "cursor": {"lobe": "cursor", "gil": "cursor-icon"},
    "replit": {"lobe": "replit-color"},
    "bolt-new": {"gil": "bolt-icon", "site": "bolt.new"},
    "tabnine": {"site": "www.tabnine.com"},
    "midjourney": {"lobe": "midjourney", "gil": "midjourney"},
    "leonardo-ai": {"site": "leonardo.ai"},
    "dreamstudio": {"site": "dreamstudio.ai"},
    "freepik": {"site": "www.freepik.com"},
    "magnific": {"site": "magnific.ai"},
    "canva": {"svgl": "https://svgl.app/library/canva.svg", "site": "www.canva.com"},
    "heygen": {"site": "www.heygen.com"},
    "synthesia": {"site": "www.synthesia.io"},
    "higgsfield": {"site": "higgsfield.ai"},
    "elevenlabs": {"lobe": "elevenlabs", "gil": "elevenlabs-icon"},
    "youtube-studio": {"site": "studio.youtube.com", "dash": "youtube"},
    "vimeo": {"gil": "vimeo-icon"},
    "dailymotion": {"site": "www.dailymotion.com"},
    "restream": {"site": "restream.io"},
    "obs-studio": {"svgl": "https://svgl.app/library/obs.svg", "site": "obsproject.com"},
    "streamlabs": {"site": "streamlabs.com"},
    "whatsapp-business": {"dash": "whatsapp"},
    "line": {"site": "line.me"},
    "wechat": {"site": "www.wechat.com"},
    "messenger": {"dash": "facebook-messenger", "gil": "messenger"},
    "buffer": {"gil": "buffer"},
    "hootsuite": {"gil": "hootsuite-icon"},
    "sprout-social": {"site": "sproutsocial.com"},
    "linktree": {"site": "linktr.ee"},
    "amazon-music": {"site": "music.amazon.com"},
    "audiomack": {"site": "audiomack.com"},
    "beatport": {"site": "www.beatport.com"},
    "shazam": {"site": "www.shazam.com"},
    "discogs": {"site": "www.discogs.com"},
    "fl-studio": {"site": "www.image-line.com"},
    "ableton": {"site": "www.ableton.com"},
    "logic-pro": {"site": "www.apple.com"},
    "pro-tools": {"site": "www.avid.com"},
    "cubase": {"site": "www.steinberg.net"},
    "studio-one": {"site": "www.presonus.com"},
    "reaper": {"site": "www.reaper.fm"},
    "garageband": {"site": "www.apple.com"},
    "adobe-photoshop": {"gil": "adobe-photoshop"},
    "adobe-illustrator": {"gil": "adobe-illustrator"},
    "adobe-premiere-pro": {"gil": "adobe-premiere"},
    "adobe-after-effects": {"gil": "adobe-after-effects"},
    "davinci-resolve": {"site": "www.blackmagicdesign.com"},
    "cinema-4d": {"site": "www.maxon.net"},
    "affinity": {"svgl": "https://svgl.app/library/affinity_designer.svg", "site": "affinity.serif.com"},
    "procreate": {"site": "procreate.com"},
    "krita": {"site": "krita.org"},
    "azure-devops": {"dash": "azure-devops"},
    "visual-studio": {"gil": "visual-studio"},
    "jetbrains": {"gil": "jetbrains-icon"},
    "postman": {"gil": "postman-icon"},
    "insomnia": {"gil": "insomnia"},
    "pypi": {"gil": "pypi"},
    "homebrew": {"gil": "homebrew"},
    "trello": {"dash": "atlassian-trello", "gil": "trello"},
    "monday-com": {"gil": "monday-icon"},
    "zapier": {"dash": "zapier", "gil": "zapier"},
    "make": {"lobe": "make-color", "site": "www.make.com"},
    "ifttt": {"gil": "ifttt"},
    "digitalocean": {"dash": "digital-ocean", "gil": "digital-ocean-icon"},
    "render": {"svgl": "https://svgl.app/library/render_black.svg", "site": "render.com"},
    "railway": {"gil": "railway"},
    "heroku": {"gil": "heroku-icon"},
    "godaddy": {"dash": "godaddy"},
    "porkbun": {"site": "porkbun.com"},
    "dnsimple": {"site": "dnsimple.com"},
    "neon": {"dash": "neon-tech", "gil": "neon-icon"},
    "planetscale": {"gil": "planetscale"},
    "upstash": {"gil": "upstash-icon"},
    "google-ads": {"gil": "google-ads"},
    "google-adsense": {"gil": "google-adsense"},
    "google-play-console": {"gil": "google-play-icon"},
    "google-wallet": {"dash": "google-wallet"},
    "notebooklm": {"lobe": "notebooklm", "dash": "notebook-lm"},
    "icloud-mail": {"dash": "icloud"},
    "apple-photos": {"site": "www.icloud.com"},
    "apple-passwords": {"site": "www.icloud.com"},
    "find-my": {"site": "www.icloud.com"},
    "apple-developer-program": {"site": "developer.apple.com"},
    "testflight": {"site": "developer.apple.com"},
    "apple-tv-plus": {"dash": "apple-tv-plus"},
    "apple-books": {"site": "www.apple.com"},
    "apple-notes": {"site": "www.icloud.com"},
    "apple-reminders": {"site": "www.icloud.com"},
    "apple-calendar": {"site": "www.icloud.com"},
    "apple-fitness-plus": {"site": "www.apple.com"},
    "apple-arcade": {"site": "www.apple.com"},
    "safari": {"svgl": "https://svgl.app/library/safari.svg"},
    "xcode": {"gil": "xcode"},
    "final-cut-pro": {"site": "www.apple.com"},
    "app-store": {"dash": "app-store", "svgl": "https://svgl.app/library/appstore.svg"},
    "app-store-connect": {"dash": "app-store", "svgl": "https://svgl.app/library/appstore.svg"},
    "outlook": {"dash": "microsoft-outlook"},
    "microsoft-365": {"dash": "microsoft-365"},
    "microsoft-word": {"dash": "microsoft-word"},
    "microsoft-excel": {"dash": "microsoft-excel"},
    "microsoft-powerpoint": {"dash": "microsoft-powerpoint"},
    "onenote": {"dash": "microsoft-onenote"},
    "sharepoint": {"dash": "microsoft-sharepoint"},
    "power-bi": {"dash": "powerbi", "gil": "microsoft-power-bi"},
    "power-automate": {"dash": "microsoft-power-automate"},
    "microsoft-entra-id": {"site": "entra.microsoft.com"},
    "xbox": {"dash": "xbox", "svgl": "https://svgl.app/library/xbox.svg"},
    "epic-games": {"dash": "epic-games"},
    "gog": {"site": "www.gog.com"},
    "itch-io": {"site": "itch.io"},
    "ea-app": {"site": "www.ea.com"},
    "ubisoft-connect": {"site": "www.ubisoft.com"},
    "battle-net": {"site": "www.blizzard.com"},
    "playstation-network": {"dash": "playstation", "svgl": "https://svgl.app/library/playstation.svg"},
    "nintendo-account": {"dash": "nintendo-switch", "site": "www.nintendo.com"},
    "roblox": {"svgl": "https://svgl.app/library/roblox.svg", "site": "www.roblox.com"},
    "minecraft": {"dash": "minecraft"},
    "nexus-mods": {"site": "www.nexusmods.com"},
    "moddb": {"site": "www.moddb.com"},
    "curseforge": {"svgl": "https://svgl.app/library/curseforge.svg", "site": "www.curseforge.com"},
    "unreal-engine": {"dash": "unreal-engine", "gil": "unrealengine-icon"},
    "gamemaker": {"site": "gamemaker.io"},
    "construct": {"site": "www.construct.net"},
    "defold": {"site": "defold.com"},
    "cocos": {"site": "www.cocos.com"},
    "rpg-maker": {"site": "www.rpgmakerweb.com"},
    "gdevelop": {"site": "gdevelop.io"},
    "ren-py": {"site": "www.renpy.org"},
    "cryengine": {"site": "www.cryengine.com"},
    "stride": {"site": "www.stride3d.net"},
    "fab": {"site": "www.fab.com"},
    "chase": {"site": "www.chase.com"},
    "bank-of-america": {"site": "www.bankofamerica.com"},
    "citibank": {"site": "www.citi.com"},
    "hsbc": {"site": "www.hsbc.com"},
    "wells-fargo": {"site": "www.wellsfargo.com"},
    "stripe": {"gil": "stripe"},
    "razorpay": {"site": "razorpay.com"},
    "wise": {"site": "wise.com"},
    "paytm": {"site": "paytm.com"},
    "phonepe": {"site": "www.phonepe.com"},
    "payu": {"site": "payu.in"},
    "visa": {"gil": "visa"},
    "mastercard": {"gil": "mastercard"},
    "american-express": {"site": "www.americanexpress.com"},
    "zee5": {"site": "www.zee5.com"},
    "audible": {"site": "www.audible.com"},
    "amazon-kindle": {"site": "www.amazon.com"},
    "adobe-creative-cloud": {"gil": "adobe-icon", "site": "www.adobe.com"},
    "1password": {"dash": "1password"},
    "bitwarden": {"dash": "bitwarden"},
    "dashlane": {"gil": "dashlane-icon"},
    "keeper": {"dash": "keeper-security"},
    "google-authenticator": {"site": "support.google.com"},
    "microsoft-authenticator": {"site": "www.microsoft.com"},
    "authy": {"gil": "authy", "svgl": "https://svgl.app/library/authy.svg"},
    "2fas": {"site": "2fas.com"},
    "aegis-authenticator": {"site": "getaegis.app"},
    "surfshark": {"site": "surfshark.com"},
    "cloudflare-warp": {"dash": "cloudflare-zero-trust", "gil": "cloudflare-icon"},
    "firefox-relay": {"site": "relay.firefox.com", "dash": "firefox"},
    "mega": {"dash": "mega-nz"},
    "pcloud": {"site": "www.pcloud.com"},
    "sync-com": {"site": "www.sync.com"},
    "backblaze": {"dash": "backblaze"},
    "webflow": {"gil": "webflow"},
    "framer": {"gil": "framer"},
    "wix": {"gil": "wix"},
    "squarespace": {"gil": "squarespace"},
    "ghost": {"gil": "ghost"},
    "carrd": {"svgl": "https://svgl.app/library/carrd.svg", "site": "carrd.co"},
    "hubspot": {"gil": "hubspot"},
    "salesforce": {"gil": "salesforce"},
    "zoho": {"gil": "zoho"},
    "pipedrive": {"gil": "pipedrive"},
    "quickbooks": {"site": "quickbooks.intuit.com"},
    "xero": {"gil": "xero"},
    "freshbooks": {"site": "www.freshbooks.com"},
    "gumroad": {"site": "gumroad.com"},
    "etsy": {"site": "www.etsy.com"},
    "docusign": {"site": "www.docusign.com"},
    "flipkart": {"site": "www.flipkart.com"},
    "ebay": {"dash": "ebay"},
    "uber": {"svgl": "https://svgl.app/library/uber_light.svg", "site": "www.uber.com"},
    "booking-com": {"site": "www.booking.com"},
    "airbnb": {"gil": "airbnb-icon"},
    "coursera": {"gil": "coursera"},
    "edx": {"site": "www.edx.org"},
    "skillshare": {"site": "www.skillshare.com"},
    "khan-academy": {"gil": "khan_academy-icon"},
    "duolingo": {"site": "www.duolingo.com"},
    "brilliant": {"site": "brilliant.org"},
    "datacamp": {"site": "www.datacamp.com"},
    "freecodecamp": {"site": "www.freecodecamp.org"},
    "codecademy": {"dash": "code-cademy", "gil": "codecademy"},
    "hackerrank": {"site": "www.hackerrank.com"},
    "amazon-seller-central": {"dash": "amazon"},
    "amazon-prime-video": {"dash": "prime-video", "site": "www.primevideo.com"},
    "cloudflare": {"gil": "cloudflare-icon"},
}

ORDER = ["lobe", "dash", "gil", "svgl", "dash2", "site"]

def sources_for(cid, src):
    s = dict(src)
    s.update(FIX.get(cid, {}))
    return [(k, s[k]) for k in ORDER if k in s]

def http_get(url, timeout=25):
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "*/*"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read(), r.headers.get("Content-Type", "")

def svg_to_png(svg_bytes):
    with tempfile.NamedTemporaryFile(suffix=".svg", delete=False) as f:
        f.write(svg_bytes)
        path = f.name
    try:
        png = subprocess.run(["rsvg-convert", "-w", str(SIZE), "-h", str(SIZE), "--keep-aspect-ratio", path], capture_output=True, timeout=60)
        if png.returncode != 0 or not png.stdout:
            raise RuntimeError(png.stderr.decode(errors="ignore")[:200])
        return Image.open(io.BytesIO(png.stdout)).convert("RGBA")
    finally:
        os.unlink(path)

def fit_canvas(img):
    img = img.convert("RGBA")
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
    img.thumbnail((SIZE, SIZE), Image.LANCZOS)
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    canvas.paste(img, ((SIZE - img.width) // 2, (SIZE - img.height) // 2), img)
    return canvas

class _IconLinks(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
    def handle_starttag(self, tag, attrs):
        if tag.lower() != "link":
            return
        a = dict((k.lower(), v or "") for k, v in attrs)
        rel = a.get("rel", "").lower()
        if "icon" in rel and a.get("href"):
            size = 0
            m = re.search(r"(\d+)x(\d+)", a.get("sizes", ""))
            if m:
                size = int(m.group(1))
            elif "apple-touch-icon" in rel:
                size = 180
            self.links.append((size, a["href"], rel))

def fetch_site_icon(domain):
    base = f"https://{domain}"
    tried = []
    # 1. Conventional apple-touch-icon locations.
    for path in ("/apple-touch-icon.png", "/apple-touch-icon-precomposed.png", "/apple-touch-icon-180x180.png"):
        url = base + path
        try:
            data, ct = http_get(url)
            if "image" in ct or data[:4] == b"\x89PNG":
                img = Image.open(io.BytesIO(data))
                if min(img.size) >= 64:
                    return img, url
        except Exception:
            tried.append(url)
    # 2. Declared icons in the HTML head.
    try:
        html_bytes, _ = http_get(base + "/")
        p = _IconLinks()
        p.feed(html_bytes.decode("utf-8", errors="ignore")[:400000])
        for size, href, rel in sorted(p.links, key=lambda x: -x[0]):
            url = urllib.parse.urljoin(base + "/", href)
            try:
                data, ct = http_get(url)
                if url.lower().endswith(".svg") or "svg" in ct:
                    return svg_to_png(data), url
                img = Image.open(io.BytesIO(data))
                if min(img.size) >= 64:
                    return img, url
            except Exception:
                continue
    except Exception:
        pass
    # 3. Google's favicon service (real favicon, re-served); accept only if it is not a tiny upscale.
    url = f"https://www.google.com/s2/favicons?domain={domain}&sz=256"
    data, _ = http_get(url)
    img = Image.open(io.BytesIO(data))
    if min(img.size) >= 64:
        return img, url
    raise RuntimeError(f"no usable icon for {domain}")

def fetch(kind, ref):
    if kind == "lobe":
        path = os.path.join(LOBE_DIR, ref + ".svg")
        with open(path, "rb") as f:
            return svg_to_png(f.read()), f"@lobehub/icons-static-svg icons/{ref}.svg"
    if kind in ("dash", "dash2"):
        url = f"https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/{ref}.svg"
        data, _ = http_get(url)
        return svg_to_png(data), url
    if kind == "gil":
        url = f"https://cdn.jsdelivr.net/gh/gilbarbara/logos@main/logos/{ref}.svg"
        data, _ = http_get(url)
        return svg_to_png(data), url
    if kind == "svgl":
        data, _ = http_get(ref)
        return svg_to_png(data), ref
    if kind == "site":
        return fetch_site_icon(ref)
    raise ValueError(kind)

def tone_of(img):
    """'dark' = mostly near-black mark (needs a light tile), 'light' = mostly white, else 'color'."""
    small = img.resize((64, 64))
    px = [p for p in small.getdata() if p[3] > 100]
    if not px:
        return "empty"
    lum = [(0.2126 * r + 0.7152 * g + 0.0722 * b) / 255 for r, g, b, _ in px]
    sat = [(max(r, g, b) - min(r, g, b)) / 255 for r, g, b, _ in px]
    mean_l = sum(lum) / len(lum)
    mean_s = sum(sat) / len(sat)
    if mean_s < 0.12 and mean_l < 0.3:
        return "dark"
    if mean_s < 0.12 and mean_l > 0.85:
        return "light"
    return "color"

def process(target):
    name, cid, src = target
    errors = []
    for kind, ref in sources_for(cid, src):
        try:
            img, url = fetch(kind, ref)
            img = fit_canvas(img)
            tone = tone_of(img)
            if tone == "empty":
                raise RuntimeError("blank image")
            if tone == "light" and kind != "site":
                # A white mark would vanish on light surfaces; keep looking for a coloured one
                # but remember it in case nothing better exists.
                errors.append((kind, ref, "white-only"))
                fallback = (img, url, kind, tone)
                continue
            return cid, name, img, url, kind, tone, errors
        except Exception as e:  # noqa: BLE001
            errors.append((kind, ref, str(e)[:120]))
    if "fallback" in locals():
        img, url, kind, tone = fallback
        return cid, name, img, url, kind, tone, errors
    return cid, name, None, None, None, None, errors

def main():
    only = None
    if "--only" in sys.argv:
        only = set(sys.argv[sys.argv.index("--only") + 1].split(","))
    targets = [t for t in T if only is None or t[1] in only]
    os.makedirs(OUT, exist_ok=True)
    manifest_path = os.path.join(OUT, "manifest.json")
    manifest = json.load(open(manifest_path)) if os.path.exists(manifest_path) else {}
    results, failures = [], []
    with cf.ThreadPoolExecutor(max_workers=8) as ex:
        for cid, name, img, url, kind, tone, errors in ex.map(process, targets):
            if img is None:
                failures.append((cid, name, errors))
                print(f"FAIL {cid}: {errors}", file=sys.stderr)
                continue
            img.save(os.path.join(OUT, f"{cid}.png"), optimize=True)
            manifest[cid] = {"file": f"assets/logos/{cid}.png", "tone": tone, "source": kind, "url": url}
            results.append((cid, name, kind, url, tone))
            print(f"ok   {cid:28s} {kind:5s} {tone:5s} {url}")
    json.dump(dict(sorted(manifest.items())), open(manifest_path, "w"), indent=1)
    with open(os.path.join(OUT, "SOURCES.md"), "w") as f:
        f.write("# Logo sources\n\nGenerated by `tool/fetch_logos.py`. Each file is the brand's own mark as published by the listed source, rasterised to 256px. Trademarks belong to their owners; the marks are used to identify the services inside a personal organiser.\n\n")
        f.write("| Catalog id | Source | URL | Tone |\n| --- | --- | --- | --- |\n")
        for cid, meta in sorted(manifest.items()):
            f.write(f"| {cid} | {meta['source']} | {meta['url']} | {meta['tone']} |\n")
    print(f"\n{len(results)} logos written, {len(failures)} failed", file=sys.stderr)
    for cid, name, errors in failures:
        print(f"  {cid} ({name}): {errors[-1] if errors else '?'}", file=sys.stderr)

if __name__ == "__main__":
    main()
