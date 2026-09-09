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
