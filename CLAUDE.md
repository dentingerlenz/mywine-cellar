# CLAUDE.md — My Wine Cellar (v2)

Wein-Keller-App (privater, geteilter Familienkeller). Ursprünglich mit Lovable
gebaut, dann sauber als **v2** neu aufgebaut. Stack: **Vite + React 18 + TypeScript
+ shadcn/ui + Tailwind + React Query + Supabase** (Auth, Postgres, Storage, Edge
Functions). Sprache im UI: Englisch. Nutzer ist **kein Coder** — Erklärungen einfach
halten, Klick-Anleitungen für Dashboard-Schritte geben.

## Wo die Details stehen
- **`docs/REBUILD_PLAN.md`** — der große Neuaufbau-Plan (Phasen 0–9), Schema-DDL,
  Feature-Backlog (Anhang C), Umsetzungs-Log (Anhang D). **Vor Rebuild-Arbeit lesen.**
- **`.claude/plans/bevor-mit-phase-6-*.md`** — zuletzt: Go-Live-Rollout-Plan.
- Auto-Memory (`~/.claude/projects/.../memory/rebuild-decisions.md`) — laufendes
  Entscheidungs-/Status-Log über Sessions hinweg.

## Architektur
- Feature-Ordner unter **`src/features/`** (auth, cellar, wines, wine-form,
  geography, colours, people, history, import, settings). Kein `src/pages` mehr
  (bis auf NotFound). Datenlayer je Feature: `queries.ts` (React-Query-Hooks +
  supabase-Aufrufe), Query-Keys zentral in `src/lib/queryKeys.ts`.
- Domänenmodell + Zod-Schema + Helfer: **`src/features/wines/model.ts`**
  (`vintageDisplay`, `dosageDisplay`, `monthsOnLees`, `parseVintageInput`,
  `parseDosageInput`, `findDuplicates`, …).
- **Geteilter Keller**: `cellars` + `cellar_members` (1 Keller pro User, `unique
  (user_id)`). RLS überall über `current_cellar_id()` (SECURITY DEFINER Helper),
  **nicht** `auth.uid() = user_id`. Onboarding = Keller erstellen (`create_cellar`
  RPC) oder beitreten (`join_cellar` RPC, Invite-Code). CellarGate zeigt Onboarding,
  bis Mitgliedschaft existiert.
- **Weinart-spezifisch**: `wine_colours.kind` (still/sparkling/sweet_fortified)
  steuert die Formularfelder. Schaumwein: NV-Schalter, `base_vintage`,
  `dosage_level`/`dosage_gl`, `tirage_date`/`disgorgement_date` (Monat/Jahr als
  date, Tag=01) + „months on lees". Süß/Likör: `aging_indication` statt Jahrgang.
  `vintage` ist **int**. Zusätzlich `classification` (AOC/DOCG/VDP…) und `location`
  (Freitext-Ort, wenn keine offizielle Appellation).
- **Geografie**: globale Referenztabellen `countries/regions/sub_regions/appellations`
  (4-Ebenen, FKs an `wines`). Quelle = **`data/geography/*.json`** (1 Datei/Land),
  kompiliert per `npm run geo:build` → `supabase/seed.sql` + `COVERAGE.md`. Aktuell
  51 Länder / ~884 Appellationen. **Vollständige AOC-Abdeckung = Phase 7 (offen).**

## Produktion / Hosting (WICHTIG)
- **Supabase-Projekt (Prod): `czmjxsojbomkqtluzhru`** — dem Nutzer gehörend, EU.
  Werte in `.env` (nur der öffentliche Publishable-Key, durch RLS geschützt — ok
  committet). **Das alte `yacrrwyvrswssqurfhun` ist Lovable Cloud → kein Zugriff,
  nicht mehr verwenden.**
- **Frontend live: https://mywine-cellar.vercel.app** (Vercel, auto-deploy bei Push
  auf `main`). Env-Vars sind im Vercel-Dashboard gesetzt.
- **GitHub: `github.com/dentingerlenz/mywine-cellar`** — `main` = v2-Neuaufbau;
  `lovable-v1-archive` = die alten Lovable-Commits (nicht löschen).
- **Reale Nutzer**: dentingerlenz80@gmail.com (owner) + manonfutura@gmail.com
  (member) teilen sich Keller `8c37262d-…` mit den migrierten 316 Weinen.

