# Site Standard

The standard for building any website in a repository that uses the kit:
its framework, conventions, hosting, and the rules for the users and data
it takes on as it grows. Read it in full before creating a site, before
adding a feature that changes which part applies, and before calling site
work done. How the site looks is in `design.md`, beside this file, and a
site follows both.

## Purpose

A site starts as a **static site**: plain HyperText Markup Language (HTML),
one Cascading Style Sheets (CSS) file and one vanilla JavaScript (JS) file,
built by a tool and shipped with no framework runtime, backend, database,
authentication or analytics, its source kept in Git and its built output
served by Cloudflare Pages, which hosts it free. Part 1 is its standard,
written so the hosting layer can later be replaced by a self-hosted service
without rewriting the site.

A site that needs more, such as user accounts, uploads, stored data or
automated email, becomes a **full featured site**. Part 2 adds the rules
for it on top of Part 1, and the hosting line below says when it must leave
Cloudflare's free plan.

It is written for two readers: a developer starting or maintaining a site,
and an AI coding session that reads it as its instructions and creates a
new site by working through the New site checklist from top to bottom. It
deliberately sets no development process: repository naming, visibility,
branching, review, continuous integration (CI) and licensing belong to the
process that governs each repository, which in a repository using the kit
is the session protocol. Without it, every new site rediscovers the same
failures by hand: pages with empty titles, development servers that
disagree with production, addresses that redirect when they should answer,
and a hosting setting that silently stops the site serving files.

## Which part applies

- **SITE-1.** Every site MUST follow Part 1, and its `CLAUDE.md` MUST say
  which part it is built to, under its opening lines.
- **SITE-2.** A site becomes full featured, and MUST then also follow
  Part 2, the moment it adds any of: user signup or sign in, a form whose
  submissions are stored or emailed by the site, user uploads, email sent
  to a list, analytics, or a server-side function of any kind. Reason: each
  of these takes in visitors' data, which Part 1 never does.
- **SITE-3.** The questions Part 2 asks, such as the mailing address, the
  content policy's facts and the copyright agent, MUST NOT be asked of a
  static site. Reason: a static site collects nothing they protect.

### The hosting line

- **HOST-1.** Before a site adds any feature beyond Part 1, the session
  MUST read Cloudflare's current pricing and limits pages for every
  Cloudflare product the feature needs, such as Pages Functions, Workers,
  KV, D1 or R2, and MUST NOT rely on memory of them. It records in the
  site's `CLAUDE.md`, under Deployment, each product, the free plan's limit
  that matters, the address it was read from and the date. Reason: the free
  plan changes, and a limit remembered wrong is a bill or an outage.
- **HOST-2.** When every feature and the expected load fit the free plan,
  the site stays on Cloudflare Pages, free, and no warning is given.
  Server-side code goes in Pages Functions under `functions/` at the
  repository root, never a `_worker.js` file, per CF-2.
- **HOST-3.** When a feature or the expected load does not fit the free
  plan, the session MUST stop before building it and warn the owner, in
  the reply's `Action needed:` line and as a numbered question: the site
  then needs either hosting of the owner's own or a paid Cloudflare plan,
  with what each would cost or require as far as it can be verified. The
  owner's choice is recorded under Deployment in the site's `CLAUDE.md`.
  Reason: moving off the free plan costs money or upkeep, which only the
  owner can agree to.
- **HOST-4.** A site hosted by the owner keeps Part 1's portability: the
  Self-hosted portability notes apply, and the host's settings are
  recorded in the site's `CLAUDE.md` under Deployment.

## Owner

The owner of a site built to this standard is the developer working in its
repository on behalf of the business or person that operates the site,
written `<owner>` throughout. Anyone working within such a repository has
the authority to apply this standard to it and to propose an amendment to
it, which goes to the kit.

## Access

Everything a person or a session needs before starting a site. No
credential is recorded here, and a static site built to this standard needs
none to build.

### Accounts
- **A Git host account** that can hold the repository where the static host can build from it. A personal account is enough; an organization account is not required. The Git host governs nothing in this standard, and the repository may move to a self-hosted Git service.
- **A Cloudflare account** with access to Workers and Pages, able to create a Pages project connected to the repository.
- **A registered domain,** written `<domain>` throughout. Its Domain Name System (DNS) zone stays with the registrar. Only the `www` record points at Cloudflare Pages, per Environments, previews, and custom domains below.

### Tools and versions
| Tool | Version | Where the version is set |
|---|---|---|
| Node.js | 24 | `.node-version` at the repository root, per PIN-1 |
| pnpm | one exact 10.x release, such as `10.33.0` | Root `package.json` `packageManager`, and the host's `PNPM_VERSION`, per PIN-2 |
| TypeScript | `~5.9.3` | Root `package.json`, development dependency |
| Vite | `^7.3.2` | `pnpm-workspace.yaml` catalog |
| vite-plugin-handlebars | `^2.0.0` | Site package `package.json` |
| `@types/node` | `^25.3.3` | `pnpm-workspace.yaml` catalog |
| Git | any current release | Not pinned |

The ranges are the ones the first sites built this way carried when this standard was written. They are a floor for a new site, not a ceiling, and are raised by amending this table.

**Why the tools are pinned.** The first sites built this way pinned neither Node.js nor pnpm, so each built on whatever its host image defaulted to, and the host has changed that default before. The Cloudflare Pages v3 build image defaults to Node.js 22 and a pnpm 10 release of its own choosing. For Node.js it reads a committed `.node-version` or `.nvmrc` file or a `NODE_VERSION` variable. For pnpm it reads only a `PNPM_VERSION` variable. It does not read the `engines` field and does not infer pnpm from the lockfile. Pinning both makes a local build, a preview and production use the same tools, and moves to another host unchanged.

- **PIN-1.** The repository root MUST hold `.node-version` containing `24`. Reason: the file is read by the host, by version managers on a developer's machine, and by most self-hosted builders, so one file pins all three.
- **PIN-2.** The root `package.json` MUST set `packageManager` to one exact pnpm release, such as `"pnpm@10.33.0"`, chosen as the current pnpm 10 release when the site is created. The host's `PNPM_VERSION` build variable MUST hold the same version. Reason: Corepack on a developer's machine reads `packageManager`, the host reads only `PNPM_VERSION`, and two different versions can resolve the same lockfile differently.

### Where the standard is read
The kit installs this standard into every repository that uses it, at `.claude/afk/standards/site.md`, and an update brings each change. A site's `CLAUDE.md` names the kit version it was last checked against, per the template in the Modification Map.

## Dependencies

This is a document, and nothing has to be running for it to be read. A site built to it depends on its Git host, its static host and its domain registrar, and the Deployment standard below keeps every host-specific setting in labeled subsections so that each can be replaced on its own. A full featured site also depends on whatever services Part 2 has it record.

## How to read the rules

Requirement keywords: **MUST** and **MUST NOT** are absolute, **SHOULD** and **SHOULD NOT** may be departed from only with the reason recorded in the site's `CLAUDE.md` under Gotchas, and **MAY** is optional. Every rule has an identifier so a review, a commit message or a site's `CLAUDE.md` can name it. Every rule is written so it can be checked by looking at the repository, its built output, or the deployed site.

Placeholders used throughout: `<site-name>` is the human name of the site, `<repo-name>` the repository name, `<domain>` the bare production domain without a scheme, `<project>` the Pages project name, `<owner>` the developer who owns the site, `<admin-contact>` the administrative mailbox of whoever operates the site, `<page>` a page's directory name, `<site-prefix>` a short lowercase prefix for the site's browser storage keys, `<brand-typeface>` the site's typeface, and `<font-file>` a typeface file name.

## Part 1: Static Site

The rules, in the order a site is built, then the New site checklist that creates a site, then the Pre-launch verification checklist that proves one is fit to go live, then the failures they prevent.

### Repository standard
**Not governed here.** Repository naming, visibility, the owning account, the branch model and branch protection, review, commit conventions, CI and licensing belong to whatever development process the repository follows. This standard sets none of them, so that it can be used by anyone, inside the business or outside it, alongside their own process.

- **REPO-1.** One site per repository. Reason: one Pages project builds one repository, and a second site in the same tree shares its deploys, its lockfile and its failures.
- **REPO-2.** The repository root MUST hold these files, and no configuration for a platform the site does not use:

```
CLAUDE.md
.node-version
package.json
pnpm-workspace.yaml
pnpm-lock.yaml
.npmrc
.gitignore
tsconfig.base.json
tsconfig.json
```

- **REPO-3.** The repository MUST NOT hold scaffolding that nothing uses: no unused application server, no empty database package, no component sandbox, no placeholder "hello" script package, no upload dump of attached files, and no configuration or agent memory directory belonging to a development platform the site no longer uses. Reason: each one costs lockfile size, install time, typecheck time and reviewer confusion, and every one observed was either unused or broken.
- **REPO-4.** Project knowledge MUST live in `CLAUDE.md` at the root, the site's `artifacts/web/README.md`, and `docs/`. Reason: one place to look, which a platform's private memory directory is not.

### Directory and file layout
The repository is a pnpm workspace and the site is one package in it, `@workspace/web` at `artifacts/web`. Reason for the fixed name: every site then shares one build command and one output directory, so the host settings and the checklists below never vary by site.

