# Cut an LTS snapshot

Snapshot the current site when a major Caffeine release is on the horizon, so users pinned to the outgoing version (via the GHA's compiler pin) keep seeing a tour that matches their compiler.

## Architecture

One separate repo per LTS, each its own GH Pages deployment at `archive-<X-Y-Z>.caffeine-lang.run`. No version-switching logic in the live site — just a small link on `/tour` pointing at the latest archive. The snapshot is immutable because it lives in a separate repo that nothing pushes to.

Reference example: `Brickell-Research/archive-5-6-0-caffeine_lang_website` was cut on 2026-05-16 from `caffeine_lang_website@019b3e1` (the v5.6.0 release commit).

## Prerequisites

- `caffeine-lang.run` DNS managed in Vercel (apex + wildcard)
- Domain verified for `Brickell-Research` org (`_github-pages-challenge-brickell-research` TXT exists)
- Push access to the org

## Steps

Let `V=5-6-0` (or whichever version, dashed). Always cut from a clean release commit on `main`.

### 1. Create empty repo on GitHub

`Brickell-Research/archive-$V-caffeine_lang_website`, public, no template.

### 2. Snapshot the current tree

```bash
cd ~/Desktop/BrickellResearch/caffeine_lang_website
git checkout main && git pull
mkdir ../archive-$V-caffeine_lang_website
cd ../archive-$V-caffeine_lang_website
git init -b main
git remote add origin git@github.com:Brickell-Research/archive-$V-caffeine_lang_website.git
git archive --remote=../caffeine_lang_website HEAD | tar -x
git add . && git commit -m "Snapshot caffeine_lang_website at v$V"
```

### 3. Point CNAME files at the subdomain

Edit both `docs/CNAME` and `static/CNAME` to `archive-$V.caffeine-lang.run`.

### 4. Redirect non-tour links to the live site

- `src/components/header.gleam`: logo + Home/Tools/Blog hrefs → `https://caffeine-lang.run/...`. Leave Tour as `/tour`.
- `src/pages/blog.gleam` list view: post hrefs → `https://caffeine-lang.run/blog/<slug>`.

Tour lesson content, asset paths (`/images`, `/css`, `/js`), and external links stay as-is.

### 5. Build, commit, push

```bash
gleam format src
gleam run -m build
git add -A
git commit -m "Redirect non-tour links to caffeine-lang.run"
git push -u origin main
```

### 6. Add DNS in Vercel

Domains → `caffeine-lang.run` → Add Record:
- Type `CNAME`, Name `archive-$V`, Value `brickell-research.github.io`, TTL `60`.

Verify before continuing: `dig archive-$V.caffeine-lang.run` should resolve to the GH Pages IPs.

### 7. Enable Pages via API

```bash
gh api -X PUT repos/Brickell-Research/archive-$V-caffeine_lang_website/pages \
  -f 'cname=archive-'$V'.caffeine-lang.run' \
  -f 'source[branch]=main' \
  -f 'source[path]=/docs'
```

Wait 5-15 min for cert. Poll:

```bash
gh api repos/Brickell-Research/archive-$V-caffeine_lang_website/pages \
  --jq '{status, cert: .https_certificate.state}'
```

Cert state `approved` + build status `built` = live.

### 8. Update main site's archive link

In `src/pages/tour.gleam`, point the `archive-link` `<a>` at the new subdomain. Build, commit, push to this repo.

## Gotchas

- **Don't set the custom domain via the GH UI before setting source to `/docs`.** GH writes the CNAME file to wherever the current source root is. If source is still `/`, you get a stale root `CNAME` that the `/docs` config ignores. Delete it if you hit this.
- **First build often stalls.** If `updated_at` hasn't moved 5 min after the initial `building`, trigger a fresh build: `gh api -X POST repos/.../pages/builds`. The stuck one will error out, the new one will succeed.
- **Wildcard ALIAS hides DNS failures.** `*.caffeine-lang.run` is aliased to Vercel; if the specific CNAME is missing, the subdomain silently routes to Vercel with a confusing response instead of an obvious DNS failure. Always confirm the specific record with `dig`.
- **`gleam format` will rewrite multi-line argument styles** after step 4 edits. Run it before committing or CI's format check will reject.
