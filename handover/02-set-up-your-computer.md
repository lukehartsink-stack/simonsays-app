# 2. Set up your computer (one time)

You need six things. Each takes a few minutes. Do them in order.
This works on Windows or Mac. Where the steps differ it says so.

## 1. Git

Git keeps the app's files in sync between your computer, Luke's computer and GitHub.

- **Windows:** download from https://git-scm.com/download/win and run the installer.
  Accept every default. When asked about a credential manager, keep it ticked.
- **Mac:** open Terminal and type `git --version`. If it offers to install command line
  tools, say yes.

## 2. GitHub Desktop (the easy way to get the folder)

GitHub is where the app's files are stored online. GitHub Desktop is a friendly app that
handles the login for you, so you never deal with keys or passwords in the terminal.

1. Create a free account at https://github.com if you do not have one. Tell Luke your
   username so he can add you to the app's repository.
2. Download GitHub Desktop from https://desktop.github.com and sign in.
3. Accept the invitation email from GitHub.
4. In GitHub Desktop: **File, Clone repository**, pick `lukehartsink-stack/simonsays-app`,
   choose where to keep it (for example `Documents/simonsays-app`), press **Clone**.

That folder is now the app. Everything below happens inside it.

## 3. Node.js

Node runs the sync script that copies website content into the app.

- Go to https://nodejs.org and press the big **LTS** button. Run the installer, accept the
  defaults.
- To check: open a terminal and type `node --version`. You should see a version number.

## 4. Visual Studio Code

VS Code is the editor. You will mostly use it as a window with a terminal in it.

1. Download from https://code.visualstudio.com and install.
2. Open VS Code. **File, Open Folder** and pick the `simonsays-app` folder.
3. Optional: install the **Claude Code** extension from the Extensions panel (the four
   squares icon on the left, search "Claude Code", by Anthropic). It adds a Claude button to
   VS Code. The terminal version below works without it.

## 5. Claude Code (the terminal version)

This is the same Claude you already pay for, but it can read and edit files in the folder.

**Windows:** open PowerShell and run:

```
irm https://claude.ai/install.ps1 | iex
```

**Mac:** open Terminal and run:

```
curl -fsSL https://claude.ai/install.sh | bash
```

Then close and reopen the terminal.

Start it inside the app folder:

1. In VS Code, open the terminal from the menu: **View, Terminal**. The terminal opens
   inside the app folder automatically.
2. Type `claude` and press Enter.
3. The first time it asks you to log in. Type `/login`, pick "Claude account with
   subscription", and it opens your browser to sign in.

You are now talking to Claude inside the app folder. It has already read the file
`CLAUDE.md`, which tells it everything about the app, so you can just say what you want.

To stop: type `/exit` or close the terminal.

## 6. Codemagic (the build robot)

Codemagic is a service with Macs in the cloud. It takes the folder, compiles the app, signs it
with the Apple certificates and uploads it to TestFlight. It is needed because nobody in this
project builds on a Mac with Xcode.

- Go to https://codemagic.io and create an account. Sign in with GitHub, it is simplest.
- Tell Luke, and he adds you to the team that has the "simonsays-app" application. Until
  then, Luke can press the build button when you say a change is ready.

See chapter 4 for who owns which account and how that can change later.

## Check that everything works

In the VS Code terminal, inside the app folder, type:

```
node tools/sync-content.js
```

You should see one line per file saying "no change" or "updated". That proves Node, the
folder and the internet connection all work. If it says "updated" on anything, the website
has newer content than the app. Chapter 3 says what to do with that.

Then type `claude` and say:

> Explain what this app is and how I update it.

If it answers in plain words with the three-step routine, you are set up.
