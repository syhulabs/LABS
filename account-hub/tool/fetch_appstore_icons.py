#!/usr/bin/env python3
"""Second pass: official app icons from Apple's public App Store search API
(https://itunes.apple.com/search). Used for Apple's own apps (whose websites
only expose the Apple logo) and for brands whose sites block icon fetches.
The artwork is the developer's published App Store icon; the seller name is
verified against an expected substring so a look-alike app is never picked.
Run after fetch_logos.py: python3 tool/fetch_appstore_icons.py
Ids whose App Store icon is unsuitable (banners, renamed apps, no app) live in
fix_logo_overrides.py instead."""
import io, json, os, sys, time, urllib.parse, urllib.request
from PIL import Image, ImageDraw

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "logos")
SIZE = 256

# catalog id -> (search term, country, expected seller substring, bundleId hint or None)
APPS = {
    "apple-notes": ("Apple Notes", "us", "Apple", "com.apple.mobilenotes"),
    "apple-reminders": ("Reminders", "us", "Apple", "com.apple.reminders"),
    "apple-calendar": ("Calendar", "us", "Apple", "com.apple.mobilecal"),
    "apple-photos": ("Photos", "us", "Apple", "com.apple.mobileslideshow"),
    "apple-passwords": ("Passwords", "us", "Apple", "com.apple.Passwords"),
    "find-my": ("Find My", "us", "Apple", "com.apple.findmy"),
    "apple-books": ("Apple Books", "us", "Apple", "com.apple.iBooks"),
    "apple-fitness-plus": ("Fitness", "us", "Apple", "com.apple.Fitness"),
    "testflight": ("TestFlight", "us", "Apple", "com.apple.TestFlight"),
    "apple-developer-program": ("Apple Developer", "us", "Apple", "com.apple.developer"),
    "icloud-drive": ("Files", "us", "Apple", "com.apple.DocumentsApp"),
    "icloud-mail": ("Mail", "us", "Apple", "com.apple.mobilemail"),
    "final-cut-pro": ("Final Cut Pro", "us", "Apple", "com.apple.finalcut.ipad"),
    "logic-pro": ("Logic Pro", "us", "Apple", "com.apple.logic.ipad"),
    "garageband": ("GarageBand", "us", "Apple", "com.apple.mobilegarageband"),
    "apple-tv-plus": ("Apple TV", "us", "Apple", "com.apple.tv"),
    "apple-podcasts": ("Apple Podcasts", "us", "Apple", "com.apple.podcasts"),
    "safari": ("Safari", "us", "Apple", None),
    "app-store-connect": ("App Store Connect", "us", "Apple", "com.apple.AppStoreConnect"),
    "state-bank-of-india": ("YONO SBI", "in", "State Bank of India", None),
    "icici-bank": ("iMobile Pay ICICI", "in", "ICICI Bank", None),
    "axis-bank": ("Axis Mobile", "in", "Axis Bank", None),
    "indian-bank": ("IndSMART Indian Bank", "in", "Indian Bank", None),
    "canara-bank": ("Canara ai1", "in", "Canara Bank", None),
    "punjab-national-bank": ("PNB ONE", "in", "Punjab National Bank", None),
    "union-bank-of-india": ("Vyom Union Bank", "in", "Union Bank of India", None),
    "idfc-first-bank": ("IDFC FIRST Bank", "in", "IDFC FIRST Bank", None),
    "paytm": ("Paytm", "in", "One97", None),
    "phonepe": ("PhonePe", "in", "PhonePe", None),
    "bhim": ("BHIM", "in", "National Payments Corporation", None),
    "payu": ("PayU", "in", "PayU", None),
    "amazon-kindle": ("Kindle", "us", "AMZN", None),
    "google-authenticator": ("Google Authenticator", "us", "Google", None),
    "ajio": ("AJIO", "in", "Reliance", None),
    "meesho": ("Meesho", "in", "Meesho", None),
    "bigbasket": ("bigbasket", "in", "Supermarket Grocery", None),
    "irctc": ("IRCTC Rail Connect", "in", "Indian Railway", None),
    "heygen": ("HeyGen", "us", "HeyGen", None),
    "later": ("Later: Social Media Scheduler", "us", "Later", None),
    "beatport": ("Beatport", "us", "Beatport", None),
    "ditto-music": ("Ditto Music", "us", "Ditto", None),
    "onerpm": ("ONErpm", "us", "ONErpm", None),
    "pro-tools": ("Pro Tools Sketch", "us", "Avid", None),
    "studio-one": ("Studio One", "us", "PreSonus", None),
    "kits-ai": ("Kits AI", "us", "Kits", None),
    "swiggy": ("Swiggy", "in", "Swiggy", None),
    "zomato": ("Zomato", "in", "Zomato", None),
    "myntra": ("Myntra", "in", "Myntra", None),
    "zepto": ("Zepto", "in", "Zepto", None),
    "blinkit": ("Blinkit", "in", "Blink Commerce", None),
    "ola": ("Ola Cabs", "in", "ANI Technologies", None),
    "rapido": ("Rapido", "in", "Roppen", None),
    "makemytrip": ("MakeMyTrip", "in", "MakeMyTrip", None),
    "jiohotstar": ("JioHotstar", "in", "Star India", None),
    "sonyliv": ("Sony LIV", "in", "Culver Max", None),
    "zee5": ("ZEE5", "in", "Zee", None),
    "cashfree-payments": ("Cashfree", "in", "Cashfree", None),
    "razorpay": ("Razorpay", "in", "Razorpay", None),
    "google-pay": ("Google Pay", "in", "Google", None),
    "cred": ("CRED", "in", "Dreamplug", None),
    "distrokid": ("DistroKid", "us", "DistroKid", None),
    "cd-baby": ("CD Baby", "us", "CD Baby", None),
    "amuse": ("Amuse", "us", "Amuse", None),
    "unitedmasters": ("UnitedMasters", "us", "UnitedMasters", None),
    "landr": ("LANDR", "us", "LANDR", None),
    "soundexchange": ("SoundExchange", "us", "SoundExchange", None),
    "ascap": ("ASCAP", "us", "ASCAP", None),
    "bmi": ("BMI", "us", "Broadcast Music", None),
    "vidiq": ("vidIQ", "us", "vidIQ", None),
    "tubebuddy": ("TubeBuddy", "us", "TubeBuddy", None),
    "streamyard": ("StreamYard", "us", "StreamYard", None),
    "milanote": ("Milanote", "us", "Milanote", None),
    "scrivener": ("Scrivener", "us", "Literature", None),
    "celtx": ("Celtx", "us", "Celtx", None),
    "final-draft": ("Final Draft", "us", "Final Draft", None),
    "storytel": ("Storytel", "in", "Storytel", None),
    "aiva": ("AIVA", "us", "Aiva", None),
    "soundraw": ("SOUNDRAW", "us", "SOUNDRAW", None),
    "mubert": ("Mubert", "us", "Mubert", None),
    "freshsales": ("Freshsales", "us", "Freshworks", None),
    "tally": ("TallyPrime", "in", "Tally", None),
    "sprout-social": ("Sprout Social", "us", "Sprout", None),
    "linktree": ("Linktree", "us", "Linktree", None),
    "beacons": ("Beacons", "us", "Beacons", None),
    "dailymotion": ("Dailymotion", "us", "Dailymotion", None),
    "streamlabs": ("Streamlabs", "us", "Logitech", None),
    "restream": ("Restream", "us", "Restream", None),
    "audiomack": ("Audiomack", "us", "Audiomack", None),
    "shazam": ("Shazam", "us", "Apple", None),
    "discogs": ("Discogs", "us", "Discogs", None),
    "line": ("LINE", "us", "LINE", None),
    "wechat": ("WeChat", "us", "Tencent", None),
    "leonardo-ai": ("Leonardo.Ai", "us", "Leonardo", None),
    "synthesia": ("Synthesia", "us", "Synthesia", None),
    "character-ai": ("Character.AI", "us", "Character", None),
    "roblox": ("Roblox", "us", "Roblox", None),
    "ubisoft-connect": ("Ubisoft Connect", "us", "Ubisoft", None),
    "battle-net": ("Battle.net", "us", "Blizzard", None),
    "gog": ("GOG Galaxy", "us", "GOG", None),
    "audible": ("Audible", "us", "Audible", None),
    "etsy": ("Etsy", "us", "Etsy", None),
    "gumroad": ("Gumroad", "us", "Gumroad", None),
    "docusign": ("Docusign", "us", "Docusign", None),
    "flipkart": ("Flipkart", "in", "Flipkart", None),
    "booking-com": ("Booking.com", "us", "Booking.com", None),
    "duolingo": ("Duolingo", "us", "Duolingo", None),
    "edx": ("edX", "us", "edX", None),
    "skillshare": ("Skillshare", "us", "Skillshare", None),
    "brilliant": ("Brilliant", "us", "Brilliant", None),
    "datacamp": ("DataCamp", "us", "DataCamp", None),
    "freecodecamp": ("freeCodeCamp", "us", "Free Code Camp", None),
    "hackerrank": ("HackerRank", "us", "HackerRank", None),
    "2fas": ("2FAS Auth", "us", "Two Factor Authentication Service", None),
    "surfshark": ("Surfshark", "us", "Surfshark", None),
    "pcloud": ("pCloud", "us", "pCloud", None),
    "sync-com": ("Sync.com", "us", "Sync.com", None),
    "quickbooks": ("QuickBooks", "us", "Intuit", None),
    "freshbooks": ("FreshBooks", "us", "FreshBooks", None),
    "microsoft-entra-id": ("Microsoft Authenticator", "us", "Microsoft", None),
    "microsoft-authenticator": ("Microsoft Authenticator", "us", "Microsoft", None),
    "google-ai-studio": ("Gemini", "us", "Google", None),
}