```
<repo-name>/
├── CLAUDE.md                  project instructions, from the template in the Modification Map
├── .node-version              24
├── package.json               workspace root: pnpm pin and guard, build, typecheck
├── pnpm-workspace.yaml        members, catalog, release age, build-script allowlist, overrides
├── pnpm-lock.yaml             committed, never deleted to re-resolve
├── .npmrc                     peer dependency settings
├── .gitignore                 dist, node_modules, build caches
├── tsconfig.base.json         shared compiler options
├── tsconfig.json              root, extends the base
├── docs/                      build spec and design assessments, never built
└── artifacts/
    └── web/                   the @workspace/web package, the site
        ├── README.md          layout, data files, commands, hosting notes
        ├── package.json       dev, build, serve, typecheck, and prebuild when needed
        ├── tsconfig.json      typechecks vite.config.ts
        ├── vite.config.ts     pages map, rollup inputs, cleanUrls(), handlebars
        ├── index.html         the home page, served at /
        ├── 404.html           the not-found page, stays at the root
        ├── <page>/index.html  one directory per page, served at /<page>/
        ├── scripts/           build-time fetch and validation, plain Node, optional
        ├── src/
        │   ├── partials/      head.html, header.html, footer.html, optional icons.html
        │   ├── css/           styles.css, plus <page>.css where a page earns it
        │   ├── js/            main.js
        │   └── data/          JSON sources of truth, optional
        └── public/            copied to the output root as is
            ├── _redirects
            ├── _headers
            ├── robots.txt
            ├── sitemap.xml
            ├── favicon.png
            ├── fonts/
            └── images/
```

Generated and never committed: `node_modules/`, `artifacts/web/dist/`, and any build cache under `artifacts/web/scripts/.cache/`.

- **LAYOUT-1.** Every page except the home page and the not-found page MUST be a directory holding `index.html`. Reason: the host then serves it at `/<page>/` with no rewrite rule.
- **LAYOUT-2.** `404.html` MUST sit at the package root, so it lands at the root of the output. Reason: static hosts look for the not-found page only there.
- **LAYOUT-3.** Partials MUST live in `artifacts/web/src/partials/` and every page MUST include `head`, `header` and `footer` from there. A block of markup repeated on two or more pages MUST be a partial.
- **LAYOUT-4.** Files under `docs/` and source images kept for reference MUST sit outside `artifacts/web/public/`. Reason: everything under `public/` is served.

### Build standard
**Framework or no framework.** Vite is the build tool and never a runtime. `vite-plugin-handlebars` inlines partials and injects per-page metadata at build time, and what ships is plain HTML, one shared stylesheet and one vanilla script.

- **BUILD-1.** No framework runtime MAY reach the browser. The site package MUST NOT depend on React, Vue, Svelte or any other component framework. Reason: a framework is weight and a moving part a static page does not need, and both observed sites ship none.
- **BUILD-2.** `vite.config.ts` MUST set `appType: "mpa"`. Reason: without it the development server falls back to the home page for every unknown path, so each extensionless route silently renders the home page in development while working in production.
- **BUILD-3.** Every page MUST be a named entry in `build.rollupOptions.input`, and `build.outDir` MUST be `dist/public` with `emptyOutDir: true`.
- **BUILD-4.** `vite.config.ts` MUST define a `cleanUrls()` plugin that rewrites `/<page>` and `/<page>/` to `/<page>/index.html`, registered on both `configureServer` and `configurePreviewServer`, whose route list names every directory-style page. Reason: development and preview then serve every page at the addresses production serves.
- **BUILD-5.** `PORT` and `BASE_PATH` MUST be optional, defaulting to `5173` and `/`. An explicitly set `PORT` that is not a positive number MAY throw. Reason: a configuration that throws on a missing variable builds only inside the platform that used to inject it, and it broke every build when that platform was removed.
- **BUILD-6.** The development and preview servers MUST bind `host: "0.0.0.0"` and MUST NOT bind `"::"`. Reason: IPv6 is not available in every container, and `"::"` fails there with `EAFNOSUPPORT`.
- **BUILD-7.** The site package MUST define these scripts, and `prebuild` whenever the site has a build-time fetch or a data file to validate:

```json
{
  "dev": "vite dev",
  "build": "vite build",
  "serve": "vite preview",
  "typecheck": "tsc -p tsconfig.json --noEmit"
}
```

- **BUILD-8.** The site package MUST carry a `tsconfig.json` that includes `vite.config.ts`, so the typecheck covers the file that holds the page inventory.
- **BUILD-9.** The root `package.json` MUST hold the `packageManager` pin from PIN-2, a `preinstall` guard that refuses any package manager but pnpm, a `build` script that typechecks and then builds every package, and a `typecheck` script that runs every package's typecheck. The exact contents are in the New site checklist.
- **BUILD-10.** The build MUST need no environment variable of its own to succeed. `PNPM_VERSION` on the host chooses a tool and is not read by the build.

**Build command and output directory.** Both are fixed by the package name:

```
pnpm --filter @workspace/web run build
artifacts/web/dist/public
```

**Dependency pinning.**

- **DEP-1.** `pnpm-lock.yaml` MUST be committed. A lockfile that will not install frozen MUST be pruned or updated in place and MUST NOT be deleted and re-resolved. Reason: a fresh resolve floats every caret range at once, and a bundled library that moves changes the shipped site with no edit to any source file.
- **DEP-2.** `pnpm-workspace.yaml` MUST set `minimumReleaseAge: 1440` and MUST NOT lower or remove it. `minimumReleaseAgeExclude` MUST be present and SHOULD be empty; a package MAY be added only as a temporary, commented exception and removed once its release is a day old. Reason: most malicious package releases are found and pulled within hours, so a day's delay is a cheap defense.
- **DEP-3.** Versions shared by more than one package MUST come from the workspace `catalog`, and the catalog MUST hold only entries some package uses.
- **DEP-4.** `onlyBuiltDependencies` MUST list only packages present in the dependency tree that need an install script, which for this stack is `esbuild`. Reason: an install script is arbitrary code run on the machine that installs, so each allowed entry is a standing permission.
- **DEP-5.** `autoInstallPeers: false` MUST be set in `pnpm-workspace.yaml`, with `auto-install-peers=false` and `strict-peer-dependencies=false` in `.npmrc`.
- **DEP-6.** `overrides` SHOULD remove every platform binary of `esbuild` and `rollup` except linux-x64, with a comment saying the build targets linux-x64 and that installing on another platform needs the matching lines removed. Reason: the host builds on linux-x64 and the excluded binaries are install weight; the cost is that installing on macOS, Windows or an ARM machine fails until those lines are relaxed.
- **DEP-7.** `overrides` SHOULD pin `esbuild` to one version across the tree, with a comment saying so. Reason: reproducible builds.
- **DEP-8.** A library the site's script uses MUST be an npm dependency bundled into `main.js` and MUST NOT be loaded from a content delivery network (CDN). Reason: the version is then pinned by the lockfile like every other dependency.

**Data.**

- **DATA-1.** A page that renders more than a handful of structurally identical blocks, such as cards, service lists, pricing tiers or portfolio entries, MUST read them from a JSON file in `artifacts/web/src/data/` and render them with `{{#each}}`. A fact shown on two pages, or on a page and in a document, MUST come from one JSON file both read. Reason: two copies of a fact drift, and nothing catches it.
- **DATA-2.** Data a page renders is passed into its handlebars context by a map in `vite.config.ts` keyed on the source file path, exactly like the `pages` map.
- **DATA-3.** A site with files in `src/data/` MUST have `artifacts/web/scripts/validate-data.mjs`, plain Node with no dependency, checking every data file for enum violations, duplicate identifiers, empty required fields and broken cross-references, and exiting non-zero on any failure. It MUST run as `prebuild` and SHOULD be runnable alone as `validate-data`. Reason: bad data then fails the build instead of shipping.
- **DATA-4.** External data that can be fetched at build time MUST be fetched at build time by a plain Node script in `artifacts/web/scripts/`, run as `prebuild`. Its output MUST be committed under `public/`, its cache MUST be gitignored, and on any error it MUST log a warning, leave the committed output untouched and exit 0. Reason: a third-party outage must not fail a deploy, and the committed output is the fallback.
- **DATA-5.** A site with both a build-time fetch and a validator SHOULD run the fetch first in the same `prebuild`, so the validator also checks what was fetched.
- **DATA-6.** Data MAY be fetched in the browser at runtime only when the source allows Cross-Origin Resource Sharing (CORS) and the page genuinely needs it live. A runtime fetch MUST have a committed fallback snapshot under `public/` that the page reads when the live fetch fails. Reason: a source that blocks CORS cannot be read from a browser at all, and a live source that is down must not leave the page empty.

### Content and asset conventions
The aim, ahead of every rule below, is a site that is fast, accessible and pleasing to look at without losing sight of what it is for. Current industry practice is followed where a rule here is silent. Search engine optimization (SEO) is taken into account and is never the goal: a change that raises a score at the cost of the site's look or its purpose is the wrong change.

**HTML.**

- **HTML-1.** Every page MUST open with `<!doctype html>` and `<html lang="en">`, include `{{> head}}` inside `<head>`, `{{> header}}` before `<main>` and `{{> footer}}` after it.
- **HTML-2.** Every page MUST use the landmarks `header`, `nav`, `main` and `footer`, and exactly one `h1`.
- **HTML-3.** Internal links MUST be root-relative and MUST end a directory page's address with a slash, such as `href="/<page>/"`, and MUST NOT end in `.html`. The home page is `href="/"`. Reason: Cloudflare Pages answers `/<page>` with a 308 redirect to `/<page>/`, so a link without the slash costs a redirect on every click.
- **HTML-4.** Copy MUST NOT contain an em dash or an en dash, in page text, in titles or in descriptions. Use a comma, colon, period, or the word "to". Copy SHOULD be American English.
- **HTML-5.** A page title MUST separate its parts with a vertical bar, as in `Services | <site-name>`.
- **HTML-6.** Content MUST NOT be invented. Every fact on a page comes from the site's build spec in `docs/` or from the owner; an unknown is left as one of the TODOs in the spec and raised with the owner, never filled with plausible text.

**CSS.**

- **CSS-1.** Shared styles MUST live in one file, `artifacts/web/src/css/styles.css`, linked from the head partial. A page MAY add `src/css/<page>.css` when its styles are substantial and used nowhere else. Pages MUST NOT carry inline `<style>` blocks.
- **CSS-2.** Colors and type families MUST be CSS custom properties declared in `:root`. A site with a light and a dark theme MUST override them under `html[data-theme="light"]` or `html[data-theme="dark"]`.
- **CSS-3.** Motion MUST be disabled under `@media (prefers-reduced-motion: reduce)`.
- **CSS-4.** Controls that only work with JavaScript, such as a collapsing mobile menu, MUST be hidden or collapsed only under a `.js` selector. Reason: with JavaScript off the class is never added, so the navigation stays visible and usable.

