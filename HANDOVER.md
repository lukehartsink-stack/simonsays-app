# How to update the simonsays.coach app

The full handover pack lives in the `handover/` folder. Start with `handover/README.md`.

The short version:

1. Open the app folder in VS Code, open the terminal, type `claude`.
2. Say **"Sync the app content from the website."**
3. Say what else you want changed, in plain words.
4. Say **"Ship it."** Then start a build on codemagic.io (app "simonsays-app", branch main,
   workflow "iOS → TestFlight") if one has not started by itself.
5. Wait five to ten minutes, open TestFlight on your phone, press Update.

For Claude: `handover/SIMON-SAYS-APP-HANDOVER.md` is every chapter in one file. Upload it to
a Claude project as knowledge. Rebuild it after editing any chapter with
`node tools/build-handover.js`.
