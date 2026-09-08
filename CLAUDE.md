# simonsays.coach iOS app — instructions for Claude Code

The person talking to you may be Simon (site owner, not a programmer) or Luke (developer). Explain things in plain words. Do the work; do not ask them to edit Swift.

## What this is

Native SwiftUI companion app for https://simonsays.coach (PPF training). Bundle ID `coach.simonsays.app`. Built and shipped by Codemagic (`codemagic.yaml`, workflow `ios-testflight`) to TestFlight. There is no Mac here, so nothing compiles locally: keep Swift edits small and careful, and check `git diff` before pushing.

## Where content comes from

| Content | Source | How to update |
|---|---|---|
| FAQ, study set, product finder | Website JSON, copied into `SimonSays/Resources/*.json` | `node tools/sync-content.js` |
| Fun & Games, knowledge quiz | Loaded live from the site in a web view (`Theme.toolsBase`) | Nothing, changes on the site show immediately |
| Handbook parts, Lifting Edges tree, calculators, About, Quote guide | Typed into Swift views under `SimonSays/Views/` | Edit the Swift |

## Common requests

- **"Sync the app content"**: run `node tools/sync-content.js`, report which files changed.
- **"Ship it"**: `git add -A`, commit with a short message, `git push origin main`. Then tell the user to open codemagic.io, app "simonsays-app", Start new build, branch main, workflow "iOS → TestFlight". Pushing does not start a build by itself.
- **"Fix this build error"**: the user pastes Codemagic log text. Fix the Swift, push, ask them to rebuild.
- **New handbook section**: edit the `parts` list in `SimonSays/Views/Handbook/HandbookView.swift`.
- **Change contact details or About page**: `SimonSays/Theme.swift` (email, Instagram, site URL) and `SimonSays/Views/More/MoreView.swift`.
- **Web tools show the site header again**: adjust the CSS selectors in `SimonSays/Views/Shared/WebView.swift`. When Simon publishes header-less pages under `/app/`, change `Theme.toolsBase` in `Theme.swift`.

## Design rules

- Colours: Simon Says blue and greys only for icons and tags (`Theme.iconBlue`, `iconDeep`, `iconGrey`, `iconSlate`). Green and red only for right/wrong answers.
- Everything should feel native. No screen should show the website's navigation or footer.
- Brand hero on the home screen uses fixed blues so it stays readable in dark mode.

## Never do this

- No in-app purchase, "Upgrade", "Subscribe" or "Buy" buttons. Apple takes 30% and may reject the app. Selling happens on the website; the app only unlocks by account.
- Do not change the bundle ID or the Codemagic workflow names.
- Do not commit secrets or Apple keys.
