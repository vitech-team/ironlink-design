# IronLink — Navigation & Motion Review

Review of the 53 mockups walking screen-to-screen through the 9 user flows
(`flows.html`), plus a per-screen scroll/motion pass. Findings and the actions
taken on each.

---

## A. Navigation & wiring

### A1. Redundant top "+" vs the center create FAB — FIXED
The center FAB is the global create menu (95). Several screens also showed a bare
"+" in the top app bar = the *same* action twice.

Decision: **keep a top action but disambiguate it** (it's a useful shortcut), so
the bare duplicate "+" is gone:

| Screen | Before | After |
|---|---|---|
| 60-feed, 96, 97 | top `+` (ghost) | **compose** pencil `i-edit` ("Write a post") |
| 50-messages-hub | top `+` (dark) | **compose** pencil `i-edit` ("Compose") |
| 44a-job-listings | top `+` (dark) | labelled **"＋ Post job"** button |
| 72a-my-listings | top `+` (dark) | labelled **"＋ List item"** button |

The center FAB (`i-plus`) is untouched everywhere. Rule going forward: **the bare
`+` icon belongs only to the center FAB / global create**; a per-screen create
shortcut must be a labelled button or a distinct icon.

### A2. Talent tab reused the Network icon — FIXED
Employer "Talent" tab used `i-network`, the same glyph as the Worker "Network"
tab. Switched Talent to **`i-users`** on all 7 employer-tabbar screens (44, 44a,
45, 47, 49, 80, 82). Worker Network keeps `i-network`. Each tab icon now has one
meaning per mode.

### A3. Back vs close on create screens — FIXED (minor)
Create overlays should use a close-✕ (reversible modal), not a back-chevron.
`72-create-listing` used a chevron; switched to `i-close` to match peers 42, 44,
61.

### A4. Reviewed and intentionally left as-is
- **No dead ends / no missing screens** — every flow step has an affordance to the
  next, and every CTA destination has a screen. (Nav review found none missing.)
- **No back button on 23, 30, 31, 35, 91** — these are tab destinations; "back" is
  a tab switch. Correct.
- **No back button on 93, 94** — scrim-dismissed modals. Correct.
- **50-messages compose stays a top action** (now a pencil) — composing a DM is a
  distinct intent from the FAB's create menu, so a dedicated shortcut is right.

---

## B. Scroll & motion (per-screen)

Motion utilities are **opt-in** classes in `ironlink.css` so static mockups stay
stable; the rules below are what an implementation (Flutter) should wire up.

### B1. Global rules
- Durations/easings already tokenised: `--ease-std` `cubic-bezier(.4,0,.2,1)`,
  `--ease-in` `(.3,0,.4,1)`, `--ease-out` `(.4,0,1,1)`. Push 300 / pop 250 /
  sheet 280 / dialog 200 / tab 150–200 ms.
- **Transition by context:** tab destination → cross-fade (`.tabfade`); detail →
  push-from-right with back-chevron; create/picker/menu → bottom-sheet slide-up +
  scrim (`.anim-sheet`/`.anim-scrim`); confirm/alert → centered pop-in
  (`.anim-dialog`).
- All motion is disabled under `prefers-reduced-motion: reduce`.

### B2. Scroll & pinning
- **List/feed screens** (60, 40, 50, 70, 43, 44a, 45, 47, 72a, 90): app bar +
  segmented tabs + filter chiprow stay pinned; only the list scrolls; bottom tab
  bar pinned. Filter chiprows (40, 70, 72a) scroll horizontally.
- **Detail screens** (41, 71): long content — app bar **collapses** on scroll
  (`.appbar.is-collapsed`).
- **Pushed forms** (42, 44, 61, 72, 22, 16): header pinned, content scrolls,
  bottom action bar pinned above the home indicator.
- **Sheets** (40a, 71a, 94, 95, 81, 93): grab handle + title pinned, body scrolls
  inside the sheet.

### B3. Micro-interactions
- **Pull-to-refresh** (`.ptr`): feed 60, jobs 40, applications 43, messages 50,
  notifications 90, marketplace 70, talent 47, listings 44a, my-listings 72a.
- **Swipe-to-action** (`.swipe`, new): messages → mark read/archive; jobs →
  save/hide; my-listings → edit/mark-sold; notifications → dismiss.
- **FAB expand** (95): rotate `+`→✕, items rise staggered, scrim fades — already
  built (`.anim-fab-open`, `.anim-stagger`).
- **Optimistic send**: chat 51 (bubble appears faded → confirms), post 61, apply 42.
- **List-load stagger** (`.anim-list`, new): rows rise in sequence on data load.
- **Haptics** (native): PTR threshold, swipe reveal, FAB open, chip toggle.

### B4. Motion utilities added to `ironlink.css`
- `.anim-list` — opt-in staggered row entrance on load.
- `.tabfade` — tab-content cross-fade.
- `.appbar.is-collapsed` — collapsing header for detail screens.
- `.tabbar.is-hidden` — hide-on-scroll tab bar (feed only).
- `.swipe` / `.swipe__content` / `.swipe__actions` / `.swipe__action(--muted/danger/pos)`
  — swipe-to-reveal row actions.

All added classes are also covered by the reduced-motion guard.
