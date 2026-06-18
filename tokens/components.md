# IronLink — Components as Token Specs (Flutter)

Each component below is defined by **tokens**, not CSS — `bg = IlColor.surface`, not
`background:#fff`. Every value resolves through the token layers in
`ironlink_tokens.dart` (Dart) / `ironlink.tokens.json` (cross-platform). The HTML
mockups in `../screens/` are the visual reference; this file is the build contract
for Flutter widgets.

> **Rule:** widgets read **component** tokens (`IlButton.*`, `IlCard.*`); component
> tokens reference **semantic** tokens (`IlColor.accent`); semantic reference
> **primitives**. Never hard-code a hex, size, or duration in a widget.

---

## Foundations recap

| Concern | Where | Notes |
|---|---|---|
| Color | `IlColor` | role names only (`accent`, `surface`, `textSecondary`, `danger`…). Yellow = one primary action/highlight per screen. |
| Spacing | `IlSpace.s1…s8` | 4-pt grid. `IlSpace.gutter` (20) = screen padding; `IlSpace.cardGap` (12). |
| Radius | `IlRadius.xs…xl`, `.pill` | components carry their own (`IlCard.radius`, `IlButton.radius`). |
| Type | `IlType.*` | Archivo / Archivo Expanded. Set `color:` at call site. Money uses `metric` + `tabularFigures`. |
| Elevation | `IlShadow.sm/md/lg/accent/ink` | `List<BoxShadow>` ready for `BoxDecoration.boxShadow`. |
| Motion | `IlMotion.*` | durations + `Cubic` curves; `pressScale 0.97`, `scrimOpacity 0.45`. |

---

## Buttons — `IlButton`

| Variant | Flutter | bg / fg / extras |
|---|---|---|
| Primary | `ElevatedButton` | `primaryBg` / `primaryFg`, `boxShadow: IlShadow.accent`, pressed → `primaryBgPressed`. One per screen. |
| Dark | `ElevatedButton` | `darkBg` / `darkFg`, `IlShadow.ink`. |
| Outline | `OutlinedButton` | `outlineBg` / `outlineFg`, border `outlineBorder` @ `outlineBorderWidth`. |
| Ghost | `TextButton` | transparent / `outlineFg`. |
| Danger | `ElevatedButton`/`TextButton` | `dangerBg` / `dangerFg`. Destructive confirms. |
| Disabled | any | `disabledBg` / `disabledFg`, no shadow, ignore taps. |

