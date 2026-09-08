# simonsays.coach — iOS app

A native SwiftUI companion app for [simonsays.coach](https://simonsays.coach/), the independent PPF training and support platform.

## What's in it

| Tab | Screens |
|-----|---------|
| **Home** | Hero, quick links, who it's for, independence promise |
| **Support** | PPF Installation FAQ (100 Q&As, search + audience/topic filters) · PPF Guide for Car Owners · Detailing Product Finder (332 products across 7 ranges, universal full-text search + per-range category filters) |
| **Handbook** | The six parts, both editions with pre-filled email enquiries, links to the free previews |
| **Tools** | PPF Coverage Calculator (full port of the nesting engine) · Hourly Rate Calculator (four-layer model) · Handbook Study Set (88-question quiz with results and handouts to revisit) · Fun & Games (nine native drills, labs and games) · Quote Calculator info |
| **More** | Lifting Edges decision tree (interactive Yes/No diagnosis + reference tables) · Quote Calculator user guide · PPF Shopping List · About · Contact |

All content is bundled in `SimonSays/Resources/` (JSON for FAQ, study set and products; pipe-separated text for the game banks), so the whole app works offline. There are no web views.

## Building

Requires **Xcode 16** or later (the project uses a file-system-synchronised group, so new files dropped into `SimonSays/` are picked up automatically) and an **iOS 17** deployment target.

1. Open `SimonSays.xcodeproj`.
2. Select the `SimonSays` scheme and a simulator or device.
3. Set your Team under *Signing & Capabilities* if running on a device.
4. Run.

If you'd rather regenerate the project file, a `project.yml` for [XcodeGen](https://github.com/yonaskolb/XcodeGen) is included: `xcodegen generate`.

## Updating the content

Run `node tools/sync-content.js` to refresh every bank from the live site. Sources:

- `faqs.json` ← `https://simonsays.coach/support/faq/faqs.js` (`window.FAQ_DATA`)
- `studyset.json` ← `https://simonsays.coach/training-tools/handbook-study-set/questions.js` (`window.STUDY_SET`)
- `products.json` ← `const BRANDS` inline in `https://simonsays.coach/support/detailing-product-finder/universal/`

- `drills.txt`, `checklist.txt`, `diagnoser.txt`, `panels.txt`, `quiz.txt` ← the `.js` banks under `https://simonsays.coach/training-tools/fun-and-games/*/`

## App icon

`Assets.xcassets/AppIcon.appiconset` is set up for a single 1024×1024 image — drop the site's mark in there before shipping.
