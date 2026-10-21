# 360 Estate design system (MASTER)

Source of truth for every screen. A file in `design-system/360-estate/pages/<page>.md` overrides this file for that page.

- **Origin:** UI/UX Pro Max (`.claude/skills/ui-ux-pro-max`), query `"real estate property management dashboard app" --design-system --density 7`. Product match: Real Estate/Property ("trust teal").
- **Filter:** the house design law in `~/.claude/CLAUDE.md`. Where the skill output and the law disagree, the law wins. The overrides are listed at the end.
- **Code:** `lib/core/presentation/design_system/` (tokens) and `lib/core/presentation/theme/app_theme.dart` (component themes).

## Product

- **Users:** PG and multi-unit owners in India. They manage rent, tenants, leases and maintenance, usually on a phone between other jobs.
- **Character:** a rent ledger. Calm, exact, quick to scan. Numbers carry the screen.
- **Style:** Swiss minimal. Tonal surfaces, no borders on cards, no glass, no glow. Density 7/10.

## Colour

All pairs below were checked with WCAG 2.1. Text needs at least 4.5:1, and UI boundaries need at least 3:1. The lowest text pair is `primary` on `surface` in light mode at 5.11:1.

| Role | Light | Dark | Use |
|---|---|---|---|
| primary | `#0F766E` | `#79D0C3` | Main action, paid state, active nav |
| onPrimary | `#FFFFFF` | `#00382F` | Text on primary |
| primaryContainer | `#CDE8E2` | `#0C4E48` | Selected chip, tonal highlight |
| onPrimaryContainer | `#073B37` | `#C2EDE6` | Text on primaryContainer |
| secondary | `#3D5A56` | `#AFCAC5` | Secondary text accents, info state |
| secondaryContainer | `#D9E6E3` | `#304C48` | Tonal button, neutral badge |
| onSecondaryContainer | `#16302C` | `#CDE7E2` | Text on secondaryContainer |
| surface | `#F4F8F7` | `#0E1413` | Page background (teal-tinted off-white; green-black in dark) |
| surfaceContainerLowest | `#FFFFFF` | `#0A0F0E` | Cards on the page |
| surfaceContainerLow | `#EDF3F1` | `#121A19` | Grouped rows |
| surfaceContainer | `#E7EEEC` | `#172120` | Nav bar |
| surfaceContainerHigh | `#E1E9E7` | `#1F2A28` | Pressed rows, sheets |
| surfaceContainerHighest | `#DAE3E1` | `#263230` | Skeletons |
| onSurface (ink) | `#10201E` | `#E2EBE9` | Body and headings |
| onSurfaceVariant | `#45524F` | `#A8B7B4` | Secondary text |
| outline | `#6F7E7B` | `#869491` | Input borders, focus |
| outlineVariant | `#C6D2CF` | `#3A4745` | Dividers |
| error | `#B3261E` | `#F2B8B5` | Overdue, destructive |
| errorContainer | `#F9DEDC` | `#7A1A15` | Overdue badge fill |
| warning (ext) | `#8A5700` | `#EFC27A` | Due soon, pending |
| warningContainer (ext) | `#FBE7C2` | `#4F3600` | Pending badge fill |

Rules:
- One hue family (teal) plus ink, amber for "due" and red for "overdue". No second blue, no purple, no gradients.
- Accents are tonal (container colours). Never a saturated splash on text.
- Solid actions (filled buttons, the FAB) are `#0F766E` with white text in both themes. In dark mode the light `primary` is for text, marks and the nav indicator only. On the dark page the fill is 3.4:1, and its label is 5.4:1.
- Status never relies on colour alone. Every status pairs colour with a word and a shape mark.

## Type

- **Display face:** Uncut Sans by Kasper Nordkvist, SIL OFL 1.1, not on Google Fonts. Bundled in `assets/fonts/` at 500 and 700 weights. It has the ₹ glyph and tabular figures (`tnum`). Stylistic set `ss04` (single-storey a) gives headings their character.
- **Body face:** the system font (SF Pro on iOS, Roboto on Android). Hindi falls back to the system Devanagari font.
- **Amounts:** Uncut Sans with `tnum`, so columns of rupees line up.

