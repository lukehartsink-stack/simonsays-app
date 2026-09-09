# 5. Rules that keep Apple happy and the app on brand

Claude Code already knows these from `CLAUDE.md`. They are here so you know why it may
push back on a request.

## Apple rules

- **Never sell inside the app.** No "Buy", "Upgrade", "Subscribe" or "Unlock" buttons, and
  no prices for the handbook or calculator. Apple takes 30% of anything sold in the app and
  may reject the app for pointing people to the website to pay. The app only unlocks by
  account: someone buys on the website, logs in, and the app shows what their account
  allows.
- **No web views.** The app must not open pages from simonsays.coach inside itself. Apple
  guideline 4.2 rejects apps that are a wrapped website. New website content comes into the
  app as data (the sync) or as a native screen built by Claude.
- **Keep the privacy policy page live** on the website. App Store Connect links to it.
- **Never change the bundle ID** `coach.simonsays.app`. It is the app's identity with Apple.
- **Never change the workflow names** in `codemagic.yaml`.
- **No secrets in the folder.** No Apple keys, no passwords, no certificates.

## Design rules

- Icons and tags use Simon Says blue and greys only. No rainbow icons.
- Green and red are reserved for right and wrong answers in the quizzes and games.
- Every screen should feel native. No screen shows the website's header, menu or footer.
- The brand hero on the home screen uses fixed blues so it stays readable in dark mode.
- The app supports light and dark mode. Anything new must look right in both.

## Content rules

- The website is the source of truth for FAQ, study set, products and the game banks. Edit
  those on the website, never directly in the app's copies. The next sync would overwrite
  them.
- Handbook sections are numbered (2.7, 6.5 and so on). When a section changes, the app's
  handbook part list may need its description updated too.
- Batch changes. One build per batch of edits, not one build per edit.