**JavaScript.**

- **JS-1.** The site MUST have one script, `artifacts/web/src/js/main.js`, loaded by the head partial as `<script type="module" src="/src/js/main.js"></script>`. Reason: a module script is deferred, so loading it from the head blocks nothing, and one include means a new page cannot forget it.
- **JS-2.** Every page MUST be readable and navigable with JavaScript disabled. The script MAY only enhance: a mobile menu toggle, a theme toggle, form submission with inline status, filters, and similar.
- **JS-3.** The head partial MUST run an inline script that adds the `js` class to `document.documentElement` before first paint.
- **JS-4.** A site with a theme toggle MUST read the saved theme from `localStorage` under the key `<site-prefix>-theme` in the same inline script and set `data-theme` on `<html>` before first paint. Reason: setting it later shows the wrong theme for a moment on every load.
- **JS-5.** Every `localStorage` read and write MUST be wrapped in `try` and `catch`. Reason: private browsing and blocked site data make the access throw, and an uncaught throw stops the rest of the script.
- **JS-6.** A feature for one page MUST do nothing, and log no error, on every other page.
- **JS-7.** A form MUST work as a plain HTML `POST` without JavaScript. A site with no backend posts to a third-party form service, and the script MAY enhance it with inline status.

**Images.**

- **IMG-1.** Images served by the site MUST live in `artifacts/web/public/images/`. Favicons MUST live at the root of `public/`.
- **IMG-2.** Every `<img>` MUST carry `alt`, `width` and `height`. Reason: the dimensions reserve space before the file loads, so the page does not jump.
- **IMG-3.** The social sharing image MUST be `public/images/og-banner.jpg` at 1200 by 630 pixels.
- **IMG-4.** There is no size limit and no required format. Every image SHOULD be kept intentionally small, sized close to the largest size it is displayed at, in a widely supported format that loads quickly: JPEG or WebP for photographs, PNG or SVG for logos and icons. Reason: images are usually most of a page's weight and the first thing a performance score measures.

**Fonts.**

- **FONT-1.** A site MUST serve its typefaces from its own origin: WOFF2 files in `artifacts/web/public/fonts/`, declared by `@font-face` in `styles.css` with `font-display: swap`, and the most used weight preloaded from the head partial. Reason: everything the page needs then comes from one origin, the files are pinned like every other dependency, and no third party sees the site's visitors.
- **FONT-2.** A site MUST NOT load a typeface, or anything else, from a font host such as Google Fonts, at build time from the browser or at run time. A typeface whose license allows self-hosting is downloaded once, its WOFF2 files committed under `public/fonts/`. Reason: every request to a font host tells a third party who visited, and the page then depends on an origin it does not control.

**Metadata.**

- **META-1.** `vite.config.ts` MUST hold one typed `pages` map, keyed on each page's source file path with a leading slash, such as `"/services/index.html"`. Each entry MUST give `title`, `description` and `canonical`, and MAY give boolean flags that mark the active navigation item. The map is the page inventory.
- **META-2.** The handlebars `context` function MUST return an empty object for a path missing from the map and MUST NOT fall back to another page's metadata. Reason: a missing key then shows as an empty `<title>` in the built output, which the verification checklist catches, where a fallback would hide it behind a plausible title.
- **META-3.** `canonical` MUST be a path: `/` for the home page, `/<page>/` with its trailing slash for a directory page, never ending in `.html`, and `null` for `404.html`. The canonical origin `https://www.<domain>`, the serving hostname per ENV-3, MUST be written once, as a constant in `vite.config.ts` passed into every page's context, and the head partial MUST build absolute addresses from it.
- **META-4.** When `canonical` is `null`, the head partial MUST omit both the canonical link and `og:url`. Reason: an error page answers with a 404 status and must never be indexed, so a canonical on it can only mislead a crawler.
- **META-5.** A canonical address MUST be one the static host answers with status 200, with no redirect on the way: the `www` hostname and a path with its trailing slash. Reason: search engines treat a canonical that redirects as a hint they may override.
- **META-6.** The head partial MUST emit the Open Graph tags `og:type`, `og:title`, `og:description`, `og:url` when there is a canonical, and `og:image`, plus `twitter:card` set to `summary_large_image` with matching `twitter:title`, `twitter:description` and `twitter:image`.

**Accessibility.**

- **A11Y-1.** The header partial MUST open with a skip link to `#main`, and `<main>` MUST carry `id="main"`.
- **A11Y-2.** The mobile menu toggle MUST be a `<button>` carrying `aria-expanded` and `aria-controls`, and the script MUST keep `aria-expanded` current.
- **A11Y-3.** The active navigation link MUST carry `aria-current="page"`, set from the `pages` map flags.
- **A11Y-4.** Every interactive element MUST show a visible keyboard focus ring.
- **A11Y-5.** Body text MUST reach a contrast ratio of at least 4.5 to 1 in every theme.
- **A11Y-6.** The layout MUST hold from 360 pixels wide upward.

**Performance and what does not belong.**

- **PERF-1.** A static site MUST NOT include analytics, cookie banners, chat widgets or newsletter signups. Adding any of them makes it a full featured site, per SITE-2, and Part 2 governs it.
- **PERF-2.** Built CSS and JS MUST be the hashed files Vite emits under `assets/`, and pages MUST reference the sources under `/src/` so Vite rewrites and hashes them.
- **PERF-3.** Every page SHOULD score 90 or higher, the range Lighthouse marks as good, in each of Performance, Accessibility, Best Practices and SEO, and 95 or higher in Accessibility. Reason: these are the industry's common yardstick and the observed build spec's accessibility floor; a lower score is a prompt to look, not a reason to strip the site's design.

### Configuration files
All of these live in `artifacts/web/public/` and are copied to the output root unchanged. `_redirects` and `_headers` are in the format Cloudflare Pages reads; Self-hosted portability notes says what another host needs.

**Redirects, `public/_redirects`.**

- **REDIR-1.** `_redirects` MUST exist, with a comment at its top saying it holds explicit redirects only.
- **REDIR-2.** Every rule MUST be one exact source path, one destination and the status `301`:

```
# Explicit 301 redirects for legacy URLs only.
# No wildcards: these must never catch static asset paths.
/<page>.html   /<page>/                 301
/old-path      /<page>/                 301
/elsewhere     https://<other-domain>/  301
```

- **REDIR-3.** `_redirects` MUST NOT contain a wildcard (`*`), a placeholder such as `:splat`, or a status `200` rewrite, and MUST NOT contain a catch-all such as `/* /index.html 200`. Reason: a wildcard eventually catches a static asset path and breaks the site, and a catch-all turns a multi-page site into a single page application (SPA) that answers every bad address with the home page instead of a 404.
- **REDIR-4.** Every address the site has ever published MUST keep working, by serving the page or by a 301 to it. A redirect MUST point at the final address in one hop, which for a directory page is `/<page>/` with its trailing slash. Reason: a destination without the slash is redirected a second time by the host.
- **REDIR-5.** A path whose capitalization differed on an earlier site MUST get its own explicit rule. The not-found page MAY also redirect a mixed-case path to its lowercase form with a small inline script. Reason: path matching is exact, and a script on the not-found page runs only after nothing else matched, so it can never intercept an asset.

**Not-found page, `404.html`.**

- **NOTFOUND-1.** `404.html` MUST have an entry in the `pages` map with `canonical: null`, MUST link back to the home page, and MUST NOT appear in `sitemap.xml`.

**Robots, `public/robots.txt`.**

- **ROBOTS-1.** It MUST read:

```
User-agent: *
Allow: /

Sitemap: https://www.<domain>/sitemap.xml
```

**Sitemap, `public/sitemap.xml`.**

- **SITEMAP-1.** It MUST list every indexable page by its canonical address, `https://www.<domain>` followed by the `canonical` path, so a directory page ends in a slash, and nothing else: no `404.html`, no page whose canonical points elsewhere, no `.html` address.
- **SITEMAP-2.** Each entry MUST carry `<loc>` and MAY carry `<lastmod>`. When `<lastmod>` is present it MUST change whenever the page does.

**Headers and caching, `public/_headers`.**

Cloudflare Pages already sends `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin` and `Cache-Control: public, max-age=0, must-revalidate` on every response, observed on both live sites. The file below repeats the first two so the site keeps them on another host, adds the security headers the host does not send, and gives long cache lifetimes only to files whose content cannot change under the same name. None of it lowers a Lighthouse score, and the cache lifetimes raise the performance score for returning visitors.

```
# Response headers, read by the static host from the build output.
/*
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  X-Frame-Options: DENY
  Permissions-Policy: camera=(), microphone=(), geolocation=()
  Strict-Transport-Security: max-age=31536000
  Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; form-action 'self'; frame-ancestors 'none'; base-uri 'self'; object-src 'none'

# Vite names these by a hash of their content, so a changed file gets a new name.
/assets/*
  Cache-Control: public, max-age=31536000, immutable

# Typeface files never change under the same name.
/fonts/*
  Cache-Control: public, max-age=31536000, immutable

# Images keep their names, so a returning visitor may see an old one for up
# to a week. Give a changed image a new file name.
/images/*
  Cache-Control: public, max-age=604800
```

