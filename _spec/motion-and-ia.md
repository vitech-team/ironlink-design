# IronLink — Motion, '+' Button, Navigation & Modes

## Motion Spec
## Motion & Interaction Specification

### Screen Push/Pop Transitions
- **Push (entering forward):** 300ms, easing: `cubic-bezier(0.4, 0, 0.2, 1)` (material-standard)
  - Incoming screen: slides in from bottom (transform: translateY(100%) → 0), fades in (opacity: 0 → 1)
  - Outgoing screen: stays in place, subtle scrim appears beneath
- **Pop (going back):** 250ms, easing: `cubic-bezier(0.4, 0, 0.2, 1)`
  - Outgoing screen: slides down (transform: translateY(0) → 100%), fades out
  - Scrim fades out; incoming screen (now visible below) is unaffected

### Modal / Bottom Sheet Slide + Scrim Fade
- **Sheet enter:** 280ms, easing: `cubic-bezier(0.3, 0, 0.4, 1)` (entrance)
  - Sheet: translateY(100%) → 0 + opacity 0 → 1
  - Scrim: opacity 0 → 0.45 (rgba(22, 33, 56, 0.45))
  - Grab handle and content enter together
- **Sheet exit:** 200ms, easing: `cubic-bezier(0.4, 0.4, 0.2, 1)` (exit)
  - Sheet: translateY(0) → 100% + opacity 1 → 0
  - Scrim: opacity 0.45 → 0

### Tab Switching (Underline Tabs + Tab Bar Tabs)
- **Underline indicator:** 200ms, easing: `cubic-bezier(0.4, 0, 0.2, 1)`
  - Yellow underline (border-color) animates: scaleX(0.8) → 1 on the new active button
  - Text color transitions: text-2 (gray) → text-1 (navy) simultaneously
- **Tab bar icon + label:** 150ms, easing: `linear`
  - Icon color: text-3 → ink (or yellow for FAB)
  - Label color: text-3 → ink simultaneously

### Pull-to-Refresh on Feed
- **Pull drag state (0–100px pull):** no animation, real-time transform
  - Refresh icon rotates: 0deg → 360deg (continuous as user pulls)
  - Icon opacity: 0.4 → 1
  - When pull exceeds 60px threshold, icon briefly scales 1 → 1.15
- **Trigger + refresh animation (once released above threshold):** 400ms
  - Icon: spin 360deg at 1x speed, repeat until data arrives
  - Once data arrives: spinner stops, fade out (opacity 1 → 0) over 200ms
  - New content slides in from top (translateY(-20px) → 0) over 300ms, easing ease-out
- **Cancel pull (released below threshold):** 200ms
  - Icon returns to initial state, translateY snaps back to 0

### Skeleton / Shimmer Loading Placeholders
- **Skeleton blocks:** subtle animated gradient sweep, 1.2s infinite loop
  - Base background: --surface-2 (off-white)
  - Animated shimmer: linear-gradient(90deg, transparent, rgba(255,255,255,.4), transparent)
  - Animation: moveShimmer 1.2s infinite linear (translateX from -100% → 100%)
  - Skeleton blocks: 80% opacity, rounded to match card radius (--r-lg)
- **Apply to:** avatar placeholders (56px circles), text lines (h3: 60% width, body: 100% width × 2 lines), card skeletons

### Scroll Behaviors
- **Collapsing app bar (optional on detail screens):**
  - On scroll down: header shrinks, padding reduces, opacity fades slightly (200ms per scroll event, throttled at 16ms intervals)
  - On scroll up: header expands back (150ms ease-out)
- **Hide-on-scroll tab bar (feed only, not jobs/messages):**
  - Tab bar slides down (translateY(92px) → 0) when scrolling down
  - Tab bar slides up (translateY(0) → 92px) when scrolling up
  - Debounce: 300ms after scroll ends before animating back in
  - Scrim stays visible always; no scrim fade-in/out

### Button Press Feedback
- **Interactive buttons (.btn, .iconbtn, .tabbar__item):**
  - On active/press: scale(0.98) over 80ms, ease-out-cubic
  - On release: scale(1) over 100ms, ease-out
  - Background color transitions on hover/active states: 150ms
  - Box-shadow transitions: 150ms (for .btn primary)

### Toast / Snackbar Slide-In
- **Enter:** 300ms, easing: `cubic-bezier(0.3, 0, 0.4, 1)`
  - Toast slides in from bottom (translateY(100%) → 0) + fades in (opacity 0 → 1)
  - Appears above tab bar, 60px from bottom with --s4 (16px) padding
