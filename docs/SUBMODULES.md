# Submodules (moved from CLAUDE.md, 2026-11-21)

`game-studio` is the master repo. The submodules:

- `game-factory/`
- `apps/game-block-fall`, `apps/game-block-puzzle`, `apps/game-wingy`
- the five new apps: `apps/game-craft-preteen` = Craft Scout, `apps/game-craft-lowteen` = Craft Ranger,
  `apps/game-craft_highteen` = Craft Champion, `apps/game-mind-1` = Mind Ember, `apps/game-mind-9` = Mind Presto
  (see `docs/PLAN-new-apps.md`)
- `games-web/` (`ya-spark/games-web`, the web deploy repo; PUBLIC since 2026-11-15, so it must never hold secrets,
  content packs, store or private app code: only the thin web shells, `games.yaml`, scripts and the catalog page;
  see `docs/DEPLOY-TO-VPS-AS-WEB.md`)
- `game-content/` (private repo `ya-spark/game-content`: packs, topics, price tiers, publish and product-sync workflows;
  see `docs/issue-drafts/09-content-repo.md`)
- `public/` (privacy policy site, GitHub Pages from `ya-spark/public`; one policy per game at `<game>/privacy.md`,
  kept in sync with each game's `store/google-play/privacy_policy.md`; the repo must stay public)