- **HEADERS-1.** `public/_headers` MUST exist and MUST set, for `/*`, `X-Content-Type-Options`, `Referrer-Policy`, `X-Frame-Options`, `Permissions-Policy` and `Strict-Transport-Security` as above.
- **HEADERS-2.** HTML pages MUST NOT be given a cache lifetime, so the host's default revalidation applies. Reason: a visitor then sees a deploy at once.
- **HEADERS-3.** Files under `/assets/` and `/fonts/` MUST be cached for a year as `immutable`. Files under `/images/` SHOULD be cached for a week, and a changed image SHOULD be given a new file name.
- **HEADERS-4.** `Strict-Transport-Security` MUST NOT carry `includeSubDomains` or `preload`. Reason: other subdomains of `<domain>` may be served by other systems, and some may not serve HTTPS.
- **HEADERS-5.** The site SHOULD send the `Content-Security-Policy` above. Every third-party origin the site uses MUST be added to the directive that governs it: a form service to `form-action` and `connect-src`, a runtime data source to `connect-src`, remote images to `img-src`, and a font host to `style-src` and `font-src`. Every page MUST then be loaded on a preview with the browser console open before the policy reaches production. Reason: a policy that blocks something fails silently for the visitor. `'unsafe-inline'` stays in `script-src` because the head partial's pre-paint script is inline.

### Deployment standard
Host-agnostic rules. The labeled subsections after this one hold everything particular to one platform.

- **DEPLOY-1.** The static host MUST build from the Git repository: the production branch into production and every other branch into a preview. Nothing is uploaded by hand.
- **DEPLOY-2.** The host MUST run the build command from the repository root and publish the output directory, both given in the Build standard, with the tool versions from PIN-1 and PIN-2.
- **DEPLOY-3.** The host MUST serve `<page>/index.html` at `/<page>/` with no rewrite rule in the repository, MUST serve `404.html` with a 404 status for any address that matches nothing, and MUST apply `_redirects` and `_headers`.
- **DEPLOY-4.** The repository MUST hold no host-specific code or deployment configuration file beyond `_redirects` and `_headers`. The host's settings are recorded in the site's `CLAUDE.md` under Deployment. Reason: the site then moves to another host by changing settings, not code.
- **DEPLOY-5.** Build-time data that should refresh without a code change MUST be refreshed by a rebuild, never by a runtime call to a server of the site's own. How and when a rebuild is scheduled is outside this standard.

#### Git host specifics
The standard requires nothing of the Git host beyond holding the repository where the static host can build from it. No workflow file, no Git host secret, and no feature particular to one Git host is needed. The repository moves to another Git host, or to a self-hosted Git service, by pushing it there and reconnecting the static host.

#### Cloudflare specifics
- **CF-1.** The site is a Cloudflare Pages project connected to the repository, with these build settings:

```
Production branch:   main
Framework preset:    None
Root directory:      (blank)
Build command:       pnpm --filter @workspace/web run build
Output directory:    artifacts/web/dist/public
Build variable:      PNPM_VERSION=<the version in packageManager>
```

Node.js 24 comes from the committed `.node-version`, so no `NODE_VERSION` variable is set.

- **CF-2.** A `_worker.js` file MUST NOT exist anywhere in the repository or the output. Reason: on Pages its presence silently switches the project into Worker mode and stops static assets being served, with no warning, and the failure looks like a build problem. It has already caused an outage.
- **CF-3.** Pages reads `_redirects`, `_headers` and `404.html` from the root of the output directory only, which is why all three sit at the root.
- **CF-4.** Pages answers these requests this way, observed on both live sites:

| Request | Answer |
|---|---|
| `/<page>/` | 200 |
| `/<page>` | 308 to `/<page>/` |
| `/<page>/index.html` | 308 to `/<page>/` |
| `/<page>.html`, with a rule in `_redirects` | the rule's 301 |
| A mixed-case path such as `/<Page>` with no rule | 404 with `404.html` |
| Any other address that matches nothing | 404 with `404.html` |

- **CF-5.** The Pages project serves the custom domain `www.<domain>` only. The `www` record at the registrar is a CNAME to `<project>.pages.dev`. Reason: a Pages custom domain on the bare domain needs the whole DNS zone moved to Cloudflare, and the zone deliberately stays with the registrar.
- **CF-6.** A deploy hook's address is a credential and MUST NOT be committed.
- **CF-7.** A site, or its previews, MAY be put behind Cloudflare Access, only when the owner asks for it or the site's content calls for it, such as unreleased or private material. It is never the default.

#### Self-hosted portability notes
The output is a directory of static files with no server code, so any web server can serve it. A replacement host MUST provide, and the move MUST be verified against, each of these:

1. Serve `<page>/index.html` at `/<page>/`, and answer `/<page>` with a redirect to it, as CF-4 records.
2. Serve `404.html` with status 404 for every unmatched address.
3. Apply every rule in `_redirects` as a 301. A server that does not read the file needs the rules translated into its own configuration, one for one, with no wildcard.
4. Send every header in `_headers` on the paths it names. A server that does not read the file needs the rules translated the same way.
5. Build on linux-x64 with the Node.js and pnpm versions from PIN-1 and PIN-2, or remove the matching `overrides` lines from `pnpm-workspace.yaml` for the builder's platform before the first install.
6. Keep the domain-level redirects in DOMAIN-2 working, wherever they are configured.
7. Need no environment variable for the build, per BUILD-10, so nothing is lost moving it.

### Environments, previews, and custom domains
- **ENV-1.** There are two kinds of deployment. Production is built from the production branch and served at `https://www.<domain>`. A preview is built from every other branch and served at the host's own preview address for that branch. Both are publicly reachable by anyone with the address, unless CF-7 applies.
- **ENV-2.** A change SHOULD be loaded on its preview, with the deployed steps of the Pre-launch verification checklist that apply, before it reaches production.
- **ENV-3.** Every site has two hostnames with separate jobs. The bare domain `<domain>` is the advertised address: the one printed, spoken and linked from anywhere a person reads it. `www.<domain>` is the serving and canonical hostname: the one the static host answers, per CF-5, and the one every machine-read address uses, which is every canonical tag, `og:url`, `og:image`, sitemap entry and the robots sitemap line. Reason: those addresses are read by crawlers and link previews, never shown to a visitor as the site's name, so pointing them at the address that answers 200 costs the advertised address nothing.
- **ENV-4.** The bare domain redirects to `www.<domain>`, per DOMAIN-1, so every advertised address reaches the site. If the site is ever served at the bare domain directly, which needs the DNS zone moved to Cloudflare, the site and this standard are both updated to make the bare domain canonical.

**Warning: confirm how the host answers before writing a single address.** Both observed sites wrote their canonical tags, sitemap entries, internal links and redirect destinations as `/<page>`, without a trailing slash, on the belief that the host answered that address with 200. It does not: Cloudflare Pages answers `/<page>` with a 308 to `/<page>/`. Together with the hostname redirect, the canonical address `https://<domain>/<page>` of an observed site reached its page only after two redirects, a temporary 302 to `https://www.<domain>/<page>` and then a 308 to `https://www.<domain>/<page>/`, and each of its legacy `.html` rules added a third. A new site writes every directory address with its trailing slash, per HTML-3, META-3, SITEMAP-1 and REDIR-4, and steps 18 and 19 of the Pre-launch verification checklist prove it on the deployed site. The development server cannot show this, because `cleanUrls()` answers both forms with 200.

Both observed sites also wrote their canonical tags on the bare domain, which only redirects, so even with the slash every canonical would pass through the hostname redirect. A new site writes its canonical tags and sitemap on `www.<domain>`, per ENV-3, and its canonical addresses then answer 200 with no redirect at all.

**Domain-level configuration.** Domain-level behaviour lives outside the repository and outside the static host: in the registrar's DNS and URL forwarding, or in a self-hosted reverse proxy. Both arrangements are in use.

- **DOMAIN-1.** The bare domain, and any wildcard subdomain that is not otherwise in use, MUST redirect to `https://www.<domain>` with status 301, keeping the path and the query string, over both HTTP and HTTPS. Reason: a 301 says the move is permanent, so search engines carry the address's standing to the target, where a 302 or 307 says it is temporary.
- **DOMAIN-2.** The bare domain MUST present a valid, unexpired TLS (Transport Layer Security) certificate. Reason: a visitor who types the bare domain over HTTPS meets the certificate before any redirect, and an invalid one stops them there.
- **DOMAIN-3.** The site's `CLAUDE.md` MUST record, under Deployment, where its domain-level redirects are configured, the registrar or the reverse proxy, and list each redirect by its source and destination hostnames. It MUST NOT record an address, an account identifier or a credential.

### Secrets and environment variables
- **SECRET-1.** No secret MAY be committed to a site repository, in any file, in any branch, in plaintext.
- **SECRET-2.** The build MUST need no secret. `PORT` and `BASE_PATH` are the only variables a site reads, and both have defaults.
- **SECRET-3.** A key that a third-party service documents as public and limited to submitting, such as a form service's access key, MAY sit in page HTML. Its service and purpose MUST be named in `artifacts/web/README.md`. A key that can read data, change settings or spend money MUST NOT appear anywhere in the repository or the output.
- **SECRET-4.** A build-time fetch SHOULD use only public endpoints. A fetch that needs a secret MUST read it from an encrypted variable set in the static host's build settings, MUST name that variable, never its value, in `CLAUDE.md`, and MUST exit 0 with a warning when the variable is absent, per DATA-4. The developer keeps their own copy of the value wherever they choose, never in the repository. A Git host's secret store does not serve here: it reaches only that Git host's own CI, which a site built to this standard does not use to deploy.
- **SECRET-5.** Deploy hook addresses, host account identifiers and DNS zone identifiers are credentials for this purpose and MUST NOT be committed.

### New site checklist
Work through this from top to bottom. Replace every placeholder before running a step. A step that fails stops the checklist: fix the cause and rerun that step. Where a step touches repository creation, commits or branches, follow the repository's own development process; this checklist sets none.

1. Create the repository `<repo-name>` on the Git host, empty: no template, no generated README, no license.
2. Clone it and enter it:

```
git clone <repository-url> <repo-name>
cd <repo-name>
```

3. Write `.node-version`:

```
echo 24 > .node-version
```

4. Write `package.json` at the root, with `packageManager` set to the current pnpm 10 release:

