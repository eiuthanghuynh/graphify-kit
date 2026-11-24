## 1. Summary & Intent (Why)

- **Type:** `feat` | `fix` | `refactor` | `perf` | `chore` | `docs`
- **Scope(s):** <!-- e.g., core-auth, core-audit, billing, api, frontend-core, infra -->
- **Refs / Issue / Follow-up:** <!-- e.g., Closes #123, Refs #120, Supersedes #118 -->

**What changed & Why (Business Rule / Goal):**
<!-- 1-3 sentences explaining the intent behind this PR so future `git blame` / `gh pr view` readers understand why the code exists. -->

**Root Cause (required for `fix` / `refactor`):**
<!-- What underlying bug, library behavior, or architectural constraint triggered this change? -->

**Design Decisions & Invariants (Do Not Break):**
<!-- Key trade-offs or constraints future editors must preserve (e.g., "Keep X synced via root CSS @property; do not add per-component color transitions"). -->

---

## 2. Commit & Change Map (Blame Anchors)

<!-- Keep commits atomic (`type(scope): concise summary` + why in commit body). If this PR has noisy fixup commits, Squash on merge so this PR description becomes the canonical commit message. -->

| Commit (`short SHA`) | Scope / Layer | Key Files / Symbols Changed | Change & Reason |
| :--- | :--- | :--- | :--- |
| `<sha>` | `backend` / `frontend` / `db` | `path/to/File`, `Symbol` | Why this unit changed |

### Cross-Cutting Impact
- **Database / Migrations:** `None` <!-- or list migration files + rollback/forward-fix note -->
- **API / DTO / Env Config Changes:** `None` <!-- or list endpoints, DTO fields, new env vars -->
- **Behavioral / Breaking Changes:** `None` <!-- or describe caller impact -->

---

## 3. Verification Evidence

- [ ] **Backend tests:** <!-- e.g., `./mvnw test` -> PASS -->
- [ ] **Frontend tests & build:** <!-- e.g., `npm test` -> PASS; `npm run build` -> PASS -->
- [ ] **Live runtime / Browser check** *(required for UI/CSS/Theme/Layout/Docker changes)*: <!-- e.g., Verified Light/Dark & responsive viewports in live browser -->

---

## 4. Merge & Hygiene Checklist

- [ ] Commits follow Conventional Commits (`feat|fix|refactor|chore(scope): ...`) and noisy fixup commits are squashed before or on merge.
- [ ] No secrets, `.env` values, or local-only files committed (`git ls-files` clean).
- [ ] PR title is specific enough to locate via `git log --grep` or `gh pr list --search`.
