# For Luke: two things to do before Simon starts, then you are out

Not part of Simon's all-in-one file.

## 1. Make the repository public (one click)

Simon's setup forks the repo, which only works if it is public. There are no secrets in it.

github.com/lukehartsink-stack/simonsays-app, Settings, scroll to Danger Zone, Change
visibility, Make public.

## 2. Send Simon the Apple key on WhatsApp

Three things: the `.p8` file for the App Store Connect API key, its Issuer ID, and its
Key ID. Issuer ID and Key ID are on App Store Connect, Users and Access, Integrations,
App Store Connect API.

Apple only lets you download a `.p8` once. If you no longer have it, make a new key there
with role Admin, download it, and send that one instead. Simon names it "Simon Says App"
in his Codemagic, so `codemagic.yaml` never changes.

That is everything. Simon's fork, his Codemagic and his phone are handled in his chapter 2
without you.

## Optional, later

- Once Simon's Codemagic is building, remove the app from your own Codemagic team so you are
  not billed for builds you no longer need.
- Accept the "Program License Agreement updated" banner in App Store Connect when it appears.
- If Simon ever moves the app to his own Apple account, transfer it in App Store Connect.
