#!/usr/bin/env python3
"""Merge researched plan files into assets/catalog/plans.json.

Usage: python3 tool/merge_plans.py <group1.json> [<group2.json> ...]

Each input has the shape {"services": [...]} documented in docs/PLANS.md.
The script validates ids against assets/catalog/platforms.json, checks the
price shape, keeps only countries the app knows, and writes a sorted,
versioned document. It never invents data: anything malformed is reported
and dropped, not patched.
"""
import datetime as dt
import json
import math
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
PLATFORMS = ROOT / "assets/catalog/platforms.json"
OUT = ROOT / "assets/catalog/plans.json"
MARKETS_DART = ROOT / "lib/domain/markets.dart"
CYCLES = {"weekly", "monthly", "quarterly", "halfYearly", "yearly", "oneTime"}
CHANNELS = {"web", "ios", "android"}
ZERO_DECIMAL = {"JPY", "KRW", "VND"}


def check_price(price, key, markets):
    """Validate one price entry. Returns (entry, None) or (None, reason).

    Shared by merge_plans.py and patch_plans.py so both apply the same rules
    as the app's loader (which rejects the whole file on one bad entry).
    """
    if not isinstance(price, dict):
        return None, "price is not an object"
    amt, cur = price.get("amount"), str(price.get("currency") or "").upper()
    if not isinstance(amt, (int, float)) or isinstance(amt, bool) or not math.isfinite(amt) or amt < 0:
        return None, f"bad amount {amt!r}"
    if len(cur) != 3 or not cur.isalpha():
        return None, f"bad currency {cur!r}"
    if key != "default" and cur not in (markets[key], "USD", "EUR"):
        return None, f"currency {cur} is not {markets[key]}"
    source = str(price.get("source") or "")
    if not source.startswith(("http", "observed:")):
        return None, "no source URL"
    if cur in ZERO_DECIMAL:
        amt = int(round(amt))
    return {"amount": amt, "currency": cur, "source": source, "verifiedAt": price.get("verifiedAt") or dt.date.today().isoformat()}, None


def write_doc(doc):
    """Write plans.json; refuses NaN/Infinity so the output is valid JSON."""
    OUT.write_text(json.dumps(doc, ensure_ascii=False, indent=1, allow_nan=False) + "\n")


def known_markets():
    out = {}
    for m in re.finditer(r"Market\('([A-Z]{2})', '[^']+', '([A-Z]{3})'", MARKETS_DART.read_text()):
        out[m.group(1)] = m.group(2)
    return out


def main(paths):
    platform_ids = {p["id"] for p in json.load(PLATFORMS.open())["platforms"]}
    markets = known_markets()
    problems = []
    services = {}
    for path in paths:
        doc = json.load(open(path))
        for s in doc.get("services", []):
            pid = s.get("platformId")
            if pid not in platform_ids:
                problems.append(f"{path}: unknown platformId {pid!r} (skipped)")
                continue
            plans = []
            seen = set()
            for p in s.get("plans", []):
                pid2 = p.get("id")
                if not pid2 or pid2 in seen:
                    problems.append(f"{pid}: missing/duplicate plan id {pid2!r} (skipped)")
                    continue
                seen.add(pid2)
                if p.get("cycle", "monthly") not in CYCLES:
                    problems.append(f"{pid}/{pid2}: bad cycle {p.get('cycle')!r} (skipped)")
                    continue
                prices = {}
                for country, by_channel in (p.get("prices") or {}).items():
                    key = "default" if country == "default" else country.upper()
                    if key != "default" and key not in markets:
                        problems.append(f"{pid}/{pid2}: country {country!r} not in app markets (dropped)")
                        continue
                    kept = {}
                    for ch, price in (by_channel or {}).items():
                        if ch not in CHANNELS:
                            problems.append(f"{pid}/{pid2}/{key}: bad channel {ch!r} (dropped)")
                            continue
                        entry, why = check_price(price, key, markets)
                        if why:
                            problems.append(f"{pid}/{pid2}/{key}/{ch}: {why} (dropped)")
                            continue
                        kept[ch] = entry
                    if kept:
                        prices[key] = kept
                if not prices:
                    problems.append(f"{pid}/{pid2}: no valid prices (skipped)")
                    continue
                if "default" not in prices:
                    problems.append(f"note {pid}/{pid2}: country-only plan ({', '.join(sorted(prices))}); hidden elsewhere")
                name = str(p.get("name") or "").strip()
                if not name:
                    problems.append(f"{pid}/{pid2}: plan without name (skipped)")
                    continue
                plans.append({"id": pid2, "name": name, "cycle": p.get("cycle", "monthly"), "prices": prices})
            if not plans:
                problems.append(f"{pid}: no valid plans (skipped)")
                continue
            entry = {"platformId": pid, "name": s.get("name") or pid, "plans": plans}
            if s.get("pricingUrl"):
                entry["pricingUrl"] = s["pricingUrl"]
            if s.get("notes"):
                entry["notes"] = s["notes"]
            services[pid] = entry
    previous = json.load(OUT.open()) if OUT.exists() else {"version": 0}
    dropped = sorted({x["platformId"] for x in previous.get("services", [])} - set(services))
    if dropped:
        problems.append(f"merge rebuilds the whole file: {len(dropped)} existing services are not in the inputs and will be removed: {', '.join(dropped)}. Use tool/patch_plans.py to add to the file instead.")
    out = {
        "version": int(previous.get("version", 0)) + 1,
        "generatedAt": dt.date.today().isoformat(),
        "services": [services[k] for k in sorted(services)],
    }
    write_doc(out)
    countries = {}
    for s in out["services"]:
        for p in s["plans"]:
            for k in p["prices"]:
                countries[k] = countries.get(k, 0) + 1
    print(f"wrote {OUT} v{out['version']}: {len(out['services'])} services, {sum(len(s['plans']) for s in out['services'])} plans")
    print("price points per country:", dict(sorted(countries.items())))
    for p in problems:
        print("WARN", p)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1:])
