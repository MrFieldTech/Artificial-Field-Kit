# Design Standard

The rules for how any user interface a repository builds looks and behaves:
a site, an app, a dashboard, a document page. Read it in full before
designing or reviewing an interface, and before calling interface work
done. The site standard, `site.md`, covers how a site is built and served;
this file covers what its visitor sees.

The key words MUST, MUST NOT, SHOULD and MAY mean what RFC 2119 says they
mean. Each rule carries its reason, so a case the rule did not foresee can
be judged by it, and a check, which is how a reviewer confirms the rule
holds. A rule that would make a page worse is raised with the owner rather
than followed or broken quietly.

## Content

- **DESIGN-1. Delete filler badges.** A badge, pill, ribbon or tag MUST
  carry information the visitor acts on, such as a status, a count or a
  price change. "New", "Popular", "Pro" or "Beta" with nothing behind them
  are removed. Reason: decoration that looks like information teaches the
  visitor to ignore the badges that matter. Check: for each badge, name
  the decision it helps the visitor make; remove it when there is none.
- **DESIGN-2. Drop redundant labels.** A label MUST NOT repeat what its
  content or heading already says, such as "Email:" before an email
  address under a Contact heading, or "Title" above a title. Reason: every
  repeated word lowers the density of what is new on the screen. Check:
  hide each label; keep it only when its content becomes ambiguous.
- **DESIGN-3. Show the actual product.** Where a page describes a product,
  service or result, it MUST show the real thing: a screenshot, a photo,
  a working example or real output. Stock imagery and abstract
  illustrations do not stand in for it. Reason: a visitor trusts what they
  can see working. Check: each hero and feature section shows something
  the product really produces.
- **DESIGN-4. Make headlines specific.** A headline MUST say what the
  product does or what the section holds, in words that could not be
  pasted onto a competitor's page. "Fast, simple, powerful" fails;
  "Schedule a repair in two minutes" passes. Reason: a visitor decides in
  seconds whether a page is for them. Check: swap in a competitor's name;
  a headline that still reads true is rewritten.

## Hierarchy and layout

- **DESIGN-5. Enlarge the main feature.** Each page MUST have one element
  that is clearly the largest and first seen: the thing the page exists
  to show or the action it exists to get. Reason: when everything is the
  same size, nothing is read first. Check: squint at the page, or blur a
  screenshot; the main feature is still the first thing found.
- **DESIGN-6. Emphasize the call to action.** The primary action on a
  page MUST be one button in the accent color with the strongest contrast
  on the page. Secondary actions MUST be visibly quieter: outlined, ghost
  or text links. There is at most one primary action per view. Reason: two
  equal buttons ask the visitor to choose; one asks them to act. Check:
  count the filled accent buttons in each view; there is one.
- **DESIGN-7. Group with spacing.** Related items MUST sit closer to each
  other than to unrelated items, and spacing, not lines or boxes, SHOULD
  be the first tool for grouping. Spacing values come from one scale in
  the design system. Reason: proximity is read before borders, and boxes
  around everything add noise. Check: remove every divider and card
  border; the groups still read as groups.
- **DESIGN-8. Align by eye, not pixels.** Shapes that look misaligned
  when aligned by their boxes MUST be nudged until they look aligned:
  play icons shifted toward their point, round icons beside text, text
  with large capital letters, punctuation hanging at a margin. Reason:
  the eye sees mass, not bounding boxes. Check: view at full size and
  zoomed out; nothing looks off center even when the numbers say it is.
- **DESIGN-9. Inner radius equals outer radius minus padding.** When a
  rounded element sits inside another, the inner corner radius MUST be
  the outer radius minus the padding between them, and never below zero.
  Reason: equal radii make the gap between corners swell and look
  accidental. Check: for each nested rounded pair, inner radius plus
  padding equals outer radius.

## Type

- **DESIGN-10. Unitalicize random header words.** Italic, a second
  weight or a second color MUST NOT pick out single words in a heading
  for style. Emphasis is kept for a word whose stress changes the
  meaning. Reason: styled words with no reason read as a template, and
  real emphasis then has no weight. Check: read each styled word aloud
  with stress; remove the style when the meaning does not change.
- **DESIGN-11. Mono only where needed.** A monospace typeface MUST be
  used only for code, commands, file paths, keys and values meant to be
  copied, and figures that must align by character. Reason: monospace
  slows reading and signals "machine text"; used for style it says the
  wrong thing. Check: every monospace run is something a visitor would
  type, copy or compare character by character.
