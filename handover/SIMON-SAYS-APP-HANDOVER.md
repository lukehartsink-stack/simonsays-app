# simonsays.coach iPhone app — complete handover

Built 2026-09-09 from the chapters in the app folder's handover/ directory.
This one file is meant to be uploaded to a Claude project as knowledge, so that Claude
understands the app, where its content comes from, how it is built and shipped, and what
it must never do. The same information lives in CLAUDE.md for Claude Code in the terminal.

---
# 1. What the app is

The app is a native iPhone and iPad companion to simonsays.coach. It is written in Swift with
SwiftUI, Apple's own toolkit. Nothing in it loads a web page. Everything works offline.

- Bundle ID (Apple's permanent name for the app): `coach.simonsays.app`
- Display name on the phone: **simonsays.coach**
- Minimum iOS version: 17
- Code lives at: https://github.com/lukehartsink-stack/simonsays-app

## The one idea to understand

**The website is the boss. The app copies the website.**

Most of the content in the app is a copy of files that already live on simonsays.coach.
You keep editing the website exactly as you do now. A small script copies the newest versions
into the app. Then Codemagic builds the app and sends it to TestFlight.

## What is in the app

| Tab | Screens |
|---|---|
| **Home** | Search box, brand hero, quick links to the most used screens |
| **Support** | PPF Installation FAQ (100 questions, search and filters), PPF Guide for Car Owners, Detailing Product Finder (332 products in 7 ranges) |
| **Handbook** | The six handbook parts, both editions, email enquiry buttons, links to the free previews |
| **Tools** | PPF Coverage Calculator, Hourly Rate Calculator, Handbook Study Set (88-question quiz), Fun & Games (nine tools), Quote Calculator info |
| **More** | Lifting Edges decision tree, Quote Calculator user guide, PPF Shopping List, About the author, Contact, Profile and progress |

The nine Fun & Games tools are: Daily Drill Draw, Pre-flight Checklist, Defect Diagnoser,
Panel Sequence Puzzle, PPF Knowledge Quiz, Stretch Lab, Heat & Tack Lab, Self-heal Demo and
Spot the Defect. All nine are built natively. None of them open the website.

## Where each piece of content comes from

There are three kinds of content. Knowing which kind you are changing tells you what to do.

### Kind A: copied from the website by the sync script

You edit these on the website as normal. Then run the sync (chapter 3). Nothing else to do.

| Content in the app | File on the website it is copied from |
|---|---|
| FAQ | `/support/faq/faqs.js` |
| Handbook Study Set questions | `/training-tools/handbook-study-set/questions.js` |
| Product Finder (all brands and products) | the `const BRANDS` list inside `/support/detailing-product-finder/universal/` |
| Daily Drill Draw deck | `/training-tools/fun-and-games/daily-drill-draw/deck.js` |
| Pre-flight Checklist | `/training-tools/fun-and-games/pre-flight-checklist/checklist.js` |
| Defect Diagnoser questions | `/training-tools/fun-and-games/defect-diagnoser/questions.js` |
| Panel Sequence order | `/training-tools/fun-and-games/panel-sequence-puzzle/panels.js` |
| PPF Knowledge Quiz questions | `/training-tools/fun-and-games/ppf-knowledge-quiz/questions.js` |

The copies land in the folder `SimonSays/Resources/`. The FAQ, study set and products are
JSON. The five game banks are plain text, one entry per line, fields separated by ` | `.
The format is explained in the comment at the top of each `.js` file on the website, and the
app reads the exact same format. If you add a line on the website in the right format, it
works in the app.

### Kind B: typed into the app by hand (ask Claude Code)

These are not on the website in a form the app can copy, so they were written directly into
the app. To change them, say what you want to Claude Code in plain words. It edits the Swift.

- Handbook parts list and descriptions
- Lifting Edges decision tree
- PPF Coverage Calculator and Hourly Rate Calculator
- Quote Calculator user guide
- PPF Shopping List
- About the author, contact email, Instagram link
- Car Owner guide text
- Home screen wording and tiles

### Kind C: the four labs (native rebuilds of the website versions)

Stretch Lab, Heat & Tack Lab, Self-heal Demo and Spot the Defect are interactive. They were
rebuilt in Swift to behave like the website versions. If you change one on the website, tell
Claude Code what changed and it will mirror it in the app. They do not sync automatically.

## Languages

The app is English only for now. Dutch and German versions of the website are still in
progress. When they are ready, the app can be translated. That is a separate job.

## What the app does not do

- No web views. Apple rejects apps that are just a wrapped website (guideline 4.2).
- No buying, subscribing or upgrading inside the app. See chapter 5.
- No live loading of content. Everything is bundled, so a content change needs a new build.

---

# 2. Set up your computer (one time, Windows)

Do the steps in order. Each step ends with what you should see, so you know it worked.
About one hour, mostly waiting for downloads. You need your laptop, your phone, your Claude
login, and the Apple key Luke sent you on WhatsApp (a small file ending in `.p8` plus two
codes). Save those three things somewhere safe on your laptop before you start.

---

## Step 1. Install Git

1. Go to **https://git-scm.com/download/win**
2. Click **Click here to download**. Open the downloaded file.
3. Click **Next** on every page. Then **Install**, then **Finish**.

You should see: the installer closes. Nothing else opens.

---

## Step 2. Make a GitHub account

1. Go to **https://github.com** and click **Sign up**.
2. Use your email, choose a password and a username. Confirm the email GitHub sends you.

You should see: your username in the top right corner of the GitHub page.

---

## Step 3. Take your own copy of the app (called a "fork")

1. Go to **https://github.com/lukehartsink-stack/simonsays-app**
2. Click the **Fork** button near the top right.
3. Click the green **Create fork** button.

You should see: a page called **your-username/simonsays-app**. This copy is yours. Nobody
else can change it. Everything from now on uses your copy.

---

## Step 4. Install GitHub Desktop and get the folder onto your laptop

1. Go to **https://desktop.github.com** and click **Download for Windows**. Open the file.
2. GitHub Desktop opens. Click **Sign in to GitHub.com**. Your browser opens. Sign in,
   click **Authorize**. Back in GitHub Desktop, click **Finish**.
3. Click **File**, then **Clone repository**.
4. Click the **GitHub.com** tab. Click **your-username/simonsays-app** (your copy from
   Step 3, not the lukehartsink one).
5. Look at **Local path**. That is where the folder will go. Remember it. It is usually
   `C:\Users\<you>\Documents\GitHub\simonsays-app`.
6. Click **Clone**.
7. If it asks "How are you planning to use this fork?", choose **For my own purposes**.

You should see: GitHub Desktop says **simonsays-app** at the top. The folder exists on your
laptop.

---

## Step 5. Install Node

1. Go to **https://nodejs.org** and click the big green **LTS** button. Open the file.
2. Click **Next** on every page, tick the licence box, click **Install**, then **Finish**.

You should see: the installer closes.

---

## Step 6. Install Visual Studio Code

1. Go to **https://code.visualstudio.com** and click **Download for Windows**. Open the file.
2. Click **Next** on every page. Tick **Create a desktop icon**. Click **Install**, then
   **Finish**.

You should see: a dark window with File, Edit, Selection in the top menu.

---

## Step 7. Open the app folder in VS Code

1. Click **File**, then **Open Folder...**
2. Find the `simonsays-app` folder from Step 4. Click it once. Click **Select Folder**.
3. If it asks "Do you trust the authors?", click **Yes, I trust the authors**.

You should see: a list on the left with `CLAUDE.md`, `handover`, `SimonSays`, `tools`.
VS Code remembers this folder and opens it next time by itself.

---

## Step 8. Install Claude Code

1. Click **View**, then **Terminal**. A black box appears at the bottom. You type in there.
2. Click in the black box. Paste this line and press **Enter**:

   ```
   irm https://claude.ai/install.ps1 | iex
   ```

3. Wait until the text stops and says it is installed.
4. Close VS Code completely. Open it again from the desktop icon.

You should see: the same folder list on the left.

---

## Step 9. Start Claude and log in

1. Click **View**, then **Terminal**.
2. Type `claude` and press **Enter**.
3. First time only: press **Enter** to accept the theme. Choose **Claude account with
   subscription**. Your browser opens. Log in with your normal Claude login. Click
   **Authorize**. Go back to VS Code.
4. Type this and press **Enter**:

   > Explain what this app is and how I update it.

You should see: Claude answers in plain words and mentions sync, change, ship. It has read
the instructions in the folder.

To stop Claude: type `/exit` and press **Enter**. To start again: type `claude`.

---

## Step 10. Check the sync

1. If Claude is running, type `/exit`. Then type this and press **Enter**:

   ```
   node tools/sync-content.js
   ```

You should see: eight lines ending in "no change" or "updated", then "Everything already up
to date" or "N file(s) updated". Either is fine.

---

## Step 11. Connect Codemagic (the robot that builds the app)

**Add the app**

1. Go to **https://codemagic.io** and log in.
2. Click **Add application**. Choose **GitHub**. If it asks to connect GitHub, click
   **Connect** and authorize. Use the account from Step 2.
3. Pick **simonsays-app** (your copy). If it is not listed, click the link to install the
   Codemagic GitHub app, tick **simonsays-app**, and come back.
4. Project type: **iOS App**. Click **Finish**.

You should see: **simonsays-app** on your Codemagic dashboard.

**Add the Apple key** (the `.p8` file and two codes from Luke)

1. Click **Teams** in the left menu, then your team.
2. Click **Integrations**. Next to **Developer Portal** click **Manage keys** (or
   **Connect**).
3. Click **Add key** and fill in:
   - Name: `AutoBook ASC Admin` (type it exactly like this)
   - Issuer ID: the first code
   - Key ID: the second code
   - API key: click **Upload** and pick the `.p8` file
4. Click **Save**.

You should see: "AutoBook ASC Admin" in the list.

**Run one test build**

1. On the dashboard click **simonsays-app**, then **Start new build**.
2. Branch: **main**. Workflow: **iOS → TestFlight**. Click **Start new build**.
3. Wait five to ten minutes.

You should see: every step green, and "Publishing" says the build went to App Store Connect.
If a step is red, click it, copy the red text, and paste it into Claude in VS Code with the
words "fix this build error". Then start a new build. That is the normal way to fix builds.

From now on, every time you ship a change (chapter 3), Codemagic starts a build by itself.

---

## Step 12. Get the app on your phone

Two of your emails are invited as testers: `nucleondh@gmail.com` (already accepted) and
`training@simonsays.coach` (invite sent, waiting for you to accept).

1. On your iPhone open **Settings** and tap your name at the top. The email under your name
   is your Apple ID.
2. If it is `nucleondh@gmail.com`: open the **TestFlight** app. The app is there.
3. If it is `training@simonsays.coach`: find the email from TestFlight in that inbox and tap
   **View in TestFlight**. Then open the TestFlight app.
4. If it is a different email: sign out of the App Store (Settings, your name, Media &
   Purchases, Sign Out) and sign in with `nucleondh@gmail.com`, then open TestFlight.

You should see: **simonsays.coach** in TestFlight with an **Install** or **Update** button.

---

## Done

From now on the only things you do are in chapter 3: open VS Code, type `claude`, and say
what you want.

---

# 3. The everyday workflow

Three steps, every time. Open VS Code, open the terminal, type `claude`. Then:

## Step 1. Pull in the newest website content

Say to Claude Code:

> Sync the app content from the website.

Claude runs the sync script. It fetches the FAQ, study set, products and the five game banks
and tells you which files changed. If everything says "no change", the app already matches
the website.

You can also run it yourself without Claude:

```
node tools/sync-content.js
```

## Step 2. Change anything else

Say what you want in plain words. Examples:

> Add a new handbook section 2.8 called "Edge sealing". Here is the text: ...

> Change the contact email on the About page to hello@simonsays.coach.

> The Stretch Lab on the website now has a fourth film type. Mirror it in the app.

> Rename the home screen tile "Product finder" to "Find a product".

Claude edits the Swift files. You do not need to open them. Before it finishes it will show
you what it changed. Read the summary and say if it is not what you meant.

If a change touches Swift, Claude cannot test it on this computer. There is no Mac here, so
nothing compiles locally. Codemagic does the compiling in step 3. That is why Claude keeps
Swift edits small and careful. If Codemagic reports an error, chapter 6 covers it.

## Step 3. Ship it

Say to Claude Code:

> Ship it.

Claude saves the change with a short description (a "commit") and sends it to GitHub (a
"push"). Codemagic notices the push and starts a build by itself.

1. Go to https://codemagic.io and open the app **simonsays-app**. You should see a build
   running with your change. If nothing appears after two minutes, press
   **Start new build**, pick branch **main** and workflow **iOS → TestFlight**, then press
   **Start new build**.
2. Wait about five to ten minutes. The build goes green when it is finished.
3. Open **TestFlight** on your phone. The new version appears with an **Update** button.
   Sometimes it takes a few extra minutes for Apple to process it.

Each build uses paid Codemagic minutes. Group several changes into one build rather than
shipping every small edit on its own.

## What "commit", "push" and "build" mean

- **Commit:** a saved snapshot of the folder with a note saying what changed.
- **Push:** uploading that snapshot to GitHub so everyone has it.
- **Build:** Codemagic turning the folder into an actual app file and uploading it to Apple.
- **TestFlight:** Apple's app for testing versions before they go on the App Store.

## Your copy is the real one

Your GitHub copy (the fork from chapter 2) is the app from now on. Only you change it, so
nothing ever clashes. If someone else is ever going to help with the code, add them as a
collaborator on your GitHub copy and say "Pull the latest changes" to Claude before you
start each session.

## Going to the App Store (later)

TestFlight is for testing. Putting the app on the public App Store is a separate step done
once per version in App Store Connect: pick the build, fill in the "what's new" text, press
Submit for review. Apple reviews it in one to three days. Ask Claude Code "how do I submit
the app to the App Store" when you are ready and it will walk you through the screens.

---

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

---

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

---

# 6. When things go wrong

## The build fails in Codemagic

1. Open the failed build in codemagic.io. Find the step that turned red.
2. Copy the red error text (a few lines around the word "error" is enough).
3. Paste it into Claude Code and say: "Fix this build error."
4. Claude fixes the Swift, ships it, and asks you to start a new build.

Two or three rounds of this are normal for a bigger change, because nothing compiles on
this computer before Codemagic sees it.

## The build succeeds but TestFlight shows nothing

- Wait ten minutes. Apple processes builds after Codemagic uploads them.
- Check which Apple ID TestFlight on your phone is signed in with. It must match the tester
  email (`nucleondh@gmail.com` or `training@simonsays.coach`).
- Check the build in App Store Connect under TestFlight. If it says "Missing Compliance",
  say to Claude Code "the build says Missing Compliance" and it will fix the setting.

## The app shows old content

Run the sync again (chapter 3, step 1), then ship and build. If the sync says "no change"
but the website has the new content, the website file may have changed shape. Say to Claude
Code: "The sync says no change but the FAQ on the website has a new question." It will look
at the website file and fix the sync script.

## The sync script fails

- "FAILED: ... HTTP 404": a file on the website moved. Tell Claude Code the new address if
  you know it, or say "the FAQ file moved" and it will find it.
- "Could not find window.FAQ_DATA" (or a similar name): the website file changed format.
  Say "fix the sync script" and paste the message.

## Claude Code cannot find the folder or says it is not a Git repository

You opened the terminal somewhere else. In VS Code, use **File, Open Folder** and pick the
`simonsays-app` folder, then open the terminal again.

## Claude Code says "conflict" when shipping

Someone else changed the same file at the same time. Say "explain the conflict in plain
words" and tell Claude which version to keep. Never say "force push".

## Something looks wrong on a screen

Take a screenshot on your phone, describe what is wrong, and tell Claude Code which screen.
For example: "In the Defect Diagnoser the answer buttons overlap in dark mode." It knows
which file each screen lives in (chapter 7).

## You want to undo a change

Say "undo the last change" before shipping and Claude restores the file. After shipping, say
"revert the last commit" and ship again.

---

# 7. File map

You will rarely open these yourself. This is so you and your Claude know where things are.

## Top level

| File or folder | What it is |
|---|---|
| `CLAUDE.md` | Instructions Claude Code reads automatically when it starts in this folder |
| `HANDOVER.md` | Short pointer to this handover pack |
| `README.md` | Technical summary for developers |
| `codemagic.yaml` | The build recipe Codemagic follows |
| `project.yml` | Optional spec that can regenerate the Xcode project (rarely needed) |
| `SimonSays.xcodeproj/` | The Xcode project. New files dropped into `SimonSays/` are picked up automatically |
| `SimonSays/` | All of the app's code and content |
| `tools/sync-content.js` | The sync script |
| `tools/build-handover.js` | Joins the handover chapters into the all-in-one file |
| `handover/` | This pack |

## Inside `SimonSays/`

| File | What it does |
|---|---|
| `SimonSaysApp.swift` | App entry point |
| `ContentView.swift` | The tab bar: Home, Support, Handbook, Tools, More |
| `Theme.swift` | Colours, contact email, Instagram link, site link |
| `Assets.xcassets/` | App icon and accent colour |
| `Data/DataStore.swift` | Loads the bundled JSON and text files |
| `Models/FAQ.swift` | FAQ data shape |
| `Models/StudySet.swift` | Study set data shape |
| `Models/Products.swift` | Product finder data shape |
| `Models/GameData.swift` | Reads the five pipe-separated game banks |
| `Models/Profile.swift` | User profile and progress tracking |
| `Models/SearchIndex.swift` | Universal search on the home screen |

## Content copies (`SimonSays/Resources/`)

| File | Comes from | Used by |
|---|---|---|
| `faqs.json` | website FAQ | Support tab, FAQ |
| `studyset.json` | website study set | Tools tab, Handbook Study Set |
| `products.json` | website product finder | Support tab, Product Finder |
| `drills.txt` | website deck | Daily Drill Draw |
| `checklist.txt` | website checklist | Pre-flight Checklist |
| `diagnoser.txt` | website questions | Defect Diagnoser |
| `panels.txt` | website panel order | Panel Sequence Puzzle |
| `quiz.txt` | website questions | PPF Knowledge Quiz |

Never edit these by hand. Edit the website, then sync.

## Screens (`SimonSays/Views/`)

| Folder / file | Screen |
|---|---|
| `Home/SearchHomeView.swift` | Home tab with search and hero |
| `Support/LibraryView.swift` | Support tab list |
| `Support/FAQView.swift`, `FAQDetailView.swift` | FAQ list and single answer |
| `Support/CarOwnerGuideView.swift` | PPF Guide for Car Owners |
| `Support/ProductFinderView.swift` | Detailing Product Finder |
| `Handbook/HandbookView.swift` | Handbook tab. The `parts` list at the top is the six parts |
| `Tools/ToolsView.swift` | Tools tab list |
| `Tools/CoverageCalculatorView.swift`, `CoverageEngine.swift` | PPF Coverage Calculator and its maths |
| `Tools/HourlyRateCalculatorView.swift` | Hourly Rate Calculator |
| `Tools/StudySetView.swift` | Handbook Study Set quiz |
| `Tools/FunAndGamesView.swift` | Fun & Games menu |
| `Games/DailyDrillDrawView.swift` | Daily Drill Draw |
| `Games/PreflightChecklistView.swift` | Pre-flight Checklist |
| `Games/DefectDiagnoserView.swift` | Defect Diagnoser |
| `Games/PanelSequencePuzzleView.swift` | Panel Sequence Puzzle |
| `Games/KnowledgeQuizView.swift`, `MCQSessionView.swift` | PPF Knowledge Quiz and the shared multiple-choice engine |
| `Games/StretchLabView.swift` | Stretch Lab |
| `Games/HeatTackLabView.swift` | Heat & Tack Lab |
| `Games/SelfHealDemoView.swift` | Self-heal Demo |
| `Games/SpotTheDefectView.swift` | Spot the Defect |
| `More/MoreView.swift` | More tab, About the author, Contact |
| `More/ShoppingListView.swift` | PPF Shopping List |
| `Previews/LiftingEdgesView.swift` | Lifting Edges decision tree |
| `Previews/QuoteGuideView.swift` | Quote Calculator user guide |
| `Profile/ProfileView.swift` | Profile, progress, legal and privacy links |
| `Tests/TestsView.swift` | Tests and quizzes overview |
| `Shared/Components.swift` | Buttons, cards and rows used everywhere |

---

# 8. Things to say to Claude Code

Copy and paste. Change the details.

## Every session

> Pull the latest changes.

> Sync the app content from the website.

> Ship it.

## Content

> Add a new handbook section 3.4 called "Rear bumper sequencing" to Part 3. Description: ...

> Update the description of handbook Part 2 to: ...

> The FAQ on the website has three new questions. Sync and ship.

> I added five drills to the deck on the website. Sync, then show me the new lines so I can
> check the format.

## Screens and wording

> Change the contact email to ... and the Instagram link to ...

> On the About page, replace the second paragraph with: ...

> Rename the More tab item "Quote Calculator guide" to "Quote guide".

> The Stretch Lab on the website now shows a warning when the stretch goes over 30%. Add the
> same warning in the app.

## Checking before shipping

> Show me what you changed.

> Explain that change in plain words.

> Undo the last change.

## Builds

> Fix this build error: (paste the red text from Codemagic)

> Did the last push go through?

## Housekeeping

> Update the handover pack.

> What content in the app is older than the website?

> Explain what this file does: (name of a file)

## Things Claude will refuse, and why

- Adding a Buy, Upgrade or Subscribe button: Apple rules, see chapter 5.
- Opening a website page inside the app: Apple rules, see chapter 5.
- Changing the bundle ID or Codemagic workflow names: it would break builds and Apple's
  link to the app.
- Putting an Apple key or password into the folder: it would be public on GitHub.
