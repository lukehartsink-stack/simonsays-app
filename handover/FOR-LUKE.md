# For Luke: what you do on your side

This file is not joined into the all-in-one document. It is your checklist while Simon works
through chapter 2.

## When Simon sends his GitHub username (his step 2)

1. github.com/lukehartsink-stack/simonsays-app, Settings, Collaborators, Add people.
2. Enter his username, role Write. Tell him "done".

## Before Simon's step 11 (Codemagic)

Send him the App Store Connect API key privately (WhatsApp, not email, never the repo):

- The `.p8` file for the key currently named "AutoBook ASC Admin" in your Codemagic team.
- Its Issuer ID and Key ID. Both are on App Store Connect, Users and Access, Integrations,
  App Store Connect API.

If you cannot find the `.p8` (Apple lets you download it once), make a new key there with
role Admin, download it, and give Simon that one. The name in Codemagic stays
"AutoBook ASC Admin" so `codemagic.yaml` does not change.

Simon's Codemagic team will create its own distribution certificate with that key the first
time it builds. Apple allows three, so yours keeps working too.

## Why pushes did not start builds before

`codemagic.yaml` already has a push trigger on `main`. It only fires if Codemagic has a
webhook on the GitHub repository. Adding the app through the Codemagic GitHub integration
(Simon's step 11) creates that webhook. If builds still do not start by themselves, check
codemagic.io, the app, Settings, Webhooks, and paste the webhook URL into the GitHub repo
under Settings, Webhooks.

Once Simon's Codemagic is building, decide whether to remove the app from your own Codemagic
team so a push does not trigger two builds.

## When Simon sends his phone's Apple ID (his step 12)

App Store Connect, Users and Access, or TestFlight, Internal testers. Make sure that exact
email is in the "Internal testers" group. If it is neither `nucleondh@gmail.com` nor
`training@simonsays.coach`, add it as a new tester.

## Later

- Accept the "Program License Agreement updated" banner in App Store Connect.
- When the first public release is ready, walk Simon through Submit for review once.
