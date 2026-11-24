# graphify-kit

A portable playbook of global **plugins**, **rules**, **workflow overrides**, and **Git templates** for **Google Antigravity** — designed to make AI coding agents use **Graphify** properly, enforce **visual/runtime verification**, control token & quota burn, and keep GitHub repositories spotless.

---

## Why `graphify-kit`?

In real multi-task engineering sessions, AI coding agents often waste tokens and introduce regressions in predictable ways:
- **Graphify misuse:** Calling MCP tools with wrong parameter names (`id` instead of `symbol`), querying stale Cloud commits during local edits, or ignoring the graph and re-reading the same raw files 15–20 times.
- **Unverified UI changes:** Trusting `jsdom` unit tests or static CSS inspection while missing real CSS specificity overrides, contrast bugs, or layout clipping until the final task.
- **Subagent & SDD drift:** Letting one task balloon past 100+ turns, inheriting mismatched model tiers, re-reading 4–6 full `SKILL.md` files in every subagent, or hitting WSL `bash.exe` errors on Windows.
- **Noisy Git history:** Leaking AI planning/scratch files into `.gitignore` or committing without enough *why* context for future `git blame` archaeology.

`graphify-kit` turns the fixes for all of those into reusable, global defaults.

---

## Repository Structure

```text
graphify-kit/
├── install.ps1                                 # Windows PowerShell installer (with -Preview & backups)
├── LICENSE
├── README.md
├── plugins/
│   ├── graphify-workflow/                      # Global Graphify MCP + local CLI rules
│   │   ├── plugin.json
│   │   └── rules/GEMINI.md
│   └── engineering-guardrails/                 # Cross-session execution, UI & Git guardrails
│       ├── plugin.json
│       └── rules/GEMINI.md
├── skill-overrides/                            # Enhanced Superpowers SDD & planning skills
│   ├── subagent-driven-development/
│   │   ├── SKILL.md
│   │   ├── implementer-prompt.md
│   │   ├── task-reviewer-prompt.md
│   │   ├── re-review-prompt.md
│   │   ├── references/
│   │   └── scripts/                            # Git Bash-safe LF scripts (matches prefixed Task N, excludes lockfiles)
│   └── writing-plans/
│       └── SKILL.md
└── templates/
    ├── .github/pull_request_template.md        # Blame-friendly PR & commit map template
    └── git-info-exclude.txt                    # Local-only AI/graph exclusions for .git/info/exclude
```

---

## What Each Component Does

### 1. `plugins/graphify-workflow`
- **Graph-first & Bounded Scope:** Queries Graphify before broad `grep` or repeated `read_file` calls, and stops expanding once the asked symbols/questions are answered.
- **Direct MCP Call Cheat-Sheet:** Lists exact parameters (`ServerName: "graphify"`, `repository_id` as `<owner>/<name>`, `symbol` vs `term` vs `question`, `skeleton=true`) so agents don't waste turns reading `.json` schema files or hitting parameter errors.
- **Local-first while coding, Push on clean Task PASS:** Uses `graphify update .` and local `graphify query`/`explain`/`path` on `graphify-out/graph.json` for uncommitted edits, and pushes only after a task passes review cleanly so Graphify Cloud re-indexes verified state.

### 2. `plugins/engineering-guardrails`
1. **Execution Mode Gate:** Confirms Inline (`executing-plans`) vs `/subagent-driven-development` before coding a multi-task plan.
2. **Conditional Visual & Browser Gate:** Runs a live `browser` verifier right after foundational UI tasks (Theme Tokens / App Shell) and before claiming Done on any CSS/Theme/Layout/Contrast/Animation refactor.
3. **Solo Architectural Pre-Check:** Inspects underlying library mechanics (e.g., AntD `cssVar`/specificity) and confirms 2–3 criteria before big solo refactors; fast-paths small 1–2 file bugfixes.
4. **SDD & Cost Discipline:** Requires explicit `Model` tiers (`flash` default; `pro` for Final Whole-Branch Review, core architecture, or fix round 3+), reuses the active reviewer via `send_message`, bans `manage_subagents(list)` polling, and enforces post-compaction ledger/`fix-loop.md` re-reads.
5. **Clean GitHub Repo & Branch Isolation:** Keeps AI tooling/docs/graphs in `.git/info/exclude` (never `.gitignore`), checks `git ls-files` before pushing, and chooses dedicated feature branches vs `git worktree` appropriately.

### 3. `skill-overrides/` *(Optional)*
- **Windows Git Bash instructions** so `sdd-workspace`, `task-brief`, and `review-package` do not fail under `C:\Windows\system32\bash.exe`.
- **`task-brief`** matches both `### Task N` and prefixed headings (e.g., `### UI Task N`) and normalizes Windows CRLF.
- **`review-package`** excludes noisy lockfiles (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`) from diff bodies while keeping them in `--stat`.
- **Skill Digest (`conventions.md`)** and **`< 40` turns task ceiling** in `writing-plans` + `subagent-driven-development`.

### 4. `templates/`
- **`.github/pull_request_template.md`**: Captures *Root Cause*, *Design Decisions & Invariants*, *Commit & Change Map*, DB/API impact, and verification evidence to make `git blame` + `gh pr list --search <sha>` + `gh pr view` fast months later.
- **`git-info-exclude.txt`**: Standard local exclusion rules for `.git/info/exclude`.

---

## Installation

### Prerequisites
- **Google Antigravity** (with `graphify` MCP connected in `~/.gemini/config/mcp_config.json`)
- **Git** (and **Git Bash** at `C:\Program Files\Git\bin\bash.exe` on Windows if using SDD shell scripts)
- **GitHub CLI (`gh`)** *(recommended for PR creation & blame lookups)*
- **Graphify CLI** *(optional for local offline graph updates)*:
  ```bash
  pip install "graphifyy[sql]"
  ```

### Windows (One-Command PowerShell Installer)

Preview changes first without writing anything:
```powershell
.\install.ps1 -Preview
```

Install the two global plugins (`graphify-workflow` + `engineering-guardrails`) into `$env:USERPROFILE\.gemini\config\plugins\`:
```powershell
.\install.ps1
```

Also apply the `subagent-driven-development` and `writing-plans` overrides (creates timestamped backups in `~/.gemini/config/backups/` first):
```powershell
.\install.ps1 -WithSkillOverrides
```

Initialize a target Git repository's `.git/info/exclude` (and optionally copy `.github/pull_request_template.md`):
```powershell
.\install.ps1 -InitRepo "E:\path\to\your-repo" -WithPrTemplate
```

### macOS / Linux (Manual Copy)
```bash
mkdir -p ~/.gemini/config/plugins
cp -r plugins/graphify-workflow plugins/engineering-guardrails ~/.gemini/config/plugins/
```

---

## Verify Setup

Open a **new conversation** in Antigravity (using a fast model like Hydrogen/Flash) inside any Git repository and ask:

> *"List the active global rules from `graphify-workflow` and `engineering-guardrails` in your context, then run `git remote get-url origin` to identify this repository's `repository_id`."*

Expected result:
- Both `Graphify Workflow Rules` and `Engineering Guardrails` appear in context.
- The agent resolves `<owner>/<name>` from the active repository without referencing any unrelated repo.

---

## License

MIT — see [LICENSE](LICENSE).
