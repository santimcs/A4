# AGENTS.md

A working agreement between you (the human) and any AI agent (me, or any other LLM assistant) that you bring into this project. Review this periodically — say, once a quarter, or after any major change to your stack or workflow.

---

## 1. Purpose of this document

This file exists to make collaboration with AI agents **predictable, safe, and repeatable**. It records:

- What the agent is allowed to do without asking
- What requires your explicit approval
- What is forbidden outright
- How the agent should behave when uncertain
- What context the agent needs to do useful work

Any agent that hasn't read this file should not be given write access to your code, notebooks, or databases.

---

## 2. Project context

**Owner:** Santisoon Tarinka (santisoontarinka@gmail.com)

**What this project is:**
A personal investment portfolio tracker and analysis toolkit built around:

- **Ruby on Rails** web app for data entry (`C:\ruby\portlt`) — SQLite database (`development.sqlite3`)
- **MySQL** databases on `localhost`:
  - `portfolio_development` — canonical portfolio tables (`buys`, `sells`, `dividends`, `stocks`)
  - `stock` — market data (`price`, `setindex`)
- **Jupyter Notebooks** for analytics and dashboard generation, primarily `2 Years Price Data by Name.ipynb`
- **HTML dashboards** generated per-ticker into `C:\Users\PC1\OneDrive\A4\CSV\`
- **CSV exports** of portfolio tables for cross-checking

**Key paths:**
| Purpose | Path |
|---|---|
| Notebook working dir | `C:\Users\PC1\OneDrive\A4\Database` |
| CSV output | `C:\Users\PC1\OneDrive\A4\CSV` |
| Data folder | `C:\Users\PC1\OneDrive\A4\Data` |
| Rails app | `C:\ruby\portlt` |

**Currency:** Thai Baht (฿) throughout. Prices are in THB, not satang, not USD.

**Market:** Stock Exchange of Thailand (SET). Tickers include RCL, ADVANC, PTT, TFFIF, WHAIR, etc.

---

## 3. What the agent may do without asking

✅ **Read everything** in these locations:
- `C:\Users\PC1\OneDrive\A4\Database` (notebooks)
- `C:\Users\PC1\OneDrive\A4\CSV` (outputs)
- `C:\ruby\portlt` (Rails app source)
- Any file the user pastes into the conversation

✅ **Run read-only SQL** against both databases:
```sql
SELECT ... FROM ...     -- allowed
SHOW COLUMNS FROM ...   -- allowed
DESCRIBE ...            -- allowed
EXPLAIN ...             -- allowed
```

✅ **Write new files** to `C:\Users\PC1\OneDrive\A4\CSV` only, when:
- Generating a dashboard or report
- Producing a CSV export
- Creating a temporary analysis artifact

✅ **Add new Jupyter notebook cells** — always as new cells, never by overwriting existing ones.

✅ **Suggest changes** to code, SQL, formulas, and dashboards.

✅ **Point out bugs, inconsistencies, or risky patterns** in existing work — even if not asked.

---

## 4. What requires explicit approval

⚠️ **Any `INSERT`, `UPDATE`, or `DELETE` statement** — even on your local DB — must be shown as a proposed query first, with a plain-English description of exactly which rows will be affected. The user runs it, not the agent.

⚠️ **Schema changes** (`ALTER TABLE`, `CREATE TABLE`, `DROP TABLE`) — always show the DDL and a rollback plan.

⚠️ **Overwriting existing files** — including notebooks (`.ipynb`), CSVs, and dashboards. Always save to a new filename unless the user explicitly says "overwrite".

⚠️ **Adding new Python library dependencies** — state the package, why it's needed, and whether a stdlib alternative exists.

⚠️ **Changing file paths** in the notebook — the paths are environment-specific (`C:\Users\PC1\...`) and shouldn't be hardcoded or altered without a clear reason.

⚠️ **Touching Git** — do not `git commit`, `git push`, `git reset`, `git clean`, or run any destructive git command. Suggest commands for the user to run.

⚠️ **Modifying the Rails app** — read-only unless the user provides explicit scope for the change.

---

## 5. What is forbidden

🚫 **Never run** any of these without exception:
- `DROP DATABASE`, `DROP TABLE`
- `TRUNCATE TABLE`
- `DELETE` without a `WHERE` clause
- `UPDATE` without a `WHERE` clause
- `git push --force`
- `rm -rf` on any user directory
- Shell commands that modify files outside `C:\Users\PC1\OneDrive\A4\CSV`

🚫 **Never assume** the identity of a ticker. `RCL` in your DB is the **Thai** Regional Container Lines (SET: RCL), not the US Royal Caribbean. Similarly, verify ticker identity before any analysis.

🚫 **Never invent** data — if a column is missing, if a value is null, or if a query fails, stop and report. Don't fill gaps with plausible-looking numbers.

🚫 **Never mix currencies silently** — everything is ฿. If a source appears to be USD, call it out.

🚫 **Never use `.format()` on HTML+JS+CSS templates** without doubling all literal braces — this has bitten us repeatedly (the `KeyError: 'label'` and blank-chart bugs). Prefer `.replace("__TOKEN__", value)` with unique sentinel tokens. If you must use `.format()`, double every `{` and `}`.

🚫 **Never write to `.git/`** — OneDrive and Git conflict here already (see the failed folder deletion issue).

---

## 6. How the agent handles uncertainty

When the agent is not sure:

1. **State the uncertainty explicitly** — "I'm not certain whether X is Y or Z."
2. **Ask for the minimum information needed** — one clarifying question at a time, not a wall of questions.
3. **Offer the best guess + how to verify it** — "I think it's Y; here's how to confirm in one line."
4. **Never proceed silently on an assumption** that affects data integrity, file writes, or financial conclusions.

Examples of the right behaviour:
- "Before I write the SQL, can you run `SHOW COLUMNS FROM buys` and paste the output?"
- "The sell table doesn't have a `kind` column — should I remove it from the dashboard or pull it from `buys`?"
- "Your dividend row 599 shows 91% withholding instead of the usual 10%. Is that a data-entry error or intentional?"

---

## 7. Dashboard-building conventions

When the agent builds or modifies a dashboard:

**Structure:**
- Single self-contained HTML file (no local assets, all CDNs)
- Chart library: **Chart.js** for most charts, **Plotly** for buy-zone overlays
- Colour palette: dark background `#0f1720`, panel `#17212b`, accent `#4fc3f7`, green `#4caf50`, red `#ef5350`, amber `#ffb74d`
- All amounts prefixed with `฿`

