#!/usr/bin/env python3
"""Fourth pass: (a) sub-brands that use their parent's mark reuse the parent
logo file (e.g. Amazon India → Amazon); (b) targeted App Store lookups with an
explicit seller for banks and regional apps the generic matcher skipped.
Run: python3 tool/alias_logos.py"""
import io, json, os, shutil, sys, time, urllib.parse, urllib.request
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fetch_logos as F

OUT = F.OUT
ALIAS = {
    "amazon-india": "amazon", "amazon-associates": "amazon", "amazon-photos": "amazon", "amazon-pay": "amazon", "kindle-unlimited": "amazon-kindle",
    "kindle-direct-publishing": "amazon", "audible-acx": "audible", "tiktok-for-business": "tiktok", "x-ads": "x",
    "deezer-for-creators": "deezer", "google-play-pass": "google-play", "google-play-books-partner": "google-play", "google-cloud-console": "google-cloud",
    "google-takeout": "google-account", "google-admin-console": "google-account", "google-password-manager": "google-account", "stadia": "google-account",
    "apple-podcasts-connect": "apple-podcasts", "apple-maps-connect": "apple-account", "apple-weather": "apple-account",
    "microsoft-store": "microsoft-account", "microsoft-forms": "microsoft-365", "msn": "microsoft-account",
    "epic-publishing": "epic-games", "battle-net-shop": "battle-net", "twitch-affiliate": "twitch", "github-sponsors": "github",
    "nintendo-developer-portal": "nintendo-account", "phonepe-business": "phonepe", "google-pay-for-business": "google-pay", "paytm-payments-bank": "paytm",
    "zoho-books": "zoho", "citi-india-axis": "citibank", "wechat-pay": "wechat", "geforce-now": "nvidia-account", "ditto-plus": "ditto-music",
    "amazon-alexa": "amazon", "pub-dev": "flutter", "crates-io": "rust", "super-so": "notion",
}
APPS = {
    "yes-bank": ("YES Bank", "in", "YES BANK"), "federal-bank": ("Federal Bank FedMobile", "in", "Federal Bank"), "bank-of-india": ("BOI Mobile", "in", "Bank of India"),
    "central-bank-of-india": ("Cent Mobile", "in", "Central Bank of India"), "idbi-bank": ("IDBI Bank GO Mobile+", "in", "IDBI"), "rbl-bank": ("RBL MoBank", "in", "RBL"),
    "bandhan-bank": ("Bandhan Bank mBandhan", "in", "Bandhan"), "south-indian-bank": ("SIB Mirror+", "in", "South Indian Bank"), "punjab-sind-bank": ("PSB UnIC", "in", "Punjab & Sind"),
    "bank-of-maharashtra": ("Mahamobile Plus", "in", "Bank of Maharashtra"), "jammu-kashmir-bank": ("J&K Bank mPay", "in", "Jammu"), "dcb-bank": ("DCB Bank", "in", "DCB"),
    "karur-vysya-bank": ("KVB DLite", "in", "Karur Vysya"), "tamilnad-mercantile-bank": ("TMB MBank", "in", "Tamilnad"), "csb-bank": ("CSB Bank", "in", "CSB"),
    "ujjivan-small-finance-bank": ("Ujjivan", "in", "Ujjivan"), "jana-small-finance-bank": ("Jana Bank", "in", "Jana"), "airtel-payments-bank": ("Airtel Thanks", "in", "Bharti Airtel"),
    "fino-payments-bank": ("FinoPay", "in", "Fino"), "india-post-payments-bank": ("IPPB Mobile", "in", "India Post"), "jio-payments-bank": ("JioFinance", "in", "Jio"),
    "lloyds-bank": ("Lloyds Bank Mobile Banking", "gb", "Lloyds"), "ing": ("ING Banking", "nl", "ING"), "rbc": ("RBC Mobile", "ca", "Royal Bank of Canada"), "scotiabank": ("Scotiabank Mobile Banking", "ca", "Scotiabank"),
    "paytm": ("Paytm: Secure UPI Payments", "in", "Paytm"), "mobikwik": ("MobiKwik", "in", "MobiKwik"), "coindcx": ("CoinDCX", "in", "CoinDCX"), "zerodha": ("Kite by Zerodha", "in", "Zerodha"),
    "groww": ("Groww", "in", "Groww"), "vanguard": ("Vanguard", "us", "Vanguard"), "fidelity": ("Fidelity Investments", "us", "Fidelity"), "rupay": ("RuPay", "in", "National Payments Corporation"),
    "upi": ("BHIM", "in", "National Payments Corporation"), "incometax-india": ("AIS for Taxpayer", "in", "Income Tax"), "aadhaar": ("mAadhaar", "in", "Unique Identification"), "epfo": ("UMANG", "in", "National e-Governance"),
    "bitly": ("Bitly", "us", "Bitly"), "printful": ("Printful", "us", "Printful"), "society6": ("Society6", "us", "Society6"), "big-cartel": ("Big Cartel", "us", "Big Cartel"),
    "reliance-digital": ("Reliance Digital", "in", "Reliance"), "best-buy": ("Best Buy", "us", "Best Buy"), "adidas": ("adidas", "us", "adidas"), "h-m": ("H&M", "us", "H & M"),
    "samsung-account": ("Samsung Members", "us", "Samsung"), "oneplus": ("OnePlus Community", "us", "OnePlus"), "xiaomi-account": ("Xiaomi Home", "us", "Xiaomi"), "sony-account": ("Sony | Headphones Connect", "us", "Sony"),
    "ring": ("Ring - Always Home", "us", "Ring"), "garmin-connect": ("Garmin Connect", "us", "Garmin"), "headspace": ("Headspace", "us", "Headspace"), "whoop": ("WHOOP", "us", "WHOOP"),
    "byju-s": ("BYJU'S", "in", "Think & Learn"), "scaler": ("Scaler", "in", "Scaler"), "geeksforgeeks": ("GeeksforGeeks", "in", "GeeksforGeeks"), "podia": ("Podia", "us", "Podia"), "graphy": ("Graphy", "in", "Unacademy"),
    "expedia": ("Expedia", "us", "Expedia"), "bsnl": ("BSNL Selfcare", "in", "Bharat Sanchar"), "tata-play": ("Tata Play", "in", "Tata Play"), "readwise": ("Readwise", "us", "Readwise"),
    "webtoon": ("WEBTOON", "us", "WEBTOON"), "wattpad": ("Wattpad", "us", "Wattpad"), "comixology": ("comiXology", "us", "comiXology"), "kobo-writing-life": ("Kobo Books", "us", "Kobo"),
    "lulu": ("Lulu", "us", "Lulu"), "jiosaavn": ("JioSaavn", "in", "Saavn"), "resso": ("Resso", "in", "Moon Video"), "hungama-music": ("Hungama Music", "in", "Hungama"), "moj": ("Moj", "in", "Mohalla"), "josh": ("Josh", "in", "VerSe"),
    "yahoo-mail": ("Yahoo Mail", "us", "Yahoo"), "aol-mail": ("AOL", "us", "Yahoo"), "kaggle": ("Kaggle", "us", "Kaggle"), "bandlab": ("BandLab", "us", "BandLab"), "linkfire": ("Linkfire", "us", "Linkfire"),
    "filmora": ("Filmora", "us", "Wondershare"), "animaker": ("Animaker", "us", "Animaker"), "autodesk-maya": ("Autodesk", "us", "Autodesk"), "autodesk-3ds-max": ("Autodesk", "us", "Autodesk"),
    "nvidia-account": ("NVIDIA", "us", "NVIDIA"), "bethesda-net": ("Bethesda", "us", "Bethesda"), "legalzoom": ("LegalZoom", "us", "LegalZoom"), "uspto": ("USPTO", "us", "Patent"),
    "wasabi": ("Wasabi", "us", "Wasabi"), "koofr": ("Koofr", "us", "Koofr"), "play-ht": ("PlayAI", "us", "Play"), "submithub": ("SubmitHub", "us", "SubmitHub"),
}

