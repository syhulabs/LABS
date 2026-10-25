# Plan prices by country and store

The subscription form and every platform page can quote a service's published
plans for **your country** and **the store you buy through** (web, App Store,
Google Play). Prices differ by both: the same YouTube Premium plan costs more
through Apple than on the web, and a service with no local price list bills in
USD.

Nothing is fetched live. Prices come from `assets/catalog/plans.json`, a file
of published list prices with a source URL and verification date on every
number. You can replace or extend it from Settings → Platform catalog → *Import
plan prices (JSON)…*.

## How a price is chosen

Settings → Profile holds the **Country** (one of the 29 supported markets) and
the **store you usually subscribe through**. Each subscription can still choose
its own store. For a plan the app looks up, in order:

1. the exact country + store price,
2. the same country's web price (or another store's price) when the chosen
   store has none, marked *"Web price shown"*,
3. the service's `default` price (normally USD), marked *"default USD"*.

Fallbacks are always labelled in the UI; the app never silently converts
currencies or guesses a local price.

## File format

```json
{
  "version": 2,
  "generatedAt": "2026-10-25",
  "services": [
    {
      "platformId": "spotify",
      "name": "Spotify",
      "pricingUrl": "https://www.spotify.com/premium/",
      "notes": "optional free text shown under the plan list",
      "plans": [
        {
          "id": "premium-individual",
          "name": "Premium Individual",
          "cycle": "monthly",
          "prices": {
            "default": {"web": {"amount": 11.99, "currency": "USD", "source": "https://…", "verifiedAt": "2026-10-25"}},
            "IN": {
              "web": {"amount": 119, "currency": "INR", "source": "https://…", "verifiedAt": "2026-10-25"},
              "ios": {"amount": 129, "currency": "INR", "source": "https://apps.apple.com/in/…", "verifiedAt": "2026-10-25"}
            }
          }
        }
      ]
    }
  ]
}
```

* `platformId` must match an id in `assets/catalog/platforms.json`.
* `cycle` is one of `weekly | monthly | quarterly | halfYearly | yearly | oneTime`.
  A yearly plan carries the full yearly amount.
* Country keys are ISO-3166 alpha-2 codes from the supported market list
  (`lib/domain/markets.dart`), plus `default`. Every plan needs a `default`
  price. A country price must be in that country's currency.
* Channels are `web`, `ios`, `android`. Omit a channel rather than guess it.
* `amount` is a number in major units (JPY/KRW/VND have no decimals).

Imports are validated before anything is stored: duplicate ids, unknown cycles
or channels, missing default prices and non-numeric amounts are rejected with
the reason. An imported file overrides bundled services by `platformId` and is
kept in the local database until *Use bundled prices only* is pressed.

## Updating the bundled file

Researched price files (one per service group, same `services` shape) are
merged with:

```sh
python3 tool/merge_plans.py research/ai.json research/media.json …
```

The script drops anything that fails validation and prints a warning per
dropped item, bumps `version`, sets `generatedAt` to today and writes a sorted
`assets/catalog/plans.json`. Run `flutter clean` before the next build so the
asset bundle picks up the new file, then `flutter test` (the plan catalog test
re-validates the bundled file against the platform catalog and market list).

## Coverage

See the "Plan prices" chips in Settings → Platform catalog for the number of
services and the as-of date of the bundled data. Markets without a price list
for a service fall back to that service's default price and say so.
