#!/usr/bin/env python3
"""Add country prices from research files into assets/catalog/plans.json.

Usage: python3 tool/patch_plans.py <patch1.json> [<patch2.json> ...]

A patch file has the same {"services": [...]} shape as plans.json. Prices are
added per (platformId, planId, country, channel); an existing price is
replaced only when the patch's verifiedAt is the same day or newer. Plans
whose id is unknown are appended as new plans. Services whose platformId is
unknown are reported and skipped. The same validation as merge_plans.py
applies (markets, currencies, numeric amounts, source URLs).
"""
import datetime as dt
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from merge_plans import CHANNELS, CYCLES, OUT, PLATFORMS, ZERO_DECIMAL, known_markets  # noqa: E402


def main(paths):
    platform_ids = {p["id"] for p in json.load(PLATFORMS.open())["platforms"]}
    markets = known_markets()
    doc = json.load(OUT.open())
    by_service = {s["platformId"]: s for s in doc["services"]}
    problems, added, replaced, new_plans = [], 0, 0, 0
    for path in paths:
        patch = json.load(open(path))
        for s in patch.get("services", []):
            pid = s.get("platformId")
            if pid not in platform_ids:
                problems.append(f"{path}: unknown platformId {pid!r} (skipped)")
                continue
            target = by_service.get(pid)
            if target is None:
                target = {"platformId": pid, "name": s.get("name") or pid, "plans": []}
                if s.get("pricingUrl"):
                    target["pricingUrl"] = s["pricingUrl"]
                doc["services"].append(target)
                by_service[pid] = target
            if s.get("notes") and s["notes"] not in (target.get("notes") or ""):
                target["notes"] = ((target.get("notes") or "") + " " + s["notes"]).strip()
            plans_by_id = {p["id"]: p for p in target["plans"]}
            for p in s.get("plans", []):
                plan_id = p.get("id")
                if not plan_id:
                    problems.append(f"{pid}: plan without id (skipped)")
                    continue
                cycle = p.get("cycle", "monthly")
                if cycle not in CYCLES:
                    problems.append(f"{pid}/{plan_id}: bad cycle {cycle!r} (skipped)")
                    continue
                target_plan = plans_by_id.get(plan_id)
                if target_plan is None:
                    if not p.get("name"):
                        problems.append(f"{pid}/{plan_id}: new plan without name (skipped)")
                        continue
                    target_plan = {"id": plan_id, "name": p["name"], "cycle": cycle, "prices": {}}
                    plans_by_id[plan_id] = target_plan
                    target["plans"].append(target_plan)
                    new_plans += 1
                elif target_plan["cycle"] != cycle:
                    problems.append(f"{pid}/{plan_id}: cycle {cycle} differs from existing {target_plan['cycle']} (prices still added)")
                for country, by_channel in (p.get("prices") or {}).items():
                    key = "default" if country == "default" else country.upper()
                    if key != "default" and key not in markets:
                        problems.append(f"{pid}/{plan_id}: country {country!r} not in app markets (dropped)")
                        continue
                    for ch, price in (by_channel or {}).items():
                        if ch not in CHANNELS:
                            problems.append(f"{pid}/{plan_id}/{key}: bad channel {ch!r} (dropped)")
                            continue
                        amt, cur = price.get("amount"), (price.get("currency") or "").upper()
                        if not isinstance(amt, (int, float)) or isinstance(amt, bool) or amt < 0:
                            problems.append(f"{pid}/{plan_id}/{key}/{ch}: bad amount {amt!r} (dropped)")
                            continue
                        if key != "default" and cur not in (markets[key], "USD", "EUR"):
                            problems.append(f"{pid}/{plan_id}/{key}/{ch}: currency {cur} is not {markets[key]} (dropped)")
                            continue
                        if not str(price.get("source", "")).startswith("http"):
                            problems.append(f"{pid}/{plan_id}/{key}/{ch}: no source URL (dropped)")
                            continue
                        if cur in ZERO_DECIMAL:
                            amt = int(round(amt))
                        entry = {"amount": amt, "currency": cur, "source": price["source"], "verifiedAt": price.get("verifiedAt") or dt.date.today().isoformat()}
                        slot = target_plan["prices"].setdefault(key, {})
                        old = slot.get(ch)
                        if old is None:
                            added += 1
                        elif old.get("verifiedAt", "") <= entry["verifiedAt"]:
                            replaced += 1
                        else:
                            problems.append(f"{pid}/{plan_id}/{key}/{ch}: existing price is newer, kept")
                            continue
                        slot[ch] = entry
            # drop plans that ended up with no prices
            target["plans"] = [pl for pl in target["plans"] if pl["prices"]]
    doc["services"].sort(key=lambda s: s["platformId"])
    doc["version"] = int(doc.get("version", 0)) + 1
    doc["generatedAt"] = dt.date.today().isoformat()
    OUT.write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n")
    print(f"wrote {OUT} v{doc['version']}: {len(doc['services'])} services, {sum(len(s['plans']) for s in doc['services'])} plans; +{added} prices, {replaced} replaced, {new_plans} new plans")
    for p in problems:
        print("WARN", p)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1:])
