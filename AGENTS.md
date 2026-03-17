# Repository Guidelines

## Project Structure & Module Organization
This repository is a wrapper around the main package in `easeim-mcp-server/`.

- `easeim-mcp-server/src/`: MCP server runtime code (`server.ts`, tool handlers, search/intelligence modules).
- `easeim-mcp-server/scripts/`: index and shard generation scripts (run with `tsx`).
- `easeim-mcp-server/tests/` and `easeim-mcp-server/test-*.ts`: script-style validation and benchmark files.
- `easeim-mcp-server/data/`: generated indexes/shards used at runtime.
- `raw-materials/`: upstream source/docs inputs for index generation.
- Top-level `package.json`: monorepo wrapper entry and `prepare` bootstrap.

## Build, Test, and Development Commands
Run commands from the repository root unless noted.

- `npm run prepare`: installs deps and builds `easeim-mcp-server`.
- `cd easeim-mcp-server && npm run build`: compile TypeScript to `dist/`.
- `cd easeim-mcp-server && npm run watch`: incremental TypeScript build.
- `cd easeim-mcp-server && npm run generate-all`: regenerate all search/config/template indexes.
- `cd easeim-mcp-server && npx tsx tests/test-search-suggester.ts`: run a targeted test script.
- `cd easeim-mcp-server && npx tsx tests/benchmark-sharded-search.ts`: run search performance benchmark.

## Coding Style & Naming Conventions
- Language: TypeScript (ESM, strict mode via `tsconfig.json`).
- Indentation: 2 spaces; keep semicolons and single quotes consistent with existing code.
- Imports in `.ts` files should use `.js` suffixes (Node16 ESM compatibility).
- Naming: `PascalCase` for classes/types and major modules (`SearchSuggester.ts`), `camelCase` for functions/variables, `UPPER_SNAKE_CASE` for constants.
- Keep modules focused by domain (`search/`, `intelligence/`, `assist/`, `tools/`, `utils/`).

## Testing Guidelines
- No centralized test runner is configured; tests are executable scripts.
- Prefer `test-*.ts` for behavior checks and `benchmark-*.ts` for performance checks.
- Run affected scripts before opening a PR; include command + key output in PR description.
- When changing indexing logic, rerun related `generate-*` scripts and validate search behavior.

## Commit & Pull Request Guidelines
- Follow concise, imperative commit subjects; prefer Conventional Commit style where possible (`fix: ...`, `chore: ...`), which matches existing history.
- Keep commits scoped (logic vs generated data changes should be easy to review).
- PRs should include:
  - What changed and why.
  - Related issue/task link (if any).
  - Reproduction/verification commands executed.
  - Notes on regenerated artifacts under `easeim-mcp-server/data/`.
