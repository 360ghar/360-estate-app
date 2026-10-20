# Design-law audit (19 Oct 2026)

A point-by-point check of the UI against the house design law in `~/.claude/CLAUDE.md`. Evidence: the screen tour (55 screens × light, dark, Hindi, 1.5× text = 220 renders in `test/screenshots/goldens/`), full-resolution crops, and grep audits over `lib/`.

Verdicts: **Pass**, **Fixed** (fixed in this audit), **Accepted** (a deliberate exception, with the reason), **Open** (known gap).

## Tells

| Law point | Verdict | Evidence |
|---|---|---|
| Icon pack look, redrawn line icons | Accepted | Material Symbols Rounded, bare, one style. A custom icon set is out of scope. |
| Em dashes | Pass | 0 in `lib/` and the ARB files. `l10n_parity_test.dart` fails on one. |
| Pill / eyebrow badge, kicker over heading | Fixed | The last kicker (property name over the public application title) moved into the muted facts line. |
| Banned fonts (Inter, Space Grotesk, Sora, Syne, Archivo, Fraunces, Cormorant, Didones, Google shelf) | Pass | Uncut Sans (self-hosted, SIL OFL, not on Google Fonts) for display, system font for body. `google_fonts` removed. |
| Glowy pill buttons, hover boop, card hover-lift | Pass | 0 `StadiumBorder`, 0 `BoxShadow`. Buttons use radius 10 and a ripple. |
| Icon in a coloured tile, logo on a box | Pass | Icons and the logo stand bare. The tonal "+" beside the checklist field is a button, not decoration. |
| Floating cards, looping motion | Pass | No loops. Motion: nav indicator slide, 12 px row rise, rent strip fill. |
| Glow, background glow, radial halo, cut-off glow, bloom | Pass | 0 gradients, 0 blur filters. |
| Kitchen-sink card | Pass | Rows hold a title, a subtitle, plain facts, an amount and a status mark. No tiles, no tag pills. |
| Fake window, fake code window, crude illustrations, countdown | Pass | None. "Resend in 29s" is a real timer. |
| Purple, blue-purple, blue-charcoal dark | Pass | One teal family. Dark page is green-black `#0E1413`. |
| Default CTA pair, filled + outlined pair | Accepted | One primary action per screen. The only outline beside a fill is "Continue with Google", which Google's brand rules require. |
| Gradient initials avatar | Accepted | Flat tonal circle with initials. There are no user photos to show. |
| Logo lockup, letterspaced wordmark | Pass | The real 360 Estate mark, single colour in dark mode. |
| Grid / graph-paper background, grain, fixed background | Pass | None. |
| Accent-bar card | Pass | None. The rent strip and the collections bar are data, not ornament. |
| Hairline border on every box | Pass | Cards have no border. Outlines remain on inputs and unselected filter chips, where they mark a control. |
| Mono as house voice, one label treatment everywhere | Pass | No mono. Section titles, field labels and statuses each have their own treatment. No tracked caps. |
| Botched glass | Pass | All glass deleted. |
| Botched fill animation | Pass | The rent strip fill is a clip inside a fixed rounded shape, so the caps never change. |
| Content hidden behind an entrance animation | Pass | `RiseIn` moves position only. Reduce-motion sets the strip to full at once. |
| Clear the cut (receipt edge) | Pass | Zoomed at 3×: content clears the perforation by 20 dp. |
| Ragged parallel columns | Fixed | Collections totals now read Collected, Due, Overdue: the same order as the bar under them. |
| Text against the edge | Pass | 16 dp gutters on every screen, also at 1.5× text. |
| Default all-around shadow, faked shadow, boxy shadow | Accepted | No resting shadows. A popup menu keeps elevation 2 with an ink-tinted shadow, because it floats over cards of its own colour. |
| Missing or faked logos | Pass | Real Google "G", the `sign_in_with_apple` button, the real app logo. |
| Centering | Pass | Status marks and OTP boxes checked at 3×. |
| Colliding colours, hard seams | Pass | One palette. App bar and page share one surface; the nav bar sits on its own floor. |
| Text contrast | Fixed | All text pairs ≥ 4.5:1 (MASTER.md). Dark-mode solid buttons changed from dark text on bright mint to white on `#0F766E` (5.4:1). |
| Saturated accent | Fixed | Same change: dark mode no longer sprays the bright mint on fills. Light `primary` is kept for text, marks and the nav indicator. |
| Dot under the active nav item | Pass | A sliding rounded indicator plus a weight and colour change on the label. |
| Content clipped where layers overlap | Pass | Forms scroll under the submit bar inside the body; nothing is cut at rest. |
| Cramped display type | Pass | `₹2,84,501` at 32 has room between groups. |
| Cream, slop gray | Pass | Page `#F4F8F7` and the containers are teal-tinted, not gray-100. |
| Pastel candy gradient, aurora | Pass | The auth aurora was deleted. |
| Inner-glow badge, pulsing dot | Pass | One flat tonal status block per detail screen; lists use mark + word. |
| Underline hover, sun-moon toggle | Pass | Theme uses a three-way segmented control. |
| Unrounded hairline rules | Accepted | 1 dp dividers stay only between rows inside grouped cards, where they separate tap targets. |
| Tinted metadata chips everywhere | Pass | Facts are plain text in a wrap. Chips appear only as working filters. |
| Dead controls | Pass | 0 empty handlers. Theme and language persist. The push-token tile shows in debug builds only. |

## Signature (is there a point of view?)

| Formula part | What the app has |
|---|---|
| Signature artifact | The rent month card on Home: one ledger bar per charge, filled by state. |
| Bespoke silhouette | The perforated receipt edge on payment, rent and auth cards. |
| Character display face | Uncut Sans with `ss04` (single-storey a) for headings and amounts, tabular figures. |
| Treated nav | Flush bar with a sliding indicator, localized labels, capped text scale. |
| Real specifics | Indian rupee grouping, exact paise, Hindi throughout. |

## Fixed in this audit

1. Dark mode: solid buttons and the FAB are deep teal with white text.
2. `rupees()` keeps paise when present (`₹19,999.50`), so the ledger never rounds money. Test: `test/core/utils/money_test.dart`.
3. Collections totals match the bar order.
4. Public application page: kicker removed.
5. Legal page titles in sentence case. Unused `AppStatusVariant.dot` and `.outline` deleted.

## Open

1. Auth error messages from `auth_controller` and `supabase_auth_error_mapper` are English only.
2. Seed checklist templates in `inspections_providers.dart` are English.
3. Hindi copy was drafted by a model and needs a native-speaker review.
4. Scrollable tab and filter rows show a part-cut last item at the edge (Property detail "Maintenance", Hindi Collections "Paid"). This is the scroll cue; the alternative is shorter labels.
5. Not checked on a real device or simulator: keyboard insets, reduce-motion, and the map screen (it cannot render in tests).
