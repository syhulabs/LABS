#!/usr/bin/env python3
"""Print a Markdown coverage table for assets/catalog/plans.json.

Cells: w = web price, i = App Store price, a = Google Play price, - = none.
"""
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
doc = json.load((ROOT / "assets/catalog/plans.json").open())
countries = sorted({k for s in doc["services"] for p in s["plans"] for k in p["prices"] if k != "default"})
print(f"Plans as of {doc['generatedAt']} (v{doc['version']}): {len(doc['services'])} services, "
      f"{sum(len(s['plans']) for s in doc['services'])} plans.\n")
print("| service | plans | " + " | ".join(countries) + " |")
print("|---|---|" + "---|" * len(countries))
for s in doc["services"]:
    cells = []
    for c in countries:
        ch = set()
        for p in s["plans"]:
            ch |= set(p["prices"].get(c, {}))
        cells.append("".join(x for x in "wia" if {"w": "web", "i": "ios", "a": "android"}[x] in ch) or "-")
    print(f"| {s['platformId']} | {len(s['plans'])} | " + " | ".join(cells) + " |")
