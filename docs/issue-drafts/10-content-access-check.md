# [change] content access: purchase check on the VPS and Cloudflare in front (issue 10, later)

**Status:** draft, not posted. Needs the VPS ready and Cloudflare in front of `content.activemindcraft.com`. Decision: `docs/DECISIONS.md` ("Content hosting and access", owner, 2026-11-11).

## Goal
Only buyers can download a paid pack, without accounts and without storing personal data.

## Scope
- **Service** (small, Python or Node, in `game-content` under `server/`, deployed to the VPS by the owner): `POST /auth` takes `{app_id, product_id, purchase_token}`, verifies it with the Play Developer API (read-only purchase check, service-account key kept on the VPS), and returns a signed download link for that pack valid for about 10 minutes. No database of users; at most a short log without the token. Rate limited.
- **Caddy config:** serve the paid folder only with a valid signed link (`forward_auth` or an HMAC check); everything else static as today; the VPS accepts web traffic only from Cloudflare's IP ranges.
- **Cloudflare rules** (owner sets): cache bypass for the paid folder and `/auth`, rate limit on `/auth`.
- **App changes** (engine): for a purchased pack, request the link from `/auth`, then download; restore re-checks owned packs. The Play purchase decision stays on the device; the server only gates the file.
- **Docs:** setup steps for the owner (service, secrets, Caddy, Cloudflare), the privacy policy line, threat notes (what it does and does not stop).

## Out of scope
Accounts, analytics, any other server feature, a Cloudflare Worker, R2, GCP.
