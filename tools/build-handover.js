// Joins the handover chapters into one file Simon can upload to his Claude project.
// Run:  node tools/build-handover.js
// Output: handover/SIMON-SAYS-APP-HANDOVER.md

const fs = require("fs");
const path = require("path");

const DIR = path.join(__dirname, "..", "handover");
const OUT = path.join(DIR, "SIMON-SAYS-APP-HANDOVER.md");

const chapters = fs
  .readdirSync(DIR)
  .filter((f) => /^\d\d-.*\.md$/.test(f))
  .sort();

const today = new Date().toISOString().slice(0, 10);
const header = [
  "# simonsays.coach iPhone app — complete handover",
  "",
  `Built ${today} from the chapters in the app folder's handover/ directory.`,
  "This one file is meant to be uploaded to a Claude project as knowledge, so that Claude",
  "understands the app, where its content comes from, how it is built and shipped, and what",
  "it must never do. The same information lives in CLAUDE.md for Claude Code in the terminal.",
  "",
  "---",
  "",
].join("\n");

const body = chapters
  .map((f) => fs.readFileSync(path.join(DIR, f), "utf8").trim())
  .join("\n\n---\n\n");

fs.writeFileSync(OUT, header + body + "\n");
console.log(`Wrote ${path.relative(process.cwd(), OUT)} from ${chapters.length} chapters.`);
