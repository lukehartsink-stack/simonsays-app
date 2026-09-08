# simonsays.coach iOS app — instructions for Claude Code

The person talking to you may be Simon (site owner, not a programmer) or Luke (developer). Explain things in plain words. Do the work; do not ask them to edit Swift.

## What this is

Native SwiftUI companion app for https://simonsays.coach (PPF training). Bundle ID `coach.simonsays.app`. Built and shipped by Codemagic (`codemagic.yaml`, workflow `ios-testflight`) to TestFlight. There is no Mac here, so nothing compiles locally: keep Swift edits small and careful, and check `git diff` before pushing.

## Where content comes from

| Content | Source | How to update |
|---|---|---|
| FAQ, study set, product finder | Website JSON, copied into `SimonSays/Resources/*.json` | `node tools/sync-content.js` |
| Drill deck, checklist bank, diagnoser bank, panel order, quiz bank | Website text files, copied into `SimonSays/Resources/*.txt` (parsed by `Models/GameData.swift`) | `node tools/sync-content.js` |
| Stretch Lab, Heat & Tack Lab, Self-heal Demo, Spot the Defect | Native SwiftUI ports under `SimonSays/Views/Games/` | Edit the Swift |
| Handbook parts, Lifting Edges tree, calculators, About, Quote guide | Typed into Swift views under `SimonSays/Views/` | Edit the Swift |

There are no web views in the app. Everything works offline. Do not add a WKWebView; Apple's guideline 4.2 rejects apps that are a wrapped website. New site content comes in as data (JSON or pipe-separated text) or as a native screen.

## Common requests

- **"Sync the app content"**: run `node tools/sync-content.js`, report which files changed.
- **"Ship it"**: `git add -A`, commit with a short message, `git push origin main`. Then tell the user to open codemagic.io, app "simonsays-app", Start new build, branch main, workflow "iOS → TestFlight". Pushing does not start a build by itself.
- **"Fix this build error"**: the user pastes Codemagic log text. Fix the Swift, push, ask them to rebuild.
- **New handbook section**: edit the `parts` list in `SimonSays/Views/Handbook/HandbookView.swift`.
- **Change contact details or About page**: `SimonSays/Theme.swift` (email, Instagram, site URL) and `SimonSays/Views/More/MoreView.swift`.
- **New drill, checklist item, quiz or diagnoser question**: add it on the website first (the `.js` banks), then run the sync. The app reads the same pipe-separated format: see the comments at the top of each bank on the site.
- **A game looks wrong**: the nine tools live in `SimonSays/Views/Games/`, one file each.

## Design rules

- Colours: Simon Says blue and greys only for icons and tags (`Theme.iconBlue`, `iconDeep`, `iconGrey`, `iconSlate`). Green and red only for right/wrong answers.
- Everything should feel native. No screen should show the website's navigation or footer.
- Brand hero on the home screen uses fixed blues so it stays readable in dark mode.

## Never do this

- No in-app purchase, "Upgrade", "Subscribe" or "Buy" buttons. Apple takes 30% and may reject the app. Selling happens on the website; the app only unlocks by account.
- Do not change the bundle ID or the Codemagic workflow names.
- Do not commit secrets or Apple keys.