```json
{
  "name": "workspace",
  "version": "0.0.0",
  "private": true,
  "packageManager": "pnpm@10.33.0",
  "scripts": {
    "preinstall": "sh -c 'rm -f package-lock.json yarn.lock; case \"$npm_config_user_agent\" in pnpm/*) ;; *) echo \"Use pnpm instead\" >&2; exit 1 ;; esac'",
    "build": "pnpm run typecheck && pnpm -r --if-present run build",
    "typecheck": "pnpm -r --if-present run typecheck"
  },
  "devDependencies": {
    "typescript": "~5.9.3"
  }
}
```

5. Write `pnpm-workspace.yaml`:

```yaml
# Supply-chain defense: a package version must be at least one day old
# (1440 minutes) before pnpm will install it. Do not lower or remove this.
minimumReleaseAge: 1440

# No package is exempt. Add one only as a deliberate, temporary exception
# and remove it once the release-age window has passed.
minimumReleaseAgeExclude: []

packages:
  - artifacts/*

catalog:
  '@types/node': ^25.3.3
  vite: ^7.3.2

autoInstallPeers: false

onlyBuiltDependencies:
  - esbuild

overrides:
  # The host builds on linux-x64, so every other platform binary is excluded
  # to keep installs small. This also blocks installing on any other platform:
  # to develop on macOS, Windows or ARM, remove that platform's lines locally.
  "esbuild>@esbuild/aix-ppc64": "-"
  "esbuild>@esbuild/android-arm": "-"
  "esbuild>@esbuild/android-arm64": "-"
  "esbuild>@esbuild/android-x64": "-"
  "esbuild>@esbuild/darwin-arm64": "-"
  "esbuild>@esbuild/darwin-x64": "-"
  "esbuild>@esbuild/freebsd-arm64": "-"
  "esbuild>@esbuild/freebsd-x64": "-"
  "esbuild>@esbuild/linux-arm": "-"
  "esbuild>@esbuild/linux-arm64": "-"
  "esbuild>@esbuild/linux-ia32": "-"
  "esbuild>@esbuild/linux-loong64": "-"
  "esbuild>@esbuild/linux-mips64el": "-"
  "esbuild>@esbuild/linux-ppc64": "-"
  "esbuild>@esbuild/linux-riscv64": "-"
  "esbuild>@esbuild/linux-s390x": "-"
  "esbuild>@esbuild/netbsd-arm64": "-"
  "esbuild>@esbuild/netbsd-x64": "-"
  "esbuild>@esbuild/openbsd-arm64": "-"
  "esbuild>@esbuild/openbsd-x64": "-"
  "esbuild>@esbuild/openharmony-arm64": "-"
  "esbuild>@esbuild/sunos-x64": "-"
  "esbuild>@esbuild/win32-arm64": "-"
  "esbuild>@esbuild/win32-ia32": "-"
  "esbuild>@esbuild/win32-x64": "-"
  "rollup>@rollup/rollup-android-arm-eabi": "-"
  "rollup>@rollup/rollup-android-arm64": "-"
  "rollup>@rollup/rollup-darwin-arm64": "-"
  "rollup>@rollup/rollup-darwin-x64": "-"
  "rollup>@rollup/rollup-freebsd-arm64": "-"
  "rollup>@rollup/rollup-freebsd-x64": "-"
  "rollup>@rollup/rollup-linux-arm-gnueabihf": "-"
  "rollup>@rollup/rollup-linux-arm-musleabihf": "-"
  "rollup>@rollup/rollup-linux-arm64-gnu": "-"
  "rollup>@rollup/rollup-linux-arm64-musl": "-"
  "rollup>@rollup/rollup-linux-loong64-gnu": "-"
  "rollup>@rollup/rollup-linux-loong64-musl": "-"
  "rollup>@rollup/rollup-linux-ppc64-gnu": "-"
  "rollup>@rollup/rollup-linux-ppc64-musl": "-"
  "rollup>@rollup/rollup-linux-riscv64-gnu": "-"
  "rollup>@rollup/rollup-linux-riscv64-musl": "-"
  "rollup>@rollup/rollup-linux-s390x-gnu": "-"
  "rollup>@rollup/rollup-linux-x64-musl": "-"
  "rollup>@rollup/rollup-openbsd-x64": "-"
  "rollup>@rollup/rollup-openharmony-arm64": "-"
  "rollup>@rollup/rollup-win32-arm64-msvc": "-"
  "rollup>@rollup/rollup-win32-ia32-msvc": "-"
  "rollup>@rollup/rollup-win32-x64-gnu": "-"
  "rollup>@rollup/rollup-win32-x64-msvc": "-"
  # Pin esbuild to one version across the tree so builds stay reproducible.
  esbuild: "0.27.3"
```

6. Write `.npmrc`:

```
auto-install-peers=false
strict-peer-dependencies=false
```

7. Write `.gitignore`:

```
# compiled output
dist
tmp
*.tsbuildinfo

# build caches, such as a build-time fetch's cache
.cache/

# dependencies
node_modules

# editors and system files
/.idea
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
.DS_Store
Thumbs.db
```

8. Write `tsconfig.base.json`:

```json
{
  "compilerOptions": {
    "incremental": true,
    "isolatedModules": true,
    "lib": ["es2022"],
    "module": "esnext",
    "moduleResolution": "bundler",
    "noEmitOnError": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": false,
    "noImplicitReturns": true,
    "noUnusedLocals": false,
    "noImplicitAny": true,
    "noImplicitThis": true,
    "strictNullChecks": true,
    "strictFunctionTypes": false,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "useUnknownInCatchVariables": true,
    "alwaysStrict": true,
    "skipLibCheck": true,
    "target": "es2022",
    "types": [],
    "customConditions": ["workspace"]
  }
}
```

9. Write `tsconfig.json`:

```json
{
  "extends": "./tsconfig.base.json",
  "compileOnSave": false,
  "files": [],
  "references": []
}
```

10. Create the site package directories:

```
mkdir -p docs artifacts/web/src/partials artifacts/web/src/css artifacts/web/src/js artifacts/web/public/images artifacts/web/public/fonts artifacts/web/about
```

11. Write `artifacts/web/package.json`:

```json
{
  "name": "@workspace/web",
  "version": "0.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite dev",
    "build": "vite build",
    "serve": "vite preview",
    "typecheck": "tsc -p tsconfig.json --noEmit"
  },
  "devDependencies": {
    "@types/node": "catalog:",
    "vite": "catalog:",
    "vite-plugin-handlebars": "^2.0.0"
  }
}
```

12. Write `artifacts/web/tsconfig.json`:

```json
{
  "extends": "../../tsconfig.base.json",
  "include": ["vite.config.ts"],
  "exclude": ["node_modules", "dist"],
  "compilerOptions": {
    "noEmit": true,
    "lib": ["esnext", "dom", "dom.iterable"],
    "resolveJsonModule": true,
    "moduleResolution": "bundler",
    "types": ["node", "vite/client"]
  }
}
```

13. Write `artifacts/web/vite.config.ts`. The example has one interior page, `about`; each further page is added by the steps in Modification Map, Adding a page.

```ts
import { resolve } from "node:path";
import { defineConfig, type Plugin } from "vite";
import handlebars from "vite-plugin-handlebars";

// Vite is the build tool only. No framework runtime reaches the browser:
// handlebars inlines the partials at build time and leaves plain HTML.

// PORT and BASE_PATH are optional, so a plain checkout builds with no
// environment set up. Set either to override.
const DEFAULT_PORT = 5173;
const DEFAULT_BASE_PATH = "/";

const rawPort = process.env.PORT;
const port = rawPort ? Number(rawPort) : DEFAULT_PORT;
if (Number.isNaN(port) || port <= 0) {
  throw new Error(`Invalid PORT value: "${rawPort}"`);
}
const basePath = process.env.BASE_PATH || DEFAULT_BASE_PATH;

// The canonical origin, the www hostname the host serves, written once.
// Canonicals below are paths. The bare domain is advertised and redirects here.
const SITE_ORIGIN = "https://www.<domain>";

const root = resolve(import.meta.dirname);

type PageMeta = {
  title: string;
  description: string;
  canonical: string | null;
  navHome?: boolean;
  navAbout?: boolean;
};

// Keyed on the source file path with a leading slash. A key that does not
// match the file exactly renders that page with an empty title.
// canonical is a path the host answers with 200: "/" for home, "/<page>/"
// with its trailing slash for a directory page, and null for the 404 page,
// which must never be indexed.
const pages: Record<string, PageMeta> = {
  "/index.html": {
    title: "<site-name> | <tagline>",
    description: "<one sentence describing the site>",
    canonical: "/",
    navHome: true,
  },
  "/about/index.html": {
    title: "About | <site-name>",
    description: "<one sentence describing the page>",
    canonical: "/about/",
    navAbout: true,
  },
  "/404.html": {
    title: "Page Not Found | <site-name>",
    description: "The page you are looking for could not be found.",
    canonical: null,
  },
};

// Dev and preview middleware for directory-style clean URLs, so /about and
// /about/ both reach /about/index.html. Production answers /about with a 308
// to /about/, which this cannot show. List every directory-style page.
function cleanUrls(): Plugin {
  const routes = ["about"];
  const rewrite = (req: { url?: string }) => {
    if (!req.url) return;
    const [pathname, search = ""] = req.url.split("?");
    const stripped = pathname.replace(/^\/+|\/+$/g, "");
    if (routes.includes(stripped)) {
      req.url = `/${stripped}/index.html${search ? `?${search}` : ""}`;
    }
  };
  return {
    name: "clean-urls",
    configureServer(server) {
      server.middlewares.use((req, _res, next) => {
        rewrite(req);
        next();
      });
    },
    configurePreviewServer(server) {
      server.middlewares.use((req, _res, next) => {
        rewrite(req);
        next();
      });
    },
  };
}

export default defineConfig({
  base: basePath,
  appType: "mpa",
  root,
  plugins: [
    cleanUrls(),
    handlebars({
      partialDirectory: resolve(root, "src/partials"),
      context(pagePath: string) {
        return { origin: SITE_ORIGIN, ...(pages[pagePath] ?? {}) };
      },
    }),
  ],
  build: {
    outDir: resolve(root, "dist/public"),
    emptyOutDir: true,
    rollupOptions: {
      input: {
        index: resolve(root, "index.html"),
        about: resolve(root, "about/index.html"),
        notFound: resolve(root, "404.html"),
      },
    },
  },
  server: {
    port,
    host: "0.0.0.0",
    allowedHosts: true,
  },
  preview: {
    port,
    host: "0.0.0.0",
    allowedHosts: true,
  },
});
```

