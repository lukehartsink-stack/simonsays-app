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

Do these in order. Tick each one off. Every step tells you what you should see on the
screen, so you know it worked. It takes about an hour, mostly waiting for downloads.

You need: your Windows laptop, your phone, and your Claude login.

---

## Step 1. Install Git

Git is the thing that keeps the app files the same on your computer and on the internet.

1. Open your web browser.
2. Go to: **https://git-scm.com/download/win**
3. Click the link that says **Click here to download**. A file downloads.
4. Open the downloaded file.
5. A window with lots of pages opens. On every page just click **Next**. Do not change
   anything. At the end click **Install**, then **Finish**.

**You should see:** the installer window closes. Nothing else opens. That is fine.

---

## Step 2. Make a GitHub account and tell Luke your username

GitHub is the website where the app files are stored.

1. Go to: **https://github.com**
2. Click **Sign up**. Use your email, pick a password, pick a username.
   Write the username down.
3. Confirm your email when GitHub asks.
4. **Send Luke a message with your GitHub username.** Luke needs it to give you access.
   Wait for Luke to say "done" before Step 4.

**You should see:** GitHub shows you a page with your username in the top right corner.

---

## Step 3. Install GitHub Desktop

GitHub Desktop is a small program that copies the app folder to your computer and remembers
your GitHub login so you never type it again.

1. Go to: **https://desktop.github.com**
2. Click **Download for Windows**. Open the downloaded file. It installs itself.
3. GitHub Desktop opens. Click **Sign in to GitHub.com**.
4. Your browser opens. Sign in with the account from Step 2. Click **Authorize** if it asks.
5. Back in GitHub Desktop, click **Finish**.

**You should see:** GitHub Desktop with a mostly empty window and your name in it.

---

## Step 4. Copy the app folder to your computer

Wait for Luke to confirm he has added you (Step 2) before doing this.

1. Check your email. There is an invitation from GitHub to "simonsays-app". Click
   **View invitation**, then **Accept invitation**.
2. Open GitHub Desktop.
3. Click **File** (top left), then **Clone repository**.
4. Click the tab **GitHub.com**. In the list, click **lukehartsink-stack/simonsays-app**.
5. Under **Local path** it says where the folder will go. Leave it as it is. Write the path
   down. It is usually something like `C:\Users\Simon\Documents\GitHub\simonsays-app`.
6. Click **Clone**.

**You should see:** a progress bar, then GitHub Desktop says "simonsays-app" at the top.
A folder called `simonsays-app` now exists in the place from point 5.

---

## Step 5. Install Node

Node runs the little script that copies website content into the app.

1. Go to: **https://nodejs.org**
2. Click the big green button that says **LTS** (it also shows a version number).
3. Open the downloaded file. Click **Next** on every page, tick the licence box when it
   asks, click **Install**, then **Finish**.

**You should see:** the installer closes. Nothing else opens.

---

## Step 6. Install Visual Studio Code

VS Code is the window you will work in. Think of it as a notepad with a chat built in.

1. Go to: **https://code.visualstudio.com**
2. Click **Download for Windows**. Open the downloaded file.
3. Click **Next** on every page. On the page with tick boxes, tick **Add to PATH** and
   **Create a desktop icon** if they are not ticked. Click **Install**, then **Finish**.
4. VS Code opens. Close the welcome tab if it shows one.

**You should see:** a dark window with a menu bar at the top saying File, Edit, Selection...

---

## Step 7. Open the app folder in VS Code

1. In VS Code, click **File** (top left), then **Open Folder...**
2. Find the `simonsays-app` folder from Step 4. Click it once, then click **Select Folder**.
3. If VS Code asks "Do you trust the authors of the files in this folder?", click
   **Yes, I trust the authors**.

**You should see:** on the left side, a list of files and folders. Among them:
`CLAUDE.md`, `handover`, `SimonSays`, `tools`. If you see those, you are in the right place.

VS Code remembers this folder. Next time you open VS Code it opens here by itself.

---

## Step 8. Install Claude Code

This is Claude, but living inside the folder so it can read and change the files.

1. In VS Code, click **View** (top menu), then **Terminal**. A black box appears at the
   bottom of the window. That is the terminal. You type commands in it.
2. Click inside the black box. Copy this line exactly and paste it in, then press **Enter**:

   ```
   irm https://claude.ai/install.ps1 | iex
   ```

3. Text scrolls by for a minute. Wait until it stops and says something like
   "Claude Code installed" or "Installation complete".
4. Close VS Code completely (click the X top right). Open it again from the desktop icon.
   It opens on the app folder again.

**You should see:** after reopening, the folder list on the left is still there.

---

## Step 9. Start Claude and log in

1. In VS Code, click **View**, then **Terminal** (the black box comes back).
2. Type this and press **Enter**:

   ```
   claude
   ```

3. The first time it asks you to choose a theme. Press **Enter**.
4. It asks how you want to log in. Choose **Claude account with subscription**. Your
   browser opens. Log in with your normal Claude login. Click **Authorize**.
5. Go back to VS Code. Claude is waiting for you with a `>` prompt.
6. Type this and press **Enter**:

   > Explain what this app is and how I update it.

**You should see:** Claude answers in plain words and mentions three steps: sync, change,
ship. That means Claude has read the instructions in the folder and knows the app.

To stop Claude, type `/exit` and press **Enter**. To come back, type `claude` again.

---

## Step 10. Check that the sync works

