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