UA = "SYHUAccountHub/0.1 logo-fetch"

def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read()

def lookup(term, country, seller, bundle):
    if bundle:
        try:
            d = json.loads(get(f"https://itunes.apple.com/lookup?bundleId={bundle}&country={country}"))
            for r in d.get("results", []):
                if seller.lower() in (r.get("sellerName", "") + r.get("artistName", "")).lower():
                    return r
        except Exception:
            pass
    q = urllib.parse.quote(term)
    d = json.loads(get(f"https://itunes.apple.com/search?term={q}&country={country}&entity=software&limit=8"))
    for r in d.get("results", []):
        if seller.lower() in (r.get("sellerName", "") + " " + r.get("artistName", "")).lower():
            return r
    return None

def main():
    only = set(sys.argv[sys.argv.index("--only") + 1].split(",")) if "--only" in sys.argv else None
    mpath = os.path.join(ROOT, "tool", "logo_manifest.json")
    manifest = json.load(open(mpath)) if os.path.exists(mpath) else {}
    ok, miss = 0, []
    for cid, (term, country, seller, bundle) in APPS.items():
        if only and cid not in only:
            continue
        # Only replace an existing logo when it came from a weak source (site/favicon) or is an Apple generic.
        prev = manifest.get(cid)
        if prev and prev.get("source") in ("lobe", "dash", "gil", "svgl") and not cid.startswith(("apple-", "icloud", "find-my", "testflight", "safari", "garageband", "logic-pro", "final-cut")):
            continue
        try:
            r = lookup(term, country, seller, bundle)
            if not r:
                miss.append((cid, "no matching app"))
                continue
            art = r.get("artworkUrl512") or r.get("artworkUrl100", "").replace("100x100", "512x512")
            img = Image.open(io.BytesIO(get(art))).convert("RGBA").resize((SIZE, SIZE), Image.LANCZOS)
            # App Store artwork is square; apply the iOS-style rounded mask so it matches other tiles.
            mask = Image.new("L", (SIZE, SIZE), 0)
            ImageDraw.Draw(mask).rounded_rectangle((0, 0, SIZE - 1, SIZE - 1), radius=int(SIZE * 0.22), fill=255)
            img.putalpha(mask)
            img.save(os.path.join(OUT, f"{cid}.png"), optimize=True)
            manifest[cid] = {"file": f"assets/logos/{cid}.png", "tone": "color", "source": "appstore", "url": art, "app": r.get("trackName"), "seller": r.get("sellerName")}
            ok += 1
            print(f"ok   {cid:26s} {r.get('trackName')!s:40.40s} by {r.get('sellerName')}")
            time.sleep(2.0)
        except Exception as e:  # noqa: BLE001
            miss.append((cid, str(e)[:100]))
    json.dump(dict(sorted(manifest.items())), open(mpath, "w"), indent=1)
    with open(os.path.join(ROOT, "docs", "LOGO_SOURCES.md"), "w") as f:
        f.write("# Logo sources\n\nGenerated by `tool/fetch_logos.py` and `tool/fetch_appstore_icons.py`. Each file is the brand's own mark as published by the listed source, rasterised to 256px. Trademarks belong to their owners; the marks are used to identify the services inside a personal organiser.\n\n")
        f.write("| Catalog id | Source | URL | Tone |\n| --- | --- | --- | --- |\n")
        for cid, meta in sorted(manifest.items()):
            f.write(f"| {cid} | {meta['source']} | {meta['url']} | {meta['tone']} |\n")
    print(f"\n{ok} app icons written; {len(miss)} not found:", file=sys.stderr)
    for m in miss:
        print("  ", m, file=sys.stderr)

if __name__ == "__main__":
    main()