1. In the terminal (if Claude is running, type `/exit` first), type this and press
   **Enter**:

   ```
   node tools/sync-content.js
   ```

**You should see:** eight lines, one per file, each ending with "no change" or "updated".
Then a line saying "Everything already up to date" or "N file(s) updated".

If it says "updated" for any file, do not worry. It means the website has newer content than
the app. Chapter 3 tells you what to do with that.

---

## Step 11. Codemagic (the robot that builds the app)

You already made a Codemagic account. Now connect it to the app folder on GitHub.

1. Go to: **https://codemagic.io** and log in.
2. Click **Add application** (a blue button).
3. Choose **GitHub**. If it asks to connect your GitHub account, click **Connect** and
   authorize it in the browser. This is the same GitHub account from Step 2.
4. In the list of repositories, pick **simonsays-app**. If it is not in the list, click the
   link to install the Codemagic GitHub app and tick **simonsays-app**, then come back.
5. When it asks the project type, choose **iOS App** (or "Other", either works).
6. Click **Finish**.

**You should see:** an app called **simonsays-app** on your Codemagic dashboard. Codemagic
finds the build recipe (`codemagic.yaml`) in the folder by itself.

**Then the Apple key.** Codemagic needs a key from Apple to sign the app. Luke will send you
this key privately (a small file ending in `.p8`, plus two codes called Issuer ID and Key ID).
Do not put the key in the app folder, and do not email it around. When you have it:

1. In Codemagic, click **Teams** (left menu), then your team name.
2. Click **Integrations**, then next to **Developer Portal** click **Manage keys** (or
   **Connect**).
3. Click **Add key**. Fill in:
   - **App Store Connect API key name:** `AutoBook ASC Admin` (exactly this, it must
     match the recipe)
   - **Issuer ID:** paste the code Luke sent
   - **Key ID:** paste the code Luke sent
   - **API key:** click Upload and pick the `.p8` file Luke sent
4. Click **Save**.

**You should see:** "AutoBook ASC Admin" in the list of keys.

**Then a test build.** On the Codemagic dashboard click **simonsays-app**, then
**Start new build**. Pick branch **main** and workflow **iOS → TestFlight**. Click **Start
new build**. It takes five to ten minutes. If every step turns green, you are done. If
something turns red, copy the red text and send it to Luke this first time.

From now on, every time you "ship" a change (chapter 3), Codemagic starts a build by
itself. You only open Codemagic to watch it or if something fails.

---

## Step 12. Tell Luke which Apple ID your phone uses

TestFlight only shows the app to the Apple ID that was invited. Two emails were invited:
`nucleondh@gmail.com` and `training@simonsays.coach`. Luke needs to know which one your
phone is signed in with.

1. On your iPhone open **Settings**.
2. Tap your name at the very top.
3. Under your name is an email address. That is your Apple ID.
4. **Send that email address to Luke.** If it is neither of the two above, tell Luke and he
   will invite the right one.

**You should see:** after Luke confirms, the TestFlight app on your phone shows
"simonsays.coach" with an Install or Update button.

---

## Done

You now have everything. From here on, the only things you ever do are in chapter 3:
open VS Code, type `claude`, and talk to it.

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

## Keeping in step with Luke

Both you and Luke can make changes. Git merges them. To avoid stepping on each other:

- Before you start a session, say to Claude Code: "Pull the latest changes." It fetches
  anything Luke pushed since last time.
- Ship your own changes when you finish, not days later.
- If Claude says there is a "conflict", do not guess. Say "explain the conflict" and, if it
  is not obvious, send Luke a message.

## Going to the App Store (later)

TestFlight is for testing. Putting the app on the public App Store is a separate step done
once per version in App Store Connect: pick the build, fill in the "what's new" text, press
Submit for review. Apple reviews it in one to three days. Luke does this the first time and
will show you.

---

# 4. Accounts and who owns what

Five services are involved. Here is what each one does, who holds it today, and what you
need from it.

| Service | What it is for | Held by today | What Simon needs |
|---|---|---|---|
| **GitHub** (github.com/lukehartsink-stack/simonsays-app) | Stores the app's files and their history | Luke | Free GitHub account, added as a collaborator |
| **Codemagic** (codemagic.io, app "simonsays-app") | Builds the app in the cloud and uploads it to Apple | Simon's own account (set up in chapter 2, step 11) | The Apple key from Luke, added under the name "AutoBook ASC Admin" |
| **Apple Developer / App Store Connect** | Apple's side: certificates, the app record, TestFlight, App Store | Luke's Apple developer account | A TestFlight tester invite (already sent) |
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

## Moving the app to Simon's own accounts (optional, later)

Nothing has to move for the workflow to work. If you want the app fully under your name:

1. **Apple:** open your own Apple Developer account ($99 a year). Luke transfers the app to
   it inside App Store Connect. The bundle ID and all TestFlight history come with it.
   You then invite Luke to your team so he can keep helping.
2. **Codemagic:** already yours. Once the app is under your Apple account, make a new
   App Store Connect API key there and replace the "AutoBook ASC Admin" key in Codemagic
   with it, same name.
3. **GitHub:** either Luke transfers the repository to your account, or it stays where it is
   with you as collaborator. Both work.

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
  that should not happen (the app declares it uses no special encryption), but tell Luke if
  it does.

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

Luke changed the same file at the same time. Say "explain the conflict in plain words". If
the answer is clear, tell Claude which version to keep. If not, message Luke. Never say
"force push".

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