- Heights: `heightSm 40` · `heightMd 52` (default) · `heightLg 56`. Radius `IlButton.radius` (sm variant → `radiusSm`).
- `padding: EdgeInsets.symmetric(horizontal: IlButton.paddingX)`, icon gap `IlButton.gap`, label `IlButton.font`.
- Tap feedback: scale to `IlMotion.pressScale` over `IlMotion.fast` (wrap in a press-scale widget; don't rely on ink splash alone).
- **Icon button** (app bar): `IlAvatar`-sized 40 round; ghost / filled-ink variants. Unread → small dot badge top-right.

---

## Cards & lists — `IlCard`

- `Container(decoration: BoxDecoration(color: IlCard.bg, border: Border.all(color: IlCard.border), borderRadius: BorderRadius.circular(IlCard.radius), boxShadow: IlCard.shadow))`, padding `IlCard.padding`.
- **Highlight** (the one key item): `highlightBg` + 1px `highlightBorder`.
- **Dark** (AI insight / wallet): `darkBg`; text uses `IlColor.onInk`, muted `IlColor.textMutedOnDark`.
- Stacked cards separated by `IlSpace.cardGap`.
- **List row**: `ListTile`-like — 56+ min height, padding `IlSpace.s4`/`gutter`, hairline `border` divider, trailing chevron in `textTertiary`. Section header = `IlType.h3` + an `info`-colored action link.

---

## Inputs & forms — `IlInput`

- Field height `IlInput.height` (52), radius `IlInput.radius`, fill `IlInput.fill`, border `IlInput.border` @ `borderWidth` 1.5.
- Focus → border `IlInput.borderFocus` (ink). Error → `borderError` + helper text in `IlColor.danger`.
- Label `IlType.smallStrong` above; hint/helper `IlType.xs` in `textTertiary`.
- **Search bar**: 46 tall, leading `i-search` icon in `textTertiary`.
- **Toggle**: off track `borderStrong`; on track `IlColor.positive`; 150ms thumb slide.
- **Choice / radio card**: unselected border `border`; selected border `ink` + subtle ink-tinted focus ring.
- **OTP cell**: 48×60, `IlType.metricSm`; filled → border `ink`; active → border `accent` + `accentWash` glow.

Map the common cases once in `InputDecorationTheme` so every `TextField` inherits them.

---

## Selectors — chips, segmented, tabs

- **Chip** (`IlChip`): pill, height 36. Default `bg`/`fg`/`border`; active `activeBg`/`activeFg` (yellow); dark variant uses `ink`. Horizontal scroll row for filters.
- **Segmented** (one-of-N): track `surfaceAlt` + `border`, 34-tall thumbs; active thumb `ink` bg + `onInk` text + `IlShadow.sm`. `--block` stretches full width.
- **Underline tabs** (top-level views): inactive label `textSecondary`; active label `textPrimary` + 2.5px `accent` underline. Pair with a cross-fade over `IlMotion.fast`.

---

## Tags & badges — `IlTag`

- Tag: 24 tall, radius `IlRadius.sm`, `IlTag.font`. Color by intent via feedback tokens:
  match → `matchBg`/`matchFg` (ink/yellow), positive → `positiveBg`/`positive`, danger, warning, info, plus a yellow-tint and a solid-danger “urgent”.
- Badge: 18 min, pill, `IlColor.danger` bg / white. Dot variant 9px with a 2px surface ring (presence / unread).

---

## Avatars — `IlAvatar`

- Sizes `xs 28 · sm 34 · md 40 · lg 56 · xl 84`. Default `bg` ink + initials `fg`.
- Worker (self) may use yellow bg + ink initials. **Company = squared** corner `orgRadius`.
- Image children = `BoxFit.cover`. No-photo placeholder → dashed border + `textTertiary` glyph.

---

## App bar & navigation — `IlTabbar`

- **App bar**: padding `IlSpace.gutter`, title `IlType.h1`, 40-round icon buttons trailing.
  Long detail screens collapse the title on scroll (shrink to ~18, over `IlMotion.fast`).
- **Bottom tab bar** — role-adaptive, same shape, different destinations:
  - **Worker**: Network · Trends · **[FAB]** · Jobs · Messages — FAB `fabWorkerBg` (yellow) `IlShadow.accent`.
  - **Employer**: Home · Jobs · **[FAB]** · Talent · Messages — FAB `fabEmployerBg` (ink) `IlShadow.ink`.
  - Bar `height 92` (includes safe area), bg `IlTabbar.bg` @ ~94% + blur, top border `borderTop`.
  - Item active `itemActive` / inactive `itemInactive`; label `IlTabbar.itemLabel`.
  - **The center FAB is the only global “+”.** A per-screen create shortcut must be a *labelled* button, never a bare “+”. FAB expands into the create menu (sheet) on tap.

---

## Overlays — sheets, dialogs, menus

- **Bottom sheet** (`IlSheet`): top radius `radiusTop`, bg `IlSheet.bg`, `IlSheet.shadow`, drag-grab `IlSheet.grab`. Backdrop scrim `IlSheet.scrim`. Enter: slide-up over `IlSheet.enter` with `IlSheet.enterCurve`; scrim fades in parallel. Use for filters, comments, mode-switcher, create menu, paywall.
- **Dialog** (`IlDialog`): centered, radius `radius`, `maxWidth 320`, `IlShadow.lg`. Pop-in over `IlDialog.enter`. Icon bubble tinted by intent (`dangerBg`/`warningBg`/`infoBg`/`positiveBg`). Confirms & destructive actions; destructive uses a danger primary.
- **Action sheet / create menu**: rows with a tinted leading icon tile (yellow for the primary create action) + title + optional sub-label; staggered entrance (`IlMotion.staggerStep` between rows).
- **Toast / snackbar**: ink bg, `IlShadow.lg`, optional yellow action link; slide-up.
- **Banner** (persistent context): offline → ink bar; or `positiveBg`/`warningBg`/`infoBg` with matching text. Inline in the scroll view, not floating.

---

## Domain blocks (IronLink-specific)

These encode the product; build as composed widgets reading the same tokens.

- **Pay range bar**: gradient track (`yellow` family), ink pin + bubble marking "You", min/median/max scale in `textTertiary` tabular figures.
- **Stat grid**: 2-col; value in `IlType.metricSm`, label `IlType.small` `textSecondary`.
- **Area chart**: ink stroke line, yellow-to-transparent gradient fill, hairline `border` gridlines.
- **Job card**: title `h3`, company + distance row with `i-pin`, wage in `metricSm`, tags (match/urgent/above-market), bookmark icon button.
- **Feed post**: avatar + name + meta header, 16:10 media (placeholder if none), body, action row (heart/comment/share/save) in `textSecondary`.
- **Conversation row & chat bubbles**: incoming = `surface` + border, outgoing = `ink` + `onInk`; timestamps `IlType.xs`.
- **Notification item**: tinted intent icon; unread row tinted `accentWash`.

---

## States — loading, offline, media

- **Skeleton** (`IlProgress`/`skeleton` tokens): base `surfaceAlt`, shimmer sweep over 1300ms (gate behind `MediaQuery.disableAnimations` / reduce-motion). Primitives: line / avatar / thumb / chip / metric.
- **Pull-to-refresh**: spinner from `border` → ink; ready state tints to `accentPressed`.
- **Offline**: persistent ink banner; disabled actions show inline "Internet required" (`textTertiary`); queued writes show a pending clock (`warning`); cached data dims via opacity and shows a "Updated Nh ago" stamp.
- **Media placeholder**: `surfaceAlt` fill + `i-image` glyph; broken → diagonal hatch + Retry.

---

## Motion contract

| Transition | Duration | Curve |
|---|---|---|
| Tap feedback (scale `0.97`) | `IlMotion.fast` | `standard` |
| Tab cross-fade | `IlMotion.fast` | `standard` |
| Dialog pop-in | `IlMotion.dialog` | `entrance` |
| Bottom sheet + scrim | `IlMotion.sheet` | `entrance` (in) / `exit` (out) |
| Page push / pop | `IlMotion.page` / `IlMotion.pop` | `standard` |
| List/stagger rise | `300ms`, `IlMotion.staggerStep` between items | `standard` |
| FAB → create menu | `IlMotion.sheet` | `entrance` |

Every animation must no-op under reduced-motion.

---

## Wiring (sketch — not app code, just the shape)

```dart
ThemeData buildIronlinkTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: IlColor.bg,
  colorScheme: const ColorScheme.light(
    primary: IlColor.accent, onPrimary: IlColor.onAccent,
    secondary: IlColor.ink, onSecondary: IlColor.onInk,
    surface: IlColor.surface, onSurface: IlColor.textPrimary,
    error: IlColor.danger,
  ),
  textTheme: const TextTheme(
    displayLarge: IlType.display, headlineLarge: IlType.h1,
    headlineMedium: IlType.h2, titleLarge: IlType.h3,
    bodyLarge: IlType.body, bodyMedium: IlType.small,
  ),
  extensions: const [IronlinkTokens()], // roles ColorScheme can't carry
);
```
Read role colors anywhere via:
`final t = Theme.of(context).extension<IronlinkTokens>()!; // t.danger, t.accentWash, …`