## Secrets (NIE committen / in Dateien schreiben)
- **DB-Passwort / Connection-String** und **service_role-Key**: kommen aus dem
  Supabase-Dashboard (Project Settings → Database bzw. API), nur einmalig als
  Env-Var für einen Befehl nutzen.
- **GitHub-Push** braucht einen vom Nutzer erstellten **Personal Access Token**
  (fine-grained, Contents:write auf dieses Repo). `psql`/`gh`/SSH sind auf dem
  Rechner NICHT installiert. Push-Muster (Token nur ephemer, nicht speichern):
  ```
  GIT_TOKEN=<pat> git -c credential.helper= \
    -c credential.helper='!f() { echo username=dentingerlenz; echo "password=$GIT_TOKEN"; }; f' \
    push origin main
  ```

## Lokale Entwicklung
- **Supabase-CLI** = `node_modules/.bin/supabase` (devDependency). **Docker** unter
  PATH `/Applications/Docker.app/Contents/Resources/bin`. Node ist v19 (kein
  natives WebSocket → Scripts nutzen `fetch`/PostgREST statt supabase-js Realtime).
- `.env.local` (gitignored) zeigt Dev auf den **lokalen Docker-Stack**; `.env` auf
  Prod. Zum Testen gegen Prod: `.env.local` temporär wegbenennen.
- Ablauf: `supabase start` → `supabase db reset` (wendet Migrationen + seed.sql an)
  → `supabase gen types typescript --local > src/integrations/supabase/types.ts`.
- Lokaler Login: manuell angelegte `auth.users`-Zeilen brauchen leere Token-Felder
  (`confirmation_token=''` etc.), sonst 500 bei GoTrue-Login.

## Schema-Änderungen (jetzt, da Prod live ist)
- Die Baseline `supabase/migrations/20260707090000_v2_baseline.sql` ist **deployed**.
  Neue Schema-Änderungen deshalb als **NEUE Migrationsdatei** (nicht Baseline editieren!),
  dann `supabase db push --db-url "<direct-connection-uri>" --include-all` gegen Prod.
  (Die pgdelta-Cache-Warnung der CLI ist harmlos.)

## Datenmigration
- `npm run migrate:v1` (`scripts/migrate-v1-data.js`) migriert `backup/*.csv` →
  v2-Schema. Idempotent (Upsert auf Original-UUIDs). `scripts/migrate-overrides.json`
  = manuelle Tippfehler-/Geo-Korrekturen. Env: `SUPABASE_URL`,
  `SUPABASE_SERVICE_ROLE_KEY`, optional `MAIN_USER_ID` (sonst aus profiles.csv).
  **Live-Lauf braucht einen zuerst per App registrierten echten User** (auth.users
  darf nicht leer sein) → dessen ID als `MAIN_USER_ID`.

## Qualitäts-Gates (vor jedem Commit)
`npx tsc --noEmit -p tsconfig.app.json` (0 Fehler) · `npm run lint` (0 Fehler) ·
`npm run build` · `npm test`. Commit-Messages auf Englisch, pro logischer Einheit.

## Bekannte offene Punkte
- **KI-Etiketten-Scan** nutzt noch die alte, kaputte Edge Function
  (`supabase/functions/claude-assistant`: ungültige Modell-ID, Env `cave_key`, keine
  Auth) → wirft Fehler bis **Phase 6** (Edge Function v2 + Sommelier V7 + Trinkfenster
  V8). Model-IDs/API-Doku vor Umsetzung via `claude-api`-Skill prüfen.
- 3 Weine (GR/HU/CY) haben leeres Regionsfeld (Datenfehler in Originaldaten:
  Produzentenname/Ländercode statt Ort) — in der App manuell korrigierbar.
- Offen laut Plan: Phase 6 (KI), Phase 7 (Geo-Vollausbau), Phase 8 (Export V5,
  Statistik V10, Tests), Phase 9 (PWA V4). Verworfene Features: V2, V9, V11–V13.

## Fallstricke (aus echten Bugs gelernt)
- Abfragen auf `cellar_members` liefern via RLS **alle** Mitglieder des eigenen
  Kellers → bei „nur eigene Zeile" immer `.eq("user_id", …)` + `.maybeSingle()`
  (sonst Absturz sobald der Keller >1 Mitglied hat).