14. Write `artifacts/web/src/partials/head.html`:

```html
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>{{title}}</title>
<meta name="description" content="{{description}}" />
{{#if canonical}}
<link rel="canonical" href="{{origin}}{{canonical}}" />
{{/if}}

<meta property="og:type" content="website" />
<meta property="og:site_name" content="<site-name>" />
<meta property="og:title" content="{{title}}" />
<meta property="og:description" content="{{description}}" />
{{#if canonical}}
<meta property="og:url" content="{{origin}}{{canonical}}" />
{{/if}}
<meta property="og:image" content="{{origin}}/images/og-banner.jpg" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="{{title}}" />
<meta name="twitter:description" content="{{description}}" />
<meta name="twitter:image" content="{{origin}}/images/og-banner.jpg" />

<link rel="icon" type="image/png" href="/favicon.png" />
<link rel="apple-touch-icon" href="/favicon.png" />

<link rel="preload" href="/fonts/<font-file>.woff2" as="font" type="font/woff2" crossorigin />
<link rel="stylesheet" href="/src/css/styles.css" />

<!--
  Runs before first paint. The js class lets CSS collapse JS-only controls
  only when JavaScript is available. The saved theme is applied now to
  avoid a flash of the wrong one; localStorage throws in private browsing,
  hence the try/catch.
-->
<script>
  document.documentElement.classList.add("js");
  (function () {
    var saved = null;
    try {
      saved = localStorage.getItem("<site-prefix>-theme");
    } catch (e) {}
    if (saved === "light" || saved === "dark") {
      document.documentElement.dataset.theme = saved;
    }
  })();
</script>
<script type="module" src="/src/js/main.js"></script>
```

15. Write `artifacts/web/src/partials/header.html`:

```html
<a class="skip-link" href="#main">Skip to main content</a>
<header class="site-header">
  <a class="brand" href="/"><site-name></a>
  <button
    class="nav-toggle"
    type="button"
    aria-label="Toggle navigation menu"
    aria-expanded="false"
    aria-controls="primary-nav"
  >Menu</button>
  <nav class="primary-nav" id="primary-nav" aria-label="Primary">
    <ul>
      <li><a href="/"{{#if navHome}} aria-current="page"{{/if}}>Home</a></li>
      <li><a href="/about/"{{#if navAbout}} aria-current="page"{{/if}}>About</a></li>
    </ul>
  </nav>
</header>
```

16. Write `artifacts/web/src/partials/footer.html`:

```html
<footer class="site-footer">
  <nav aria-label="Footer">
    <a href="/">Home</a>
    <a href="/about/">About</a>
  </nav>
</footer>
```

17. Write `artifacts/web/index.html`, then `artifacts/web/about/index.html` the same way with its own content:

```html
<!doctype html>
<html lang="en">
  <head>
    {{> head}}
  </head>
  <body>
    {{> header}}
    <main id="main">
      <h1><site-name></h1>
      <p><content from the build spec></p>
    </main>
    {{> footer}}
  </body>
</html>
```

18. Write `artifacts/web/404.html`:

```html
<!doctype html>
<html lang="en">
  <head>
    {{> head}}
  </head>
  <body>
    {{> header}}
    <main id="main">
      <h1>Page not found</h1>
      <p>The page you were looking for may have moved or no longer exists.</p>
      <p><a href="/">Back to home</a></p>
    </main>
    {{> footer}}
  </body>
</html>
```

19. Write `artifacts/web/src/css/styles.css` with the typeface, the palette and type families as custom properties in `:root`, a `.js`-gated rule that collapses the menu, a visible focus ring, and a reduced-motion block:

```css
@font-face {
  font-family: "<brand-typeface>";
  src: url("/fonts/<font-file>.woff2") format("woff2");
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

:root {
  --color-bg: <background>;
  --color-text: <text>;
  --color-accent: <accent>;
  --font-display: "<brand-typeface>", sans-serif;
}

body {
  margin: 0;
  background: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-display);
}

.skip-link {
  position: absolute;
  left: -9999px;
}
.skip-link:focus {
  left: 1rem;
}

:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
}

/* Collapse the menu only when JavaScript can open it again. */
.js .primary-nav {
  display: none;
}
.js .primary-nav.is-open {
  display: block;
}

@media (prefers-reduced-motion: reduce) {
  * {
    animation: none !important;
    transition: none !important;
  }
}
```

20. Write `artifacts/web/src/js/main.js`:

```js
// Progressive enhancement only. Every page reads and navigates without this.

// Mobile navigation toggle.
const toggle = document.querySelector(".nav-toggle");
const nav = document.getElementById("primary-nav");
if (toggle && nav) {
  toggle.addEventListener("click", () => {
    const open = toggle.getAttribute("aria-expanded") === "true";
    toggle.setAttribute("aria-expanded", String(!open));
    nav.classList.toggle("is-open", !open);
  });
}
```

21. Write `artifacts/web/public/_headers` exactly as given under Configuration files, then add any third-party origin the site uses, per HEADERS-5.
22. Write `artifacts/web/public/_redirects`, `artifacts/web/public/robots.txt` and `artifacts/web/public/sitemap.xml`. The first holds only its comment header until the site replaces an older one, per REDIR-1 and REDIR-2. The other two follow ROBOTS-1 and:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://www.<domain>/</loc></url>
  <url><loc>https://www.<domain>/about/</loc></url>
</urlset>
```

23. Copy the typeface's WOFF2 files to `artifacts/web/public/fonts/`, the favicon to `artifacts/web/public/favicon.png`, and the 1200 by 630 social image to `artifacts/web/public/images/og-banner.jpg`.
24. Write `artifacts/web/README.md`: what the site is, the layout tree with one line per page and its address, the data files and what each drives, the commands from Run & Operate, the host settings from CF-1, and any public submit-only key per SECRET-3.
25. Put the site's build spec, the authoritative source of its content, at `docs/site-build-spec.md`.
26. Write `CLAUDE.md` at the root from the template in Modification Map, then raise its section headings one level:

```
sed -i 's/^### /## /' CLAUDE.md
```

27. Install, typecheck, build and preview:

```
pnpm install
pnpm run typecheck
pnpm --filter @workspace/web run build
pnpm --filter @workspace/web run serve
```

28. Run every local step of the Pre-launch verification checklist. Fix anything that fails before going on.
29. Commit everything, including `pnpm-lock.yaml`, and push it to the production branch by the repository's own process.
30. In Cloudflare, create a Pages project named `<project>`, connected to the repository, with the settings in CF-1. Wait for the first production deployment to succeed at `https://<project>.pages.dev/`.
31. Attach `www.<domain>` to the Pages project as a custom domain, and at the registrar point the `www` record at `<project>.pages.dev` with a CNAME, per CF-5.
32. At the registrar or the reverse proxy, redirect the bare domain to `https://www.<domain>` with a 301 that keeps the path and query, over HTTP and HTTPS, with a valid certificate on the bare domain, per DOMAIN-1 and DOMAIN-2. Record it in `CLAUDE.md` per DOMAIN-3.
33. Run every deployed step of the Pre-launch verification checklist.

### Pre-launch verification checklist
Run every step and record the actual result, not the expected one. Each command runs from the repository root unless it says otherwise.

**Locally, on the built output.**

1. Install exactly what the lockfile records:

```
pnpm install --frozen-lockfile
```

2. Typecheck and build. Both exit 0:

```
pnpm run typecheck
pnpm --filter @workspace/web run build
```

3. Every page in `rollupOptions.input` exists in the output:

```
find artifacts/web/dist/public -name '*.html' | sort
```

4. No page has an empty title. This prints nothing:

```
grep -rl '<title></title>' artifacts/web/dist/public
```

5. No internal link ends in `.html`, and no link to a directory page lacks its trailing slash. Both print nothing:

```
grep -rnE 'href="/[^"]*\.html' artifacts/web/dist/public
grep -rnE 'href="/[a-z0-9-]+([?#][^"]*)?"' artifacts/web/dist/public
```

6. Every canonical is on the `www` hostname and ends in a slash. Both print nothing:

```
grep -rhoE 'rel="canonical" href="[^"]*"' artifacts/web/dist/public | grep -v '/"$'
grep -rhoE 'rel="canonical" href="[^"]*"' artifacts/web/dist/public | grep -v 'href="https://www\.'
```

7. The root files reached the output, and no `_worker.js` exists anywhere:

```
ls artifacts/web/dist/public/404.html artifacts/web/dist/public/_redirects artifacts/web/dist/public/_headers artifacts/web/dist/public/robots.txt artifacts/web/dist/public/sitemap.xml
find . -name '_worker.js' -not -path '*/node_modules/*'
```

8. `_redirects` holds no wildcard, placeholder or rewrite. This prints nothing:

```
grep -vE '^\s*(#|$)' artifacts/web/public/_redirects | grep -E '\*|:[a-z]+|\s200\s*$'
```

9. The not-found page carries no canonical and no `og:url`. This prints `0`:

```
grep -cE 'rel="canonical"|og:url' artifacts/web/dist/public/404.html
```

10. No copy holds an em dash or an en dash. This prints nothing. The locale setting is required, because without a UTF-8 locale the pattern is rejected:

```
LC_ALL=C.UTF-8 grep -rnP '[\x{2013}\x{2014}]' artifacts/web --include='*.html' --include='*.ts' --include='*.json' --exclude-dir=node_modules --exclude-dir=dist
```