| Role | Face | Size / line | Weight |
|---|---|---|---|
| displayLarge | Uncut | 40 / 44 | 700 |
| displayMedium | Uncut | 32 / 38 | 700 |
| displaySmall | Uncut | 28 / 34 | 700 |
| headlineLarge | Uncut | 26 / 32 | 700 |
| headlineMedium | Uncut | 22 / 28 | 700 |
| headlineSmall | Uncut | 20 / 26 | 700 |
| titleLarge | Uncut | 18 / 24 | 700 |
| titleMedium | system | 16 / 22 | 600 |
| titleSmall | system | 14 / 20 | 600 |
| bodyLarge | system | 16 / 24 | 400 |
| bodyMedium | system | 14 / 20 | 400 |
| bodySmall | system | 12 / 16 | 400 |
| labelLarge | system | 14 / 20 | 600 |
| labelMedium | system | 12 / 16 | 600 |
| labelSmall | system | 11 / 16 | 500 |

Headings hold to one or two lines. Body text never drops below 12.

## Space, shape, depth

- **Spacing:** 4 / 8 rhythm: 2, 4, 8, 12, 16, 24, 32, 40. Screen gutter 16. Section gap 24.
- **Radii:** xs 4, sm 8, md 10, lg 14, xl 20. Buttons and inputs use md. Cards use lg. Sheets use xl on the top corners. No pill buttons.
- **Depth:** cards separate from the page by tone, not by border or shadow. Nothing at rest has a shadow: the FAB is a solid teal fill at elevation 0, and the snackbar uses the inverse surface. The one exception is a popup menu (elevation 2, ink-tinted shadow), because it floats over cards of its own colour.
- **Touch:** every target is at least 48 dp. Targets are at least 8 dp apart.

## Motion

- Durations: fast 120 ms (press), medium 220 ms (state change), slow 360 ms (page-level).
- Curve: `easeOutCubic`.
- Authored motion: the nav indicator slides between tabs, list rows rise 12 px into place, and the rent strip fills from the left. Nothing else moves.
- Content is visible by default. Motion moves things that are already on screen (position, scale, a counting number). Nothing starts at opacity 0.
- `MediaQuery.disableAnimations` turns all of it off.

## Signature pieces

- **Rent month strip** (Home): one row per rent charge this month, drawn as a ledger bar. Paid, partial, due and overdue use the tonal fills above, plus a shape mark. Tap it to open Collections, filtered.
- **Receipt edge:** a perforated edge (`ReceiptEdgeBorder`) on payment confirmations and charge rows. It is the one bespoke silhouette.
- **Nav:** a flush bar on `surfaceContainer`, with a sliding rounded indicator line on the active tab. The active label switches to weight 700 and primary colour. No floating pill, no border and shadow box.

## Icons

Material Symbols, rounded style only. Outlined when idle, filled when selected. Icons stand bare: no tile, chip or circle behind them. Decorative icons beside text are excluded from semantics. Icon-only buttons always have a tooltip.

## Copy

Short. Sentence case. No em dashes. Every string lives in `lib/l10n/arb/app_en.arb` with a Hindi entry in `app_hi.arb`.

Hindi glossary: rent किराया, tenant किरायेदार, lease लीज़, property प्रॉपर्टी, owner मालिक, payment भुगतान, due बकाया, overdue अतिदेय, maintenance रखरखाव, inspection निरीक्षण, expense खर्च, document दस्तावेज़, collection वसूली. Hindi strings were drafted by a model and need a native-speaker review.

## Skill output overridden by the design law

| Skill output | Decision | Reason |
|---|---|---|
| Glassmorphism style | Swiss minimal | Glass is banned unless flawless; a ledger app needs clarity. |
| Hero-centric landing pattern | Not used | It is a web landing pattern, not an app screen pattern. |
| Cinzel + Josefin Sans (Google Fonts) | Uncut Sans + system | Cinzel is the default "luxury" serif. Google fonts are banned as the signature face. |
| Secondary `#14B8A6`, accent `#0369A1` | Tonal teal `#3D5A56`, no second blue | Two saturated hues beside a royal-blue logo collide. |
| Background `#F0FDFA`, border `#99F6E4` | `#F4F8F7`, no card borders | Mint wash and bright borders read as a template. |
| Hover lift, `translateY` on buttons and cards | Ripple and tonal press state | The hover boop is banned; mobile has no hover. |
| `--shadow-md` on every card | Tonal separation, no shadows | The all-around shadow is banned. |