- **Exit (auto-dismiss after 3s):** 200ms, easing: `cubic-bezier(0.4, 0, 0.2, 1)`
  - Toast slides down (translateY(0) → 100%) + fades out

### FAB / '+' Button Expand into Menu
- **Closed → Open:** 280ms, easing: `cubic-bezier(0.3, 0, 0.4, 1)` (entrance)
  - FAB scale: 1 → 1 (no scale; stays full size)
  - Menu items (if using radial menu): enter with staggered delays (0ms, 60ms, 120ms, 180ms)
  - Each menu item: opacity 0 → 1 + translateY(20px) → 0 (staggered)
  - Scrim (optional behind menu): opacity 0 → 0.45
  - FAB icon rotates: 0deg → 45deg (if using "X" close icon)
- **Open → Closed:** 200ms, easing: `cubic-bezier(0.4, 0, 0.2, 1)` (exit)
  - Menu items: exit in reverse order with staggered delays
  - FAB icon rotates: 45deg → 0deg

### Additional Timing Rules
- **Icon animations (general):** 150ms for color transitions, 200ms for rotation
- **Text transitions:** 150ms for color changes
- **List item slide-in (e.g., new messages, feed refresh):** 200ms per item, staggered 30ms
- **All easing defaults:** cubic-bezier(0.4, 0, 0.2, 1) unless otherwise specified

## The '+' Button
## The '+' Button (FAB) Behavior — Context-Aware Create Menu

The '+' button is a context-aware **floating action button (FAB)** in the center of the bottom tab bar. It expands into a **bottom-sheet style action menu** with options that differ per mode and context.

### Worker Mode
**Menu Options (when tapped):**
1. **New Post** — Opens feed post composer (text + photo)
2. **Create Offer** — Start a marketplace equipment listing (trade equipment sale)
3. **Share Job** — Share a job listing to feed (reshare from Jobs tab)

**Visual:** Yellow FAB with navy '+' icon. Menu items slide in vertically above the FAB in sequence (staggered 60ms). Scrim behind menu fades in. When menu is open, FAB icon rotates 0° → 45° (becoming an 'X' for close).

**Tap behavior:**
- Tap FAB: menu expands
- Tap menu item: navigates to corresponding create screen (push transition)
- Tap scrim or 'X': menu collapses
- Selecting an option: menu auto-closes, screen pushes in

### Employer Mode
**Menu Options (when tapped):**
1. **Post a Job** — Opens job composer (trade, title, wage, etc.)
2. **New Post** — Opens feed post composer (as org or self)
3. **Create Equipment Listing** — Start a marketplace equipment listing
4. **Reach Out** — Start a direct message to someone in the talent pool

**Visual:** Navy FAB with yellow '+' icon (inverted from worker mode for visual distinction). Same staggered menu slide-in. Scrim behind. FAB icon rotates 45° on open.

**Tap behavior:**
- Same as worker: menu expands, options navigate to respective screens
- When on the Talent Pool tab: "Reach Out" pre-fills the recipient search
- Same tap/cancel rules

### Marketplace Context (Both Modes)
When a user is browsing the marketplace (screen 70–71) while logged in but NOT in marketplace create mode:
- **Menu Options:**
  1. **Post Equipment** — Only if user has active marketplace subscription
  2. **Browse More** — Refine search filters
  3. **Saved Items** — Jump to saved listings

If user is NOT subscribed, "Post Equipment" is disabled (grayed out, tooltip: "Subscribe to list items").

### No Mode Switcher on FAB
The '+' button does **NOT** include a mode switch option. Mode switching is accessed via Settings or a dedicated mode-switcher sheet (screen 94) triggered from the user avatar or a menu.

### Animation Timing
- **Menu expand:** 280ms, easing cubic-bezier(0.3, 0, 0.4, 1)
- **Menu items:** staggered entry at 0ms, 60ms, 120ms, 180ms
- **Menu collapse:** 200ms, easing cubic-bezier(0.4, 0, 0.2, 1), reverse stagger
- **FAB icon rotation:** 0° → 45° (open) / 45° → 0° (close) over 280ms

## Navigation & Modes
## Navigation, Modes & Tab Bar Architecture

### Three User Modes
IronLink has three distinct user contexts:

1. **Worker Mode** — Job seeker, individual contributor
2. **Employer Mode** — Hiring manager, recruiter, org member
3. **Marketplace Mode** — Buy & sell equipment; a **first-class mode** entered from the mode switcher exactly like Worker/Employer (own tab bar: Browse · Saved · + · Listings · Messages)