11. Every page answers over the preview server with status 200 and its own title. With the preview server from step 27 of the New site checklist running, for each page:

```
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:5173/<page>/
curl -s http://localhost:5173/<page>/ | grep -o '<title>[^<]*</title>'
```

12. With JavaScript disabled in the browser, every page reads and every navigation link works.
13. The layout holds at 360, 768, 1280 and 1920 pixels wide, keyboard focus is always visible, and the tab order follows the page.
14. No page logs a console error, including with `localStorage` blocked.
15. Every address in `sitemap.xml` appears as a `canonical` in the `pages` map, and every non-null `canonical` appears in `sitemap.xml`.
16. A build-time fetch, if the site has one, exits 0 with the network unavailable and leaves its committed output unchanged.

**On the deployed site,** first on a preview, then in production. On a preview, replace `https://www.<domain>` with the preview's address and skip steps 21 and 22.

17. Lighthouse scores every page 90 or higher in each category and 95 or higher in Accessibility, per PERF-3, and the browser console shows no `Content-Security-Policy` violation.
18. Every directory page answers 200 at its address with the trailing slash:

```
curl -s -o /dev/null -w '%{http_code}\n' https://www.<domain>/<page>/
```

19. The same address without the slash answers 308 to the slashed one, and every rule in `_redirects` answers 301 straight to a slashed address that answers 200:

```
curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' https://www.<domain>/<page>
curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' https://www.<domain>/<page>.html
```

20. An unknown address answers 404, the headers from `_headers` are present, and hashed assets carry the year-long lifetime:

```
curl -s -o /dev/null -w '%{http_code}\n' https://www.<domain>/no-such-page
curl -sI https://www.<domain>/ | grep -iE '^(strict-transport-security|content-security-policy|x-frame-options|permissions-policy|x-content-type-options|referrer-policy)'
curl -sI https://www.<domain>/assets/<hashed-file> | grep -i '^cache-control'
```

21. The bare domain answers 301 to the same path on `www`, over HTTPS and HTTP, with no certificate error:

```
curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' https://<domain>/<page>/
curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' http://<domain>/<page>/
```

22. `https://www.<domain>/robots.txt` and `https://www.<domain>/sitemap.xml` answer 200, and every address in the sitemap answers 200 with no redirect.

### Known failure modes
- **A page renders with an empty title and description.** Its key in the `pages` map does not match its source path exactly, such as `/services.html` or `/services` for `services/index.html`. Fix the key. Data maps keyed the same way fail the same way, rendering the page with no data.
- **Every route shows the home page in development, but production is fine.** `appType: "mpa"` is missing, or the page is not in the `cleanUrls()` route list. Add both.
- **Every link, canonical and redirect costs an extra hop in production, but not in development.** The address was written as `/<page>` without its trailing slash, and the host answers it with a 308. The development server answers both forms with 200, so only the deployed checks catch it. Add the slash everywhere: links, canonicals, the sitemap and redirect destinations.
- **The site deploys and serves nothing, or serves errors for every asset.** A `_worker.js` is in the output and switched Pages into Worker mode. Delete it and redeploy.
- **Images, scripts or styles return HTML or redirect.** A wildcard or catch-all rule in `_redirects` is catching asset paths. Replace it with explicit rules.
- **Bad addresses show the home page instead of a 404.** A catch-all such as `/* /index.html 200` was added. Remove it.
- **A form, font, image or data feed works locally but not on the deployed site.** The `Content-Security-Policy` in `_headers` does not list its origin, and the browser console names the blocked address. Add the origin to the matching directive, per HEADERS-5.
- **A replaced image does not show for returning visitors.** It kept its file name and their browser holds the old one for up to a week. Give the new image a new name.
- **Search results or link previews show an address that redirects.** Canonical tags, `og:url` or the sitemap were written on the bare domain. Write them on `www.<domain>`, per ENV-3.
- **The bare domain shows a certificate error.** The certificate at the registrar's forwarding or the reverse proxy expired or was never issued. Renew it there; the static host does not serve the bare domain.
- **The host build fails at configuration.** `vite.config.ts` throws on a missing `PORT` or `BASE_PATH` that a former platform used to inject. Give both defaults, per BUILD-5.
- **A build that used to pass fails, or builds differently, with no change to the repository.** The host changed its default Node.js or pnpm version. Pin both, per PIN-1 and PIN-2.
- **The development server fails to start with `EAFNOSUPPORT`.** It binds `"::"`. Bind `"0.0.0.0"`.
- **Every page throws once on load in private browsing.** A `localStorage` access is not in a `try` and `catch`. Wrap it.
- **`pnpm install` fails on macOS, Windows or an ARM machine.** The platform `overrides` stripped that platform's binary. Remove that platform's lines locally and do not commit the change.
- **The shipped site changed with no source edit.** The lockfile was deleted and re-resolved, and a bundled library floated. Restore the lockfile from history and prune it in place.
- **A build leaves a committed data file modified.** The build-time fetch rewrote its output with fresher data. Commit it deliberately as a data refresh, or discard it; never commit it mixed into an unrelated change.
- **A build-time fetch silently stops updating.** It exits 0 by design, so a third-party failure, such as a profile turned private, only shows as a warning in the build log and stale data on the site. Read the warning and fix the source.
- **The not-found page stops showing.** `404.html` was moved out of the output root. Move it back.

## Part 2: Full Featured Site

The rules a site takes on when SITE-2 makes it full featured, on top of
every rule in Part 1 that still fits it. A Part 1 rule a full featured site
cannot keep, such as DEPLOY-4 for a site with Pages Functions, is recorded
as a departure under Gotchas in its `CLAUDE.md`, with the rule identifier
and the reason.

This part fixes no stack. Each site chooses its backend, database,
authentication, email sender and upload storage, and when sites built this
way show a common choice, it is added here.

These rules are written to protect the site's visitors and its operator.
They are not legal advice: where a law sets a duty, the owner confirms what
it requires where the site operates, and the site's `CLAUDE.md` records
what was confirmed and when.

### Stack and hosting

- **FULL-1.** The site's `CLAUDE.md` MUST record, under Stack, each service
  the site depends on beyond Part 1: backend, database, authentication,
  email sender, upload storage and analytics, each with what it is used for
  and its plan, free or paid, as read by HOST-1.
- **FULL-2.** A credential the site needs MUST be set on its host as an
  environment variable or secret and named, never valued, in its
  `CLAUDE.md`, and is kept by the repository's Credentials setting. It
  MUST NOT be committed or shipped to the browser.
- **FULL-3.** Every form the site stores or sends MUST validate its input
  on the server as well as in the browser, and MUST be protected against
  automated submission, by a challenge such as Cloudflare Turnstile or a
  rate limit. Reason: browser checks are skipped by anyone who wants to.

### Analytics

- **TRACK-1.** Analytics and session replay tools MUST NOT capture key
  events or keystrokes, and MUST mask the content of every input field,
  text area and editable region, including in recordings. Reason: what a
  visitor types, passwords and personal details first among it, is never
  the site's to record.
- **TRACK-2.** The site MUST record under Stack which analytics tool it
  uses and the settings that keep TRACK-1, and a change to those settings
  is checked against TRACK-1 before it ships.
- **TRACK-3.** Where the analytics tool or the law where the site operates
  requires consent before tracking, the site MUST ask for it before the
  tool loads. Reason: PERF-1 kept consent banners off static sites because
  they track nothing.

### Accounts and age

- **AGE-1.** Every user signup MUST confirm the user is 13 or older before
  an account is created, and MUST refuse anyone who is not. Reason: the
  site is not built for children's data, and United States law sets
  duties for collecting it from children under 13.
- **AGE-2.** The age question MUST be neutral: it asks for a birth date or
  age, or asks the user to confirm their age with both answers equally
  easy, and never says what answer is needed to pass. Reason: a question
  that shows the passing answer invites the wrong one.
- **AGE-3.** The site MUST NOT store the birth date or age. It stores only
  that the user confirmed being 13 or older and when, on their profile.
  Reason: a birth date is personal information the site does not need
  once the check is passed.
- **AGE-4.** After a refusal, the site SHOULD keep the same browser from
  trying again at once with a different answer, such as by a short-lived
  flag in session storage, without storing what was entered.

### Email to a list

- **MAIL-1.** Every email the site sends to a list of subscribers MUST
  carry a visible unsubscribe link that works in one click, with no sign
  in and no further confirmation.
- **MAIL-2.** Every such email MUST also carry the one-click unsubscribe
  headers mail providers read: `List-Unsubscribe` with an HTTPS address,
  and `List-Unsubscribe-Post: List-Unsubscribe=One-Click`. Reason: large
  mail providers act on these headers, and mail without them is more
  likely to be marked as spam.
- **MAIL-3.** Every such email MUST carry the official mailing address of
  the business or person that operates the site, recorded in the site's
  `CLAUDE.md`. The address is asked for as a TODO when the site first sends
  to a list, never before.
- **MAIL-4.** An unsubscribe MUST take effect at once and MUST hold: the
  address is kept only on a suppression list, so a later import cannot
  resubscribe it.
- **MAIL-5.** Mail sent to one user because of their own action, such as
  a password reset or a receipt, is not mail to a list and needs no
  unsubscribe, but MUST NOT carry marketing.

### Uploads

- **UPLOAD-1.** Every upload form MUST carry a checkbox, unchecked by
  default and required, by which the user states that they own the file or
  have permission to use it, and that they agree to the content policy,
  linked beside it. The site stores that the user agreed, when, and to
  which version of the policy.
- **UPLOAD-2.** The site MUST publish a content policy, made from the
  kit's template, `content-policy.md` beside this file, with every TODO in
  it answered before uploads are opened to users.
- **UPLOAD-3.** Every page that shows user uploaded content MUST carry a
  link labeled "Report Infringement", leading to a form or an email
  address that receives reports of uploaded content. A report names the
  content, the reporter, how to reach them and what is claimed.
