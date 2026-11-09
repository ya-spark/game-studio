# [new-game] game-content: the content repo, validation, publishing and product sync (issue 09)

**Repo:** ya-spark/game-content (private; the owner creates it empty, then it is added to game-studio as a submodule `content/`). **Depends on:** 1A, 1B, 1D.

## Goal
One private repo for all learning content, separate from code: sources, built packs, topics, price tiers, the app catalogue, and the workflows that validate, publish and create Play products.

## Scope
- **Layout:** `packs/<pack_id>/` (CSV source, built pack JSON, ids file, assets), `topics.yaml`, `price_tiers.yaml`, `catalogue.yaml` (the five apps: id, package name, which year ranges and subjects they use), `README.md` and `docs/`.
- **CI:** on every content change, run the 1A validator and pool report against `topics.yaml`; docs-only commits skip CI. The validator tool comes from game-factory (fetched with a read token or vendored; the run decides and documents the choice).
- **`publish` workflow:** validate, build the per-app indexes, sign when `CONTENT_SIGNING_KEY` is set (optional until the owner adds a key), and upload the files over SSH to the Hostinger server's content folder (served by Caddy at `content.activemindcraft.com/v1/`). The SSH key is a GitHub secret, restricted to the content folder. Manual start and on push to `main`.
- **`sync-products` workflow (manual start only):** reads the catalogue and manifests and creates or updates every pack's one-time product through the Play Developer API, for the right app, using the `PLAY_SERVICE_ACCOUNT_JSON` secret. It never runs from an overnight `@claude` run. A dry-run mode prints what would change.
- **Docs:** how to add a pack, how to publish, how to add a new app to the catalogue, and the owner steps (create the repo, add secrets, give the service account access to each app).

## Needs from the owner
Create the empty repo, add the SSH and service-account secrets, set the price tiers, and add each app to the service account's permissions when the app exists in Play Console.

## Out of scope
Writing the real content (the C issues), real price points, any Cloudflare setup.
