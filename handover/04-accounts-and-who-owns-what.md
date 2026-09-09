# 4. Accounts and who owns what

Five services are involved. Here is what each one does, who holds it today, and what you
need from it.

| Service | What it is for | Held by today | What Simon needs |
|---|---|---|---|
| **GitHub** (your fork of simonsays-app) | Stores the app's files and their history | Simon | Nothing more after chapter 2 |
| **Codemagic** (codemagic.io, app "simonsays-app") | Builds the app in the cloud and uploads it to Apple | Simon's own account | Nothing more after chapter 2 |
| **Apple Developer / App Store Connect** | Apple's side: certificates, the app record, TestFlight, App Store | Luke's Apple developer account | The Apple key, already given. Tester invites, already sent |
| **TestFlight** (app on the phone) | Installs test versions | Apple | Signed in with the same Apple ID the invite went to |
| **Website and hosting** (simonsays.coach, FTP) | The source of truth for content | Simon | Nothing new |

## Details worth knowing

### Apple

- The app record in App Store Connect is called "simonsays.coach", Apple ID 6806799514.
- Two tester records exist for Simon: `nucleondh@gmail.com` (accepted) and
  `training@simonsays.coach` (invite pending). TestFlight on the phone must be signed in with
  whichever of those Apple IDs you use, or the builds will not show up.
- Apple charges the developer account holder $99 a year. Today that is Luke.
- Apple needs a live privacy policy page on the website. Keep it up.

### Codemagic

- The build recipe is the file `codemagic.yaml` in the app folder. It has two workflows:
  **iOS → TestFlight** (the everyday one) and a one-off that registered the bundle ID with
  Apple. You never need the one-off again.
- Codemagic signs the app using an App Store Connect API key stored inside Codemagic under
  the name "AutoBook ASC Admin". That key is not in the folder and must never be put there.
  Luke gives it to you privately once; it belongs to Luke's Apple account.
- Builds start by themselves when a change is pushed to GitHub. Builds are billed per
  minute on your Codemagic account. A normal build takes five to ten minutes.

### GitHub

- The branch that gets built is called `main`. Everything ships from there.
- Nothing secret is in the repository. Keys, passwords and certificates live only in
  Codemagic and Apple.
- Luke's original copy at github.com/lukehartsink-stack/simonsays-app is the starting point
  only. Your fork is where the app lives now.

## Moving the app to Simon's own accounts (optional, later)

Nothing has to move for the workflow to work. If you want the app fully under your name:

1. **Apple:** open your own Apple Developer account ($99 a year). Luke transfers the app to
   it inside App Store Connect. The bundle ID and all TestFlight history come with it.
   You then invite Luke to your team so he can keep helping.
2. **Codemagic:** already yours. Once the app is under your Apple account, make a new
   App Store Connect API key there and replace the "AutoBook ASC Admin" key in Codemagic
   with it, same name.
3. **GitHub:** already yours.

Do these in that order, one at a time, with a working build in between.
