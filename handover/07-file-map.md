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
