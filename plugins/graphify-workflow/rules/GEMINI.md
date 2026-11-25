## Graphify Workflow Rules

1. **Graph-first & Bounded Scope (parent & subagents)**: Before running broad `grep` or reading multiple files to understand architecture, symbol definitions, callers, tests, or change impact — including during `/writing-plans`, UI/CSS/design critiques (`/impeccable critique`), and solo refactors — query Graphify first. Reserve raw `read_file` / text search for literal strings, config values, unindexed files, or targeted line ranges after Graphify locates them. Never read the same file repeatedly without checking Graphify or a diff first, and **stop expanding once the requested symbols or questions are answered** (do not chase unrequested subclasses/implementations).
2. **Graphify Cloud MCP (`graphify` server) — Direct Call Cheat-Sheet**:
   - Call the tools below directly using this cheat-sheet without spending a turn reading `.json` schema files (read a schema file only if calling an unfamiliar tool not listed here).
   - Always pass `ServerName: "graphify"` and `repository_id` as `<owner>/<name>` from `git remote get-url origin` (e.g. `owner/repo`).
   - Use exact parameter names (do NOT pass `id` or `node_id`):
     - Locate symbol definition -> `graphify_find(repository_id, term)`
     - Symbol details & neighbors -> `graphify_node(repository_id, symbol)`
     - Who calls X -> `graphify_callers(repository_id, symbol)`
     - Change impact -> `graphify_impact(repository_id, symbol, include_risk=true)`
     - Related tests -> `graphify_tests_for(repository_id, symbol)` or `(repository_id, file)`
     - File imports/dependents -> `graphify_file_neighbors(repository_id, file)` / `graphify_imports_exports(repository_id, file)`
     - Execution path -> `graphify_trace(repository_id, source, target)`
     - Broad behavior/architecture -> `query_graph(repository_id, question, skeleton=true)` first to locate files cheaply
     - Cross-session workspace notes -> `recall` / `remember`
3. **Freshness & Sync Policy (Local-first while coding, Push on Clean Task PASS)**:
   - For quick local lookups when `graphify-out/graph.json` is present and current, query it **only** via the official CLI (`graphify query "<question>"`, `graphify explain "<node_id>"`, `graphify path "<A>" "<B>"`) in 1 turn instead of running a multi-turn Cloud freshness handshake. **Never write ad-hoc Python/JS scripts to parse `graphify-out/graph.json` manually** (NetworkX node-link JSON uses `links`, not `edges`, so custom parsers silently return empty results).
   - When using Cloud MCP, compare the returned `commitSha` against `git rev-parse HEAD`. If equal, trust Cloud MCP.
   - When scaffolding a **brand-new code directory/module** (e.g., a new `web/` or service folder) or running Inline (`executing-plans`) before pushing, initialize/refresh the local AST graph right after scaffolding and before Final Review (`graphify update .` or `graphify .`, AST-only, zero API cost; ensure `graphify-out/` is in `.git/info/exclude`) so later tasks and reviewers can query `graphify-out/graph.json` instead of crawling raw files.
   - While actively implementing or in a fix loop (unpushed commits / uncommitted edits), do **not** rely on stale Cloud MCP and do **not** push half-baked fix commits just to refresh Cloud: run `graphify update .` (AST-only, zero API cost) after code edits and query local `graphify-out/graph.json`, reading only targeted modified lines.
   - Push to the feature branch **after each task passes review cleanly** so Graphify Cloud re-indexes the verified state for the next task (squash noisy commits on PR merge if desired).
   - Read `graphify-out/GRAPH_REPORT.md` only for broad architecture review when targeted queries are insufficient.
4. **Subagents**: When delegating codebase exploration or review to a subagent, include `repository_id`, exact MCP parameter names (`symbol` / `question`), and local `graphify-out/` fallback instructions in its prompt or system prompt.