def main():
    mpath = os.path.join(OUT, "manifest.json"); m = json.load(open(mpath))
    n_alias = 0
    for cid, parent in ALIAS.items():
        if cid in m or parent not in m: continue
        shutil.copyfile(os.path.join(OUT, f"{parent}.png"), os.path.join(OUT, f"{cid}.png"))
        m[cid] = {**m[parent], "file": f"assets/logos/{cid}.png", "source": f"alias:{parent}"}
        n_alias += 1
    print(f"{n_alias} aliases", file=sys.stderr)
    ok, miss = 0, []
    for cid, (term, country, seller) in APPS.items():
        if cid in m: continue
        try:
            d = json.loads(F.http_get(f"https://itunes.apple.com/search?term={urllib.parse.quote(term)}&country={country}&entity=software&limit=8")[0])
            hit = next((r for r in d.get("results", []) if seller.lower() in (r.get("sellerName", "") + " " + r.get("artistName", "")).lower()), None)
            if not hit: miss.append((cid, "no match")); continue
            art = hit.get("artworkUrl512") or hit["artworkUrl100"].replace("100x100", "512x512")
            img = Image.open(io.BytesIO(F.http_get(art)[0])).convert("RGBA").resize((256, 256), Image.LANCZOS)
            mask = Image.new("L", (256, 256), 0); ImageDraw.Draw(mask).rounded_rectangle((0, 0, 255, 255), radius=56, fill=255); img.putalpha(mask)
            img.save(os.path.join(OUT, f"{cid}.png"), optimize=True)
            m[cid] = {"file": f"assets/logos/{cid}.png", "tone": "color", "source": "appstore", "url": art, "app": hit.get("trackName"), "seller": hit.get("sellerName")}
            ok += 1; print(f"ok {cid:28s} {hit.get('trackName')!s:40.40s} by {hit.get('sellerName')}")
            time.sleep(2.5)
        except Exception as e:
            miss.append((cid, str(e)[:60])); time.sleep(3)
    json.dump(dict(sorted(m.items())), open(mpath, "w"), indent=1)
    print(f"{ok} app icons; {len(miss)} missed: {miss}", file=sys.stderr)

if __name__ == "__main__":
    main()
