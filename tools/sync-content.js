// Pulls the latest content from simonsays.coach into the app.
// Run:  node tools/sync-content.js
// Then commit, push, and start a Codemagic build (see HANDOVER.md).

const fs = require("fs");
const path = require("path");

const OUT = path.join(__dirname, "..", "SimonSays", "Resources");
const SITE = "https://simonsays.coach";
const GAMES = SITE + "/training-tools/fun-and-games/";

const SOURCES = [
  // JSON data ---------------------------------------------------------------
  {
    file: "faqs.json",
    url: SITE + "/support/faq/faqs.js",
    pick: (text) => JSON.stringify(JSON.parse(stripJs(text, "window.FAQ_DATA"))),
  },
  {
    file: "studyset.json",
    url: SITE + "/training-tools/handbook-study-set/questions.js",
    pick: (text) => JSON.stringify(JSON.parse(stripJs(text, "window.STUDY_SET"))),
  },
  {
    file: "products.json",
    url: SITE + "/support/detailing-product-finder/universal/",
    pick: (html) => {
      const m = html.match(/const BRANDS\s*=\s*(\[[\s\S]*?\]);\s*$/m);
      if (!m) throw new Error("Could not find `const BRANDS = [...]` in the product finder page");
      return JSON.stringify(JSON.parse(m[1]));
    },
  },
  // Pipe-separated text banks behind the Fun & Games tools ------------------
  { file: "drills.txt",     url: GAMES + "daily-drill-draw/deck.js",          pick: (t) => stripBacktick(t, "window.DECK_TEXT") },
  { file: "checklist.txt",  url: GAMES + "pre-flight-checklist/checklist.js", pick: (t) => stripBacktick(t, "window.CHECKLIST_TEXT") },
  { file: "diagnoser.txt",  url: GAMES + "defect-diagnoser/questions.js",     pick: (t) => stripBacktick(t, "window.QUESTIONS") },
  { file: "panels.txt",     url: GAMES + "panel-sequence-puzzle/panels.js",   pick: (t) => stripBacktick(t, "window.PANELS_TEXT") },
  { file: "quiz.txt",       url: GAMES + "ppf-knowledge-quiz/questions.js",   pick: (t) => stripBacktick(t, "window.QUESTIONS") },
];

// "window.X = {...};"  ->  "{...}"
function stripJs(text, name) {
  const start = text.indexOf(name);
  if (start < 0) throw new Error(`Could not find ${name}`);
  const eq = text.indexOf("=", start);
  let body = text.slice(eq + 1).trim();
  if (body.endsWith(";")) body = body.slice(0, -1);
  return body;
}

// "window.X = `...`;"  ->  the lines between the backticks, comments removed
function stripBacktick(text, name) {
  // Anchor to the real assignment at the start of a line, not the mention in the header comment.
  const re = new RegExp("^" + name.replace(/\./g, "\\.") + "\\s*=\\s*`", "m");
  const m = re.exec(text);
  if (!m) throw new Error(`Could not find ${name} = \``);
  const open = m.index + m[0].length - 1;
  const close = text.indexOf("`", open + 1);
  if (close < 0) throw new Error(`Could not find the closing backtick for ${name}`);
  return text
    .slice(open + 1, close)
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l && !l.startsWith("//"))
    .join("\n") + "\n";
}

async function main() {
  let changed = 0;
  for (const s of SOURCES) {
    process.stdout.write(`Fetching ${s.file} ... `);
    const res = await fetch(s.url, { headers: { "cache-control": "no-cache" } });
    if (!res.ok) throw new Error(`${s.url} -> HTTP ${res.status}`);
    const out = s.pick(await res.text());
    const target = path.join(OUT, s.file);
    const before = fs.existsSync(target) ? fs.readFileSync(target, "utf8") : "";
    if (before === out) {
      console.log("no change");
    } else {
      fs.writeFileSync(target, out);
      changed++;
      console.log("updated");
    }
  }
  console.log(changed ? `\n${changed} file(s) updated. Now: git add -A && git commit -m "Sync content" && git push` : "\nEverything already up to date.");
}

main().catch((e) => {
  console.error("\nFAILED:", e.message);
  process.exit(1);
});
