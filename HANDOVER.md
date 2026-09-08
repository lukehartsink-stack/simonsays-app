# How to update the simonsays.coach app

This is written so anyone can follow it. No coding needed. Claude Code does the work.

## The one idea to understand

The website is the boss. The app copies the website.

- FAQ, study set and product finder live in three small files inside the app.
  A script pulls the newest versions from the website.
- Fun & Games and the quiz are loaded live from the website inside the app.
  Change them on the site and the app shows the change straight away. No app update needed.
- Handbook text, the Lifting Edges tree, the calculators and the About page are typed into the app.
  Ask Claude Code to change them.

## What you need (one time)

1. **The app folder** on your laptop. It is a Git repository. Clone it with:
   `git clone git@github.com:lukehartsink-stack/simonsays-app.git`
   You need to be added as a collaborator on GitHub first.
2. **Node.js** installed (nodejs.org, the LTS button). This runs the sync script.
3. **Claude Code** installed, same as you use for the website.
4. **A Codemagic login** (codemagic.io). Codemagic is the robot that turns the folder into an app and sends it to TestFlight.
   You need to be added to the Codemagic team, or the app moved to your own Codemagic account.
5. **TestFlight** on your phone. You already have this.

## The everyday routine (three steps)

Open a terminal in the app folder and run Claude Code. Then say one of these:

### Step 1. Get the newest content from the website

Say to Claude Code:

> Sync the app content from the website.

Claude runs `node tools/sync-content.js`. It fetches the FAQ, study set and products and tells you what changed.

### Step 2. Change anything else

Say what you want in plain words, for example:

> Add a new handbook section 2.8 called "Edge sealing" with this text: ...
> Change the About page email to ...
> Make the tile on the home screen say "Find a product" in Dutch.

Claude edits the Swift files. You do not need to open them.

### Step 3. Ship it

Say to Claude Code:

> Ship it.

Claude commits the change and pushes it to GitHub. Then:

1. Go to codemagic.io, open **simonsays-app**, press **Start new build**.
2. Branch: **main**. Workflow: **iOS → TestFlight**. Press **Start new build**.
3. Wait about 5 minutes. Open TestFlight on your phone and press **Update**.

A build costs a few cents. Group several changes into one build.

## Rules that keep Apple happy

- Never put "Buy", "Upgrade" or "Subscribe" buttons in the app. Apple takes 30% and may reject it.
  Selling happens on the website. The app only shows what the account is allowed to see.
- Keep the privacy policy page on the website live. Apple links to it.
- Do not change the bundle ID `coach.simonsays.app`.

## When something goes wrong

- **Build fails in Codemagic**: open the failed build, copy the red error text, paste it into Claude Code and say "fix this build error".
- **App shows old content**: run Step 1 again, then Step 3.
- **Fun & Games looks wrong in the app**: the website page changed its layout. Say to Claude Code "the web tools show the site header again" and it will fix the hiding rule.

## Who owns what today

| Thing | Where | Owner |
|---|---|---|
| Code | github.com/lukehartsink-stack/simonsays-app | Luke, Simon to be added |
| Builds | codemagic.io, app "simonsays-app" | Luke's personal account |
| App Store Connect (Apple) | app "simonsays coach", bundle `coach.simonsays.app` | Luke's Apple developer account |
| Website and content | simonsays.coach via FTP | Simon |

To move the app fully to Simon later: Simon opens an Apple Developer account, Luke transfers the app in App Store Connect, and Simon connects his own Codemagic. Everything else stays the same.
