# simonsays.coach app — handover pack

Simon, this folder is for you. It explains everything about the iPhone app, how it is built,
how it gets to your phone, and how you update it yourself with Claude Code. No coding needed.

## Two ways to use this pack

1. **Read it.** Start with `01-what-the-app-is.md` and go in order. Each chapter is short.
2. **Give it to Claude.** The file `SIMON-SAYS-APP-HANDOVER.md` is every chapter joined into
   one document. Upload it to your Claude project (the one you already use for the website)
   as project knowledge. From then on your Claude knows how the app works, what it can and
   cannot change, and when something on the website needs to be pushed into the app.

When you open this folder in Claude Code (the terminal version), it reads `CLAUDE.md` in the
main folder automatically. You do not have to paste anything.

## The chapters

| File | What it covers |
|---|---|
| `01-what-the-app-is.md` | What the app contains and where each piece of content comes from |
| `02-set-up-your-computer.md` | One-time setup: Git, Node, VS Code, Claude Code, GitHub, Codemagic |
| `03-everyday-workflow.md` | The three-step routine: sync, change, ship |
| `04-accounts-and-who-owns-what.md` | GitHub, Codemagic, Apple, TestFlight: who holds what and how to move it |
| `05-rules.md` | The rules that keep Apple happy and the app on brand |
| `06-when-things-go-wrong.md` | Build errors, old content, TestFlight not showing the build |
| `07-file-map.md` | Every file in the project and what it does |
| `08-things-to-say-to-claude.md` | Copy-and-paste sentences for the common jobs |
| `SIMON-SAYS-APP-HANDOVER.md` | All of the above in one file, for uploading to Claude |

If any chapter is out of date, say to Claude Code: "Update the handover pack" and it will
rewrite the chapters and rebuild the all-in-one file.
