// Pulls the latest FAQ, study set and product data from simonsays.coach into the app.
// Run:  node tools/sync-content.js
// Then commit, push, and start a Codemagic build (see HANDOVER.md).

const fs = require("fs");
const path = require("path");

const OUT = path.join(__dirname, "..", "SimonSays", "Resources");

const SOURCES = [
  {
    file: "faqs.json",
    url: "https://simonsays.coach/support/faq/faqs.js",
    pick: (text) => stripJs(text, "window.FAQ_DATA"),
  },
  {
    file: "studyset.json",
    url: "https://simonsays.coach/training-tools/handbook-study-set/questions.js",
    pick: (text) => stripJs(text, "window.STUDY_SET"),
  },
  {
    file: "products.json",
    url: "https://simonsays.coach/support/detailing-product-finder/universal/",
    pick: (html) => {
      const m = html.match(/const BRANDS\s*=\s*(\[[\s\S]*?\]);\s*$/m);
      if (!m) throw new Error("Could not find `const BRANDS = [...]` in the product finder page");
      return m[1];
    },
  },
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

async function main() {
  let changed = 0;
  for (const s of SOURCES) {
    process.stdout.write(`Fetching ${s.file} ... `);
    const res = await fetch(s.url, { headers: { "cache-control": "no-cache" } });
    if (!res.ok) throw new Error(`${s.url} -> HTTP ${res.status}`);
    const raw = s.pick(await res.text());
    const data = JSON.parse(raw); // validates it's real JSON
    const json = JSON.stringify(data);
    const target = path.join(OUT, s.file);
    const before = fs.existsSync(target) ? fs.readFileSync(target, "utf8") : "";
    if (before === json) {
      console.log("no change");
    } else {
      fs.writeFileSync(target, json);
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
