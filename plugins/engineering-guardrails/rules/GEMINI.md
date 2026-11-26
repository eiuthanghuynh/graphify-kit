## Engineering Guardrails

1. **Execution Mode Gate**: When a multi-task implementation plan exists and the user has not explicitly specified how to execute it, ask once to confirm Inline (`executing-plans`) vs `/subagent-driven-development` before writing any code.
2. **Visual & Runtime Browser Gate (Conditional)**:
   - In UI/Frontend plans, run a live `browser` verifier immediately after foundational UI tasks (Theme Tokens / Design System, App Shell / Layout) rather than deferring visual checks to the final task.
   - For any CSS, Theme, Layout, Contrast, or Animation refactor (including solo work), verify computed styles and real rendered behavior in a live `browser` subagent before claiming Done — never rely solely on `jsdom` tests or static CSS inspection.
3. **Solo Architectural Pre-Check**:
   - Before coding a solo refactor touching cross-cutting architecture (theme engine, auth flow, state sync, DB schema, framework styling), inspect the underlying library mechanism first (e.g., AntD `cssVar`/specificity, framework lifecycle) and confirm 2-3 core UX/technical criteria before the first commit.
   - Fast-path small 1-2 file bugfixes without unnecessary interview overhead.
4. **SDD & Cost Discipline**:
   - Always pass an explicit `Model` tier to `invoke_subagent` (never rely on ambiguous `inherit`): default `flash` for standard Implementers and Task Reviewers; escalate to `pro` for **Final Whole-Branch Review**, core architecture tasks, or fix loops at round 3+.
   - Reuse the active task reviewer via `send_message` for fix-round re-reviews instead of spawning a fresh reviewer per round.
   - Always generate a `review-package` diff file (excluding lockfiles) for Task Reviewers and **Final Whole-Branch Review** — including after Inline (`executing-plans`) execution — instead of telling reviewers to read every changed source file individually.
   - **Targeted-First Test & Build Cadence**: During mid-plan tasks and single-file fix steps, run only the targeted tests for changed modules (plus `tsc --noEmit` / `-Dtest=...` when types/Java changed) — do **not** run the full test suite or production bundler (`vite build` / full `mvn test`) on every task or micro-edit. Reserve the full suite + production build for **once** before generating `review-package.diff` (and **once** after a Final Review fix pass), reporting the exact scope honestly.
   - Do not poll `manage_subagents(Action="list")` while waiting on running children — rely on reactive wakeup.
   - After any context compaction (`CHECKPOINT`), re-read the active progress ledger and `references/fix-loop.md` before entering a fix round.
5. **Clean GitHub Repo & Branch Isolation**:
   - Keep all AI agent tooling, prompts, plans, and local graphs (`docs/superpowers/`, `.agents/`, `.agent/`, `.gemini/`, `.claude/`, `.cursor/`, `.windsurf/`, `.superpowers/`, `graphify-out/`, `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `PRODUCT.md`, `DESIGN.md`, `.impeccable/`) in **`.git/info/exclude`** — never add AI paths to `.gitignore` unless explicitly requested. Run `git ls-files` against those paths before every `git push`.
   - Prefer a dedicated feature branch for repositories using Docker Compose or fixed local ports; use `git worktree` when parallelizing branches or preserving dirty working-tree changes.