**Data flow:**
- Python builds a single `payload` dict → `json.dumps` → embedded as `const P = {...};`
- No data is fetched at page-load time — everything is baked into the HTML

**Brace escaping:**
- Use `.replace("__NAME__", NAME)` not `.format(name=NAME)`
- If `.format()` is unavoidable, double every literal `{` and `}`
- Search for `{` at the top level of JS blocks whenever a template fails — that's almost always the bug

**Ticker neutrality:**
- The dashboard should work for any ticker by changing `NAME = 'XXX'` in cell 1
- Never hardcode RCL/ADVANC/PTT into the template text — use `{name}` / `__NAME__`

**Verification:**
- Every KPI must tie arithmetically to the source tables
- If a number changes between runs, the agent must explain why (data change vs code change)

---

## 8. Analysis conventions

When the agent produces investment commentary:

- **Distinguish technicals from fundamentals.** The dashboard is a technical tool — it doesn't know earnings, P/E, or dividend sustainability. Say so.
- **State assumptions.** If the agent assumes a 90% dividend withholding rate, say it.
- **Frame recommendations as "frameworks" not "predictions".** A buy zone is a range, not a promise.
- **Give reasoning, not just conclusions.** "Sell because MA falling" is weaker than "Sell because MA has fallen 1.1% over the last 20 sessions while price is 5% below MA — two independent bearish signals."
- **Correct past mistakes transparently.** If the agent previously said ADVANC's dividend was ฿15,184 and it's actually ฿17,995, lead with the correction.

---

## 9. Communication style

- **Answer the question that was asked** first, then add context.
- **Use Thai Baht** in all monetary displays. Use `฿` not "THB" or "$".
- **Prefer concrete examples** over abstract explanation. Show the code, the SQL, the HTML.
- **Lead with the diagnosis, then the fix** when reporting bugs.
- **Tables for comparison, prose for reasoning.**
- **Never apologise repeatedly** — one line max. Fix the issue instead.
- **Respect the user's competence.** This is a sophisticated personal system; the user understands SQL, Python, Rails, and finance. Don't over-explain basics.

---

## 10. Session startup checklist

When a new agent session begins, the agent should:

1. **Ask what the user wants to work on** — dashboard, query, analysis, debug — rather than assuming.
2. **Confirm which ticker and which database** are in scope.
3. **Check recent file changes** if the user mentions a specific notebook or dashboard.
4. **Verify the top-level `NAME` variable** if the notebook is involved — it changes the whole output.
5. **Run a data sanity check** (like the dividend 90% rule) on any freshly-fetched table before building on it.

---

## 11. Known gotchas (running list)

This section grows as we discover more. Add new entries when a bug is fixed.

| Gotcha | Why it matters | Corrective habit |
|---|---|---|
| `.format()` + literal braces in JS/CSS | Silently `KeyError`s or breaks JS | Use `.replace()` or double braces |
| Plotly used but not imported | Blank chart, kills JS below it | Check `<head>` for both CDN scripts |
| Column name assumed (e.g., `kind`) | `KeyError` at serialization | Always `print(df.columns.tolist())` |
| `WHERE name = '%s'` in SQL | Literal `%s` or nested quotes | Use `params={"name": value}` |
| `JOIN` misspelled `JOINS` | MySQL syntax error | Only `JOIN`, never `JOINS` |
| Date formats mismatch (string vs Timestamp) | Joins silently drop all rows | `pd.to_datetime(...).dt.strftime(...)` |
| OneDrive + Git | Failed `.git/objects` deletions | Move repo out of OneDrive, or pause sync |
| Dividend net ≠ 90% of gross | Underreports returns by thousands of ฿ | Run the 90% sanity check after every fetch |
| 200-MA on <200 rows | Returns null or short average | Fetch at least 3 years of prices |
| Same-day sell (`days == 0`) | `annualizedPct` divides by zero | Guard: `if days <= 0: return 0` |

---

## 12. Periodic review

This file should be revisited:

- **Quarterly** — even if nothing obvious changed
- **After any bug** that took more than 30 minutes to fix (add to §11)
- **After any change** to the DB schema, notebook structure, or dashboard framework
- **After onboarding a new tool** (new chart library, new data source, new broker API)

If a rule in this file is outdated, say so and propose an amendment rather than quietly breaking it.

---

## 13. What this file is not

- Not a contract — the user is always free to override any rule
- Not a replacement for your own judgement — if the user asks for something that contradicts §4 or §5, ask them to confirm before proceeding
- Not exhaustive — assume good faith and reason from the principles above when a specific case isn't covered

---

**Last reviewed:** 2026-09-25  
**Next review due:** 2026-12-25 (quarterly)  
**Owner:** santisoontarinka@gmail.com