- **UPLOAD-4.** The site MUST record under Product how a report is
  handled: who receives it, how fast content is taken down, and how the
  uploader is told.
- **UPLOAD-5.** Where the site operates in the United States, its
  `CLAUDE.md` MUST hold, as a TODO until answered, whether a designated
  agent for copyright notices is registered with the United States
  Copyright Office, and the agent's contact details on the content policy.
  Reason: that registration is what United States law ties a site's
  protection from its users' infringement to; the owner confirms it.
- **UPLOAD-6.** Uploads MUST be limited by size and type on the server,
  stored apart from the site's own code and assets, and served so that an
  uploaded file cannot run as a script on the site's origin.

### Full featured checklist

Run when a site first becomes full featured, and again for each feature
SITE-2 lists that it adds later. Record each result in the site's
`CLAUDE.md`.

1. Read the pricing and limits pages per HOST-1, and settle the hosting
   line per HOST-2 or HOST-3.
2. Record the stack per FULL-1 and each credential's name per FULL-2.
3. Update the site's `CLAUDE.md` opening lines to say it is full featured,
   per SITE-1, and list each Part 1 departure under Gotchas.
4. For analytics: the tool's settings per TRACK-1 and TRACK-2, and consent
   per TRACK-3.
5. For signup: the age check per AGE-1 to AGE-4, tested with an age under
   13, which must be refused and leave nothing stored.
6. For email to a list: the link and headers per MAIL-1 and MAIL-2, the
   address per MAIL-3, and an unsubscribe tested end to end per MAIL-4.
7. For uploads: the checkbox, the policy and the report link per UPLOAD-1
   to UPLOAD-4, the copyright agent TODO per UPLOAD-5, and a file of the
   wrong type and one over the size limit, both refused, per UPLOAD-6.
8. Run Part 1's Pre-launch verification checklist again.

## Escalation
When a build or a deployment fails and the Known failure modes do not cover it, read the host's build log for the first error, reproduce it locally with the commands in the Pre-launch verification checklist, and stop rather than change host settings by trial. Then notify `<admin-contact>`, the administrative mailbox of whoever operates the site, recorded in the site's `CLAUDE.md`.

A rule that does not fit a site is not quietly broken: record the exception and its reason in the site's `CLAUDE.md` under Gotchas and propose an amendment to this standard, which goes to the kit. A conflict between a site's build spec and this standard is put to `<owner>`, never settled by picking one.

## Modification Map
### Adding a page
A page touches five places, and missing one is how each failure in Known failure modes began:

1. `artifacts/web/<page>/index.html`.
2. The `pages` map in `artifacts/web/vite.config.ts`, keyed `"/<page>/index.html"`, with `canonical: "/<page>/"`.
3. `build.rollupOptions.input` in the same file.
4. The `routes` array in the same file's `cleanUrls()`.
5. `artifacts/web/public/sitemap.xml`, as `https://www.<domain>/<page>/`, unless the page is not indexable.

A page that replaces an address the site already published also adds a 301 to `public/_redirects`, pointing at `/<page>/`.

### Changing this standard
A change is made in the kit, never in a site's copy, and reaches each
repository by a kit update. It is recorded in the kit's `CHANGELOG.md`
under the version that carries it. A change that makes a compliant site
non-compliant says in its entry what each site must change. A site's
`CLAUDE.md` names the kit version it was last checked against.

This standard was first written outside the kit and reached version 1.2
there on 2026-10-03; the kit took it over from that version.

### CLAUDE.md template for new site repositories
Copy the block below into `CLAUDE.md` at the root of a new site repository and replace every placeholder. Its section headings are written one level lower than they belong, so they cannot be mistaken for this entry's own; raise them with the `sed` command in step 26 of the New site checklist.

````markdown
# <site-name>

<One or two sentences: what the site is, who it is for, and that it is a fully static site.> Advertised as <domain>, which redirects to www.<domain>, where Cloudflare Pages serves it; canonical tags and the sitemap use www.<domain>.

This repository follows the kit's site standard, `.claude/afk/standards/site.md`, <Part 1, a static site | Parts 1 and 2, a full featured site>, last checked against kit version <kit-version>, and its design standard, `.claude/afk/standards/design.md`. Read both before changing anything. Where this file departs from the standard, the departure and its reason are recorded under Gotchas, and nowhere else.

### Run & Operate

- `pnpm install --frozen-lockfile`: install exactly what the lockfile records
- `pnpm --filter @workspace/web run dev`: dev server at http://localhost:5173
- `pnpm --filter @workspace/web run build`: prebuild, then static build to `artifacts/web/dist/public`
- `pnpm --filter @workspace/web run serve`: preview the built output
- `pnpm run typecheck`: typecheck every package

`PORT` (default `5173`) and `BASE_PATH` (default `/`) are both optional; set either to override. Node.js comes from `.node-version` and pnpm from `packageManager` in `package.json`.

### Stack

- pnpm workspace; the site is the `@workspace/web` package at `artifacts/web`
- Vite as the build tool only, with vite-plugin-handlebars for partials and per-page metadata. No framework runtime ships to the browser
- Plain HTML, one stylesheet `src/css/styles.css`, one vanilla script `src/js/main.js`
- <For a static site:> No backend, no database, no auth, no analytics, by design
- <For a full featured site: each service per FULL-1, with its plan.>

### URLs

Directory-style. `index.html` serves at `/`, `404.html` stays at the root, and every other page is `<page>/index.html`, served at `/<page>/` with its trailing slash: <list each page>. The host answers `/<page>` with a 308 to `/<page>/`, so every link, canonical, sitemap entry and redirect destination carries the slash.

`public/_redirects` holds one explicit 301 per retired address. Never add a wildcard or a catch-all.

### Where things live

- `artifacts/web/<page>/index.html`: one directory per page
- `artifacts/web/src/partials/`: `head.html`, `header.html`, `footer.html`<, and any others>
- `artifacts/web/src/data/`: <each JSON file and what it drives, or "none">
- `artifacts/web/scripts/`: <each build-time script and what it does, or "none">
- `artifacts/web/vite.config.ts`: the `pages` metadata map, rollup inputs, and `cleanUrls()`
- `artifacts/web/public/`: `_redirects`, `_headers`, `robots.txt`, `sitemap.xml`, favicons, `fonts/`, `images/`
- `docs/site-build-spec.md`: the authoritative content spec

### Deployment

Deploys to Cloudflare Pages project <project> from <Git host>. The production branch deploys to production; every other branch builds a public preview.

```
Production branch:   main
Framework preset:    None
Root directory:      (blank)
Build command:       pnpm --filter @workspace/web run build
Output directory:    artifacts/web/dist/public
Build variable:      PNPM_VERSION=<the version in packageManager>
Custom domain:       www.<domain>
```

Domain-level redirects, configured at <the registrar or the reverse proxy>:
- <domain> to https://www.<domain>, 301, path and query kept
- <each other redirect, by source and destination hostname>

Environment variables set on the host, besides PNPM_VERSION: <names only, never values, or "none">.

Escalation contact: <admin-contact>.

### Architecture decisions

- <Each decision particular to this site, with its reason in one line.>

### Product

<The pages, what each is for, and anything a visitor can do on them.>

### User preferences

- No em dashes or en dashes in site copy. Use commas, colons, periods, or the word "to".
- American English.
- <Palette, typeface, tone, link behavior, and other preferences of the owner.>

### Gotchas

- Page metadata in `vite.config.ts` is keyed on the source file path, such as `/<page>/index.html`. A key that does not match exactly renders the page with an empty title.
- The dev server answers `/<page>` and `/<page>/` both with 200; production redirects the first. Check addresses on a preview.
- `pnpm-workspace.yaml` sets `minimumReleaseAge: 1440`. Never disable it.
- `pnpm-workspace.yaml` `overrides` strip every non-linux-x64 platform binary. Installing on macOS, Windows or ARM needs that platform's lines removed locally, never committed.
- <Each departure from the standard, with the rule identifier and the reason.>

### Rules for AI coding sessions

- Read this file, the site standard and the design standard before changing anything.
- Follow this repository's own process for branches, commits, review and CI. The standard sets none.
- Never invent content. Every fact on a page comes from `docs/site-build-spec.md` or from the owner. Unknowns become TODOs, each a single line that opens with the marker and a colon and asks one specific question, and are listed in your report.
- Never add a framework runtime. Never add a backend, a database, auth, analytics, a cookie banner, a chat widget or a newsletter signup without first making the site full featured by Part 2 of the site standard, starting with its hosting line.
- Never add a `_worker.js` file anywhere; server-side code goes in Pages Functions under `functions/`. On Cloudflare Pages it silently switches the project into Worker mode and breaks static asset serving.
- Never add a wildcard, a splat or a catch-all rewrite to `public/_redirects`. Every rule is one explicit 301 to a slashed address.
- Adding a page touches five places: the page file, the `pages` map, `rollupOptions.input`, the `cleanUrls()` routes, and `public/sitemap.xml`.
- Canonicals are paths: `/` for home, `/<page>/` with the trailing slash, never `.html`, and `null` on `404.html`. The origin they join is `https://www.<domain>`, never the bare domain, which only redirects.
- A new third-party origin goes into the matching `Content-Security-Policy` directive in `public/_headers`.
- Every page must read and navigate with JavaScript off. Wrap every `localStorage` access in try and catch.
- Never commit a secret. Name an environment variable, never its value.
- Never delete `pnpm-lock.yaml` to fix an install; update it in place. Never lower or remove `minimumReleaseAge`.
- Never leave scaffolding, platform configuration or upload dumps in the repository.
- Bind dev and preview servers to `0.0.0.0`, never `::`. Never make `vite.config.ts` throw on a missing environment variable.
- Before finishing a change, run `pnpm run typecheck`, `pnpm --filter @workspace/web run build`, and the local steps of the site standard's Pre-launch verification checklist, and fix anything that fails.
````