- **DESIGN-12. Wrap headlines properly.** Headlines MUST NOT leave a
  single short word alone on the last line, and MUST NOT break inside a
  name or a number with its unit. Use `text-wrap: balance` for headings
  and `text-wrap: pretty` for paragraphs, and a non-breaking space where a
  pair must stay together. Reason: a ragged or orphaned headline looks
  unfinished. Check: view every heading at the narrowest phone width, a
  tablet width and the widest layout.
- **DESIGN-13. Use tabular numbers.** Figures that change in place or sit
  in columns, such as prices, counters, timers, tables and statistics,
  MUST use tabular figures, `font-variant-numeric: tabular-nums`. Reason:
  proportional figures change width as they change value, so columns
  stagger and counters jitter. Check: every column of numbers aligns on
  its digits, and a live number does not shift its neighbors.

## Color and contrast

- **DESIGN-14. Use a design system.** Colors, type sizes, weights,
  spacing, radii, shadows and motion timings MUST come from one set of
  named tokens, defined once, such as CSS custom properties. A page MUST
  NOT carry a one-off value. Reason: one-off values drift, and a change
  then has to be found by hand everywhere. Check: search the styles for
  raw color, size and spacing values outside the token definitions.
- **DESIGN-15. Add an accent color.** The palette MUST have one accent
  color, used for the primary action, links, focus and the few things
  that must stand out, and kept off decoration. Reason: an accent works
  only by being scarce. Check: the accent appears on interactive or
  status elements only.
- **DESIGN-16. Improve text contrast.** Body text MUST meet a contrast
  ratio of at least 4.5 to 1 against its background, and large text and
  icons that carry meaning at least 3 to 1, the WCAG (Web Content
  Accessibility Guidelines) 2.2 AA levels, in light and dark themes both.
  Gray text on gray, and text on photos without a scrim, fail. Reason: low
  contrast loses readers in sunlight, on cheap screens and with aging
  eyes. Check: run a contrast checker on every text and background token
  pair, and on text over images.

## Icons and decoration

- **DESIGN-17. Keep icons consistent.** All icons on a site MUST come from
  one set, at one stroke width, one corner style and sizes from the token
  scale, aligned to the text beside them by DESIGN-8. Reason: mixed sets
  read as assembled rather than designed. Check: lay every icon in use
  side by side; they look like one family.
- **DESIGN-18. Remove embellishments.** Gradients, glows, drop shadows,
  blurred blobs, noise textures, decorative borders and background
  patterns MUST each have a job, such as showing elevation or separating
  layers. One with no job is removed. Reason: decoration competes with
  content for the same attention. Check: remove each effect; keep it only
  when something becomes harder to understand without it.

## Feedback and motion

- **DESIGN-19. Add loading states.** Anything that waits on the network or
  on work longer than about 100 milliseconds MUST show that it is working:
  a skeleton in the shape of the coming content for page regions, a
  spinner or progress inside the control for actions, and the control
  disabled against a second submit. Empty states and error states MUST be
  designed too, each saying what happened and what to do. Reason: a screen
  that does not respond reads as broken. Check: throttle the network in
  the browser's developer tools and use every view and action.
- **DESIGN-20. Animate useful feedback.** Motion MUST serve the visitor:
  confirming an action, showing where something came from or went, or
  keeping orientation through a change. It MUST be short, usually 150 to
  300 milliseconds, MUST NOT run on frequent keyboard actions, MUST
  animate only `transform` and `opacity` where it can, and MUST respect
  `prefers-reduced-motion`. Reason: motion is information; motion that
  carries none is delay. Check: for each animation, name what it tells
  the visitor; remove it when there is nothing.

## Skills that help

When these skills are installed in the repository, reach for them in their
case. They add detail; where one disagrees with a rule here, this file wins
and the disagreement is raised with the owner.

| Work | Skill |
|---|---|
| Overall polish and component judgment | `emil-design-eng` |
| Building one animation | `animate`; several moving together, `choreograph` |
| Reviewing or auditing motion | `review-animations`, `improve-animations` |
| Finding motion to add or to cut | `find-animation-opportunities`, `remove-animations` |
| Dropped frames | `animation-performance` |
| Naming a motion effect | `animation-vocabulary` |
| Drag, swipe and sheets | `gestures`, with `apple-design` for physical motion |
| A web app on a phone | `mobile-native` |
| Worst-case data in a layout | `break-ui` |
| Choosing a front-end library | `pick-ui-library`; toasts, `ask-sonner` |
| Trying several versions of a piece | `prototype` |
| React Native and Expo motion | `animate-expo` |
| Swift | `write-swift` |