A single authenticated user account holds all three contexts. Mode switching is intentional and less frequent (minutes/hours, not seconds), done from the avatar → mode switcher (94).

### Worker Mode Tab Bar
Located at bottom, 5 items + elevated FAB:

| Position | Tab | Icon | Target |
|----------|-----|------|--------|
| 1        | Network | network-icon | Feed home (For You / Following / Nearby / News tabs) |
| 2        | Trends | trends-icon | Pay Trends & Analytics (per-trade, per-location benchmarking) |
| FAB      | **+ (yellow)** | plus-icon | Create menu (New Post, Create Equipment, Share Job) |
| 4        | Jobs | jobs-icon | Job Discovery feed (search, filter, sort, apply) |
| 5        | Messages | message-icon | Messaging hub (Direct / Applications / Marketplace inboxes) |

**Default landing:** Network tab after login
**FAB color:** Yellow (--yellow) with navy icon
**Active indicator:** Icon + label color change navy (--ink); inactive = gray (--text-3)

### Employer Mode Tab Bar
Located at bottom, 5 items + elevated FAB:

| Position | Tab | Icon | Target |
|----------|-----|------|--------|
| 1        | Home | home-icon | Org/company home (feed-like experience, org posts + system alerts) |
| 2        | Jobs | jobs-icon | Job listings management (create, edit, pause, view applicants) |
| FAB      | **+ (navy)** | plus-icon | Create menu (Post Job, New Post, Equipment Listing, Reach Out) |
| 4        | Talent | network-icon | Talent pool (applicants, favorites, notes, search) |
| 5        | Messages | message-icon | Messaging hub (Applications / Direct / Marketplace inboxes) |

**Default landing:** Home tab after login
**FAB color:** Navy (--ink) with yellow icon (visual inversion from worker)
**Active indicator:** Same as worker mode

### Marketplace Mode Tab Bar
Marketplace is its **own mode** with its own bottom tab bar (entered from the mode switcher, like Worker/Employer):

| Position | Tab | Icon | Target |
|----------|-----|------|--------|
| 1        | Browse | i-truck | Equipment grid (screen 70) — mode home |
| 2        | Saved | i-bookmark | Saved/bookmarked listings |
| FAB      | **+** | i-plus | List equipment (create, screen 72) |
| 4        | Listings | i-doc | My listings (screen 72a) |
| 5        | Messages | i-message | Marketplace inquiries inbox |

- **Default landing:** Browse (70) after switching into Marketplace mode.
- Equipment-listing cards in the Worker feed and shared deep links still open a listing detail (71), and entering Marketplace mode is also reachable from the create "+" menu's "List equipment" — but the canonical entry is the **mode switcher** (94).
- Browsing, viewing contact info, inquiring and commenting are open to any authenticated user; **posting** a listing is subscription-gated.

### Mode Switching (How It Works)
Mode switching is a **deliberate action**, not automatic:

1. **Trigger:** User taps profile avatar (top-right of app bar) on any screen
2. **Sheet opens:** Mode switcher bottom sheet (new screen 94) slides up
3. **Options:** 
   - Current mode shows as active (e.g., "Worker" with checkmark)
   - Alternative mode shown (e.g., "Employer")
   - Settings icon (gear) at bottom for account settings
4. **Select:** Tap alternate mode
5. **Action:** Screen pops back to **HOME tab of the new mode**
   - Worker mode → Network tab (screen 60)
   - Employer mode → Home tab (if implemented, similar to screen 60 but org-focused)

### Messaging Hub Structure (Both Modes)
The Messages tab (screen 50) is universal. It splits conversations into **three inboxes:**

1. **Direct Messages** — Peer-to-peer chats (not tied to a job or listing)
2. **Applications** — Worker: conversations from applied jobs; Employer: applicant threads
3. **Marketplace** — Inquiries & negotiations on equipment listings

Unread badges appear per inbox and per conversation.

### Marketplace Subscription & Feature Gates
- **Free users:** Can browse marketplace, view details, send inquiry (opens chat thread)
- **Subscribed users:** Can post listings, edit, mark sold, comment on listings
- If user is in employer mode with an active org subscription: Can post on behalf of org
- **In-app paywall:** Screens 80–81 show plan options and upgrade flow

### Tab Bar Transitions
When switching modes:
- Current screen closes (pop animation)
- Home tab of new mode opens (push animation)
- Tab bar updates to show new mode's tabs
- FAB color inverts (yellow ↔ navy)
- All unread badges persist (message state survives mode switch)