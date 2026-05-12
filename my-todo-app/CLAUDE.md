# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

The `my-todo-app/` directory is currently empty. No scaffold, package.json, or Supabase config exists yet. Treat the first task as bootstrapping the project (e.g., `npx create-next-app@latest .`) rather than searching for existing code.

## Product scope

Single-user (1인용) personal todo app. There is no multi-tenant logic, no sharing, and no team features — keep auth, schema, and UI flows simple accordingly. Required features:

- **Task CRUD** — create, read, update, delete tasks.
- **Due dates (마감일)** — each task can have a deadline; the UI should make overdue / upcoming state visible.
- **Tag classification (태그 분류)** — tasks can be grouped/filtered by user-defined tags.
- **Widget** — a compact embeddable view of tasks (e.g., desktop widget, browser-extension popup, or a standalone `/widget` route). The exact widget surface has not been chosen — confirm with the user before committing to an approach.

## Stack

- **Next.js** (App Router unless the user requests Pages Router) — frontend and API routes.
- **Supabase** — Postgres for tasks/tags, Supabase Auth for the single user, Realtime optional for live updates.

Because this is a 1인용 app, Row Level Security can be scoped to a single `auth.uid()` owner per row. Don't build schema as if multiple users will collaborate on the same task.

## Coding rules (must follow)

1. **TypeScript only.** No plain `.js`/`.jsx` source files. Do not introduce `// @ts-nocheck`, `// @ts-ignore`, or `any` to silence errors — fix the type. `strict` must stay on in `tsconfig.json`.
2. **Server Components by default.** A file is a Server Component unless it begins with `"use client"` on the first line. Only mark a component `"use client"` when it actually needs browser-only APIs, state, or event handlers — and keep client boundaries as small as possible (lift state down, not up).
3. **Supabase only via `lib/`.** All Supabase calls go through helpers in `lib/` (e.g., `lib/supabase/server.ts`, `lib/supabase/client.ts`, plus feature-level data helpers like `lib/tasks.ts`). Components, route handlers, and server actions must import from `lib/`, never call `createClient` or `.from(...)` inline.
4. **Tests first (TDD).** Write a failing test before writing the implementation for any new behavior — task CRUD, due-date logic, tag filtering, widget rendering, etc. A PR that adds behavior without a preceding/accompanying test is incomplete.
5. **Components ≤ 50 lines.** Each component file stays within 50 lines (excluding imports and `"use client"` directive). When a component grows past that, extract child components or move logic into a `lib/` helper or custom hook — do not flatten by removing whitespace.

## Conventions to follow once code exists

- Keep Supabase keys out of the client bundle: `SUPABASE_URL` and `SUPABASE_ANON_KEY` go in `.env.local`; the `service_role` key must only be used in server-side code (route handlers, server components, server actions).
- Use the Supabase JS client (`@supabase/supabase-js` or `@supabase/ssr` for App Router) — do not hand-roll REST calls.
- Tasks and tags are the two core entities; a join table (e.g., `task_tags`) is preferred over an array column so filtering by tag stays indexable.

## Repo context

This project lives inside a larger directory `준혁의_ai회사/` that contains unrelated folders (`개발`, `마케팅`, `운영`, `권한_실습`) and an `auto-sync.sh` script at the parent level. Only operate inside `my-todo-app/` unless the user explicitly asks otherwise.
