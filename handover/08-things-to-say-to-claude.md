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
