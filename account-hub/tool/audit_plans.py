#!/usr/bin/env python3
"""Consistency audit for assets/catalog/plans.json (no exchange rates used).

Flags, per service:
  tier_order        a tier that is cheaper in USD costs more locally than a
                    dearer tier (same country, store, cycle, currency)
  yearly_vs_monthly a yearly price outside 6x-12.5x its monthly price
  zero_decimal      JPY/KRW/VND amounts with decimals
  ios_vs_web        App Store price below 0.6x or above 1.8x the web price
Regional discounts are real (India, Vietnam, Türkiye...), so a flag is a
prompt to re-read the source, not proof of an error.
Run: python3 tool/audit_plans.py
"""
import collections
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
doc = json.load((ROOT / "assets/catalog/plans.json").open())
ZERO = {"JPY", "KRW", "VND"}
flags = collections.defaultdict(list)

for s in doc["services"]:
    sid = s["platformId"]
    for p in s["plans"]:
        for cc, chans in p["prices"].items():
            for ch, pr in chans.items():
                if pr["currency"] in ZERO and pr["amount"] != int(pr["amount"]):
                    flags["zero_decimal"].append((sid, p["id"], cc, ch, pr["amount"]))
            if "web" in chans and "ios" in chans and chans["web"]["currency"] == chans["ios"]["currency"] and chans["web"]["amount"]:
                k = chans["ios"]["amount"] / chans["web"]["amount"]
                if k < 0.6 or k > 1.8:
                    flags["ios_vs_web"].append((sid, p["id"], cc, chans["web"]["amount"], chans["ios"]["amount"], round(k, 2)))
    countries = {k for p in s["plans"] for k in p["prices"] if k != "default"}
    for cc in countries:
        for ch in ("web", "ios", "android"):
            for cyc in ("monthly", "yearly"):
                rows = []
                for p in s["plans"]:
                    dv = p["prices"].get("default", {}).get("web")
                    lv = p["prices"].get(cc, {}).get(ch)
                    if p["cycle"] == cyc and dv and lv and dv["currency"] == "USD":
                        rows.append((dv["amount"], lv["amount"], lv["currency"], p["id"]))
                rows.sort()
                for a, b in zip(rows, rows[1:]):
                    if a[0] < b[0] and a[2] == b[2] and a[1] > b[1] * 1.02:
                        flags["tier_order"].append((sid, cc, ch, cyc, a[3], a[1], b[3], b[1], a[2]))
    by = collections.defaultdict(dict)
    for p in s["plans"]:
        base = p["name"].lower()
        for w in ("(monthly)", "(yearly)", "(annual)", "annual", "monthly", "yearly"):
            base = base.replace(w, "")
        by[base.strip(" -()")][p["cycle"]] = p
    for base, cy in by.items():
        if "monthly" in cy and "yearly" in cy:
            m, y = cy["monthly"], cy["yearly"]
            for cc in set(m["prices"]) & set(y["prices"]):
                for ch in set(m["prices"][cc]) & set(y["prices"][cc]):
                    pm, py = m["prices"][cc][ch], y["prices"][cc][ch]
                    if pm["currency"] == py["currency"] and pm["amount"]:
                        k = py["amount"] / pm["amount"]
                        if not 6 <= k <= 12.5:
                            flags["yearly_vs_monthly"].append((sid, base, cc, ch, pm["amount"], py["amount"], round(k, 2)))

for name in ("tier_order", "zero_decimal", "yearly_vs_monthly", "ios_vs_web"):
    rows = flags.get(name, [])
    print(f"== {name}: {len(rows)}")
    for r in rows:
        print("  ", r)
