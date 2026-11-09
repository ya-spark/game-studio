# [change] factory: pack catalogue, price tiers, product ids and publishing tools (issue 1 of 4: 1D)

**Repo:** game-factory (`template/flutter-game-template`, tool and docs). **Depends on:** 1A and 1B. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first.

## Goal
Make selling many content packs sustainable: products are generated from the pack catalogue, never typed by hand. The content itself lives in a separate repo, `ya-spark/game-content` (issue 09).

## Decisions already made (owner, 2026-11-09)
Learning content is bought with **real money**, never coins. Each extra pack has its own Play product, created dynamically from its manifest; Full Unlock is one product per app. The content repo is separate from code and private. Hosting starts on the owner's Hostinger VPS behind Caddy (no extra cost), with the free Cloudflare proxy in front later if needed. One `sync-products` workflow in the content repo covers all five apps, using the existing Play service account (Manage store presence covers in-app products; the owner adds each app to the account's permissions once the app exists in Play Console).

## Scope
- **Price tiers:** a small table (for example 6 tiers, defined by the owner) in the catalogue; a pack picks a tier in its manifest and never a price.
- **Product-id rule:** `pack_<subject>_<year>_<slug>`; ids are permanent (a deleted id cannot be reused), documented.
- **Index `status`:** each pack entry is `draft` or `live`. The app (1B code) shows a `draft` pack as hidden or "coming soon" and a `live` one as buyable. Publishing order is: product exists in Play first, then the pack is marked `live`.
- **Product discovery in the app:** the app asks Play about the product ids named in the index at run time, so a new pack needs no app update; restore re-checks owned products against the index.
- **`content_cli products`:** reads the manifests and price tiers and writes (a) the product list as JSON for the sync workflow and (b) the Play Console one-time-products import CSV (the format already in `docs/play-import/`), as a fallback.
- **`content_cli publish`:** build, validate, optional sign, and a dry-run of the file list to upload. The upload itself is done by the content repo's workflow.
- **Year bundles:** the catalogue can define a bundle product that unlocks all packs of a year; the app treats it as owning each pack in it.
- **Docs:** `docs/PUBLISHING.md` (publishing a pack in five steps, product-id rules, price tiers, signing on and off, restore behaviour, the Play API note: the one-time products API, the app must exist in Play Console, and a first build with the billing permission may be needed before products can be created).

## Run discipline (the workflow stops a run after 100 turns, so work in small steps)
Do the work in small steps. After each step whose checks pass, commit and push it to `main` (and move the pin) so nothing is lost. If you are running low on turns, push what passes, then comment exactly what is done and what remains, so the owner can post the rest as a new issue.

## Acceptance
All template checks pass. Tests: product-id rule accepted and rejected cases, price tier lookup, `products` output (JSON and CSV) for sample packs and bundles, `status` handling in the app (draft hidden, live buyable), bundle ownership, restore against the index.

## Out of scope
The content repo and its workflows (issue 09), real price points, the platform-subscription source, any real signing key.
