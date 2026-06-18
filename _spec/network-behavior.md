# IronLink — Missing-Network (Offline) Behavior, per Screen

A per-screen catalogue of behavior when the device has **no internet**. Grounded in `92-offline-states.html` (the reference screen), `offline-model.md`, and `user-flows-detailed.md` (SYS-01 detect, SYS-02 queue/replay, SYS-04 reconnect, JOB-06/08/09).

## Global offline model (applies to every screen unless noted)

- **Signal:** a persistent dark **`.banner--offline`** (`i-wifi-off` + "You're offline — showing saved jobs/data") pinned at the top of the body. Cleared only on reconnect.
- **Cached content** renders at ~`.92` opacity with a stale label (`.is-stale` / muted "Updated Nh ago").
- **Blocked writes** are never hard-blocked: a control either shows an **`.offline-hint`** inline reason ("Internet required") or, for optimistic writes, becomes a **queued** disabled control with `.pending-clock` (clock icon) plus a `.toast` ("… will send when you're back online. Undo").
- **Recovery (SYS-04):** queued actions auto-replay in order, idempotently; lists refresh to fetch server deltas; conflicts surface a warning + Undo before sync; on validation reject a queued item becomes editable `failed` (SYS-02).
- **Never blocked offline:** navigation, reading cached data, and drafting.

Legend for the tables: **Cached/usable** · **Blocked (needs internet)** · **UI signal** · **Recovery on reconnect**.

---

## Onboarding / Auth (10-welcome, 11-role-select, 12-phone-entry, 13-otp-verify, 14-onboard-trades, 15-voice-capture, 16-org-create)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 10 welcome | Static marketing copy, role CTAs | "Get started" → cannot proceed past first network call | `.banner--offline`; CTA disabled + `.offline-hint` "Connect to continue" | CTA re-enables |
| 11 role-select | Role cards render | Selection persist (server) | Selection held locally; "Continue" disabled with hint | Auto-submit selection |
| 12 phone-entry | Number entry, country picker | Send OTP (SMS gateway) | "Send code" disabled + hint "Internet required to text a code" | Re-enable Send |
| 13 otp-verify | Entered digits | Verify code | Verify disabled + hint; resend timer paused | Re-enable Verify/Resend |
| 14 onboard-trades | Trade taxonomy (bundled M2 enums), local multi-select | Persist trade selection | Selections kept locally; "Save" queued/disabled with hint | Queued selection syncs |
| 15 voice-capture | Local audio record buffer | STT transcription + upload | Record disabled or buffered; hint "Transcription needs internet" | Upload + transcribe on reconnect |
| 16 org-create | Form state (name, address, trade) | Create org (server write) | Form filled; "Create" queued/disabled with hint; draft kept | Queued create replays |

Auth is fundamentally online-gated — onboarding cannot complete offline; the model degrades to "fill now, submit on reconnect," never silent failure.

---

## Profile & Pay (20-profile-view, 21-profile-complete, 22-profile-edit, 23-availability, 24-background-check, 30-pay-trends, 31-pay-locked)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 20 profile-view | Identity, trades, experience, certs, photo | Live completeness score, employer-visibility flags, BGC status | `.is-stale` on the live fields; rest fully readable | Refresh recomputes score/flags |
| 21 profile-complete | Checklist state (cached) | Recompute %, mark steps server-side | Progress shown stale; step actions deep-link but their saves queue | Score refreshes |
| 22 profile-edit | All fields editable into local draft | Save to server, photo upload | Fields editable but **Save** shows `.pending-clock` (queued); photo upload hint "Reconnect to upload a new photo" | Auto-sync; **conflict** ("updated elsewhere") → choose version |
| 23 availability | Toggle availability locally | Persist availability | Toggle optimistic + queued | Sync on reconnect |
| 24 background-check | Prior BGC result (cached) | Submit BGC, fetch live status | Submit disabled + hint "Internet required to run a check"; status `.is-stale` | Refresh status |
| 30 pay-trends | Last-fetched p10–p90, trend direction, charts for current trade/region/level | Real-time rates, new skill tiers, **switching trade/region** (new fetch) | Money in `.tabnum`; "Data from 3 days ago" muted; refresh hidden/disabled; locked filters | Refresh; if rates moved >5% banner "Pay rates updated for your area" |
| 31 pay-locked | Paywall copy, teaser | Unlock/subscribe (billing) | Paywall renders; "Unlock" disabled + hint "Connect to upgrade" | Re-enable upgrade CTA |

---

## Jobs (35-search, 40-job-feed, 40a-job-filters, 40b-saved-jobs, 41-job-detail, 42-apply-ai-draft, 43-my-applications)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 35 search | Last results (read-only), recent queries | New query execution (ranking) | Search box disabled + `.offline-hint` "Search requires internet"; cached results faded | Re-enable search |
| 40 job-feed | Browsed list from last session (title, company, wage, distance) | Match scores, recommendations, new listings | `.banner--offline` "showing saved jobs"; cards `.92`; **Apply** disabled → "Internet required. Application queued." | Refresh refetches feed; queued applies send |
| 40a job-filters | Filter UI, current selections | Apply filters (server fetch) | "Apply filters" disabled + hint; selections kept | Re-run filtered fetch |
| 40b saved-jobs | **Full detail** of saved jobs (offline-first) | Re-check live status (filled/paused) | "Saved · available offline" section; cards `.92`; empty → `.empty` "No saved jobs yet" + Browse | Refresh checks live status |
| 41 job-detail | Full cached card (wage, desc, employer, requirements) | Live applicant count, response time, paused/filled status | "Updated 1h ago"; **Apply** disabled + hint; if already applied → "View your application" | Refresh; if filled/paused → banner "This job is no longer active" |
| 42 apply-ai-draft | Editable draft (local), cached prompt | AI (re)generation, **Send application** | "Regenerate" disabled + hint; **Send** → queued `.pending-clock` + toast "Application will send when you're back online. Undo" | Queued application auto-sends (JOB-08); if job filled on drain → editable `failed` "This job was filled" |
| 43 my-applications | Application list (company, role, status, last message, timestamp) + thread history | Live status flips (Hired/Not selected), accurate unread badges, **Withdraw** | Cards "Last updated 6h ago"; badges may be stale; **Withdraw** queued → optimistic "Withdrawn (pending sync)" + Undo | Auto-sync withdrawals (JOB-09); refresh statuses; server change → banner "Updated to Not selected" |

---

## Employer (44-post-job, 44a-job-listings, 44b-job-edit, 45-applicants, 46-applicant-detail, 47-talent-pool, 48-org-profile, 49-org-settings)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 44 post-job | Full form state draft (title, trade, wage, desc, toggles) | Wage realism AI check, **Publish** | Draft "saved locally"; **Publish** disabled + hint "Internet required to publish" | Queued publish syncs; wage-realism banner if below p25 |
| 44a job-listings | Org listings + statuses from last sync (draft/active/paused/filled) | Live applicant counts, status changes | Counts `.is-stale`; pause/close actions queued with pending state | Refresh counts; queued status changes sync |
| 44b job-edit | Editable fields (local) | Save edits, realism re-run | **Save** queued `.pending-clock`; edits kept | Edits drain; concurrent edit → "edited by {member}" last-write-wins notice |
| 45 applicants | Cached applicant list + match % from last sync | New applicants, live re-ranking | List faded; "Updated Nh ago"; sort by match only on cached data | Refresh refetches + re-ranks |
| 46 applicant-detail | Full applicant profile, certs, notes, history | **Hire / Reject / Shortlist**, add note (server) | Pinned bar buttons queued with `.pending-clock`; star (Shortlist) optimistic; note input queued | Hire/Reject queue → replay **idempotently** (JOB-14); worker notified on drain |
| 47 talent-pool | Cached pool entries + notes | New search adds, fresh availability | Entries `.is-stale`; "Add from search" disabled + hint | Refresh pool |
| 48 org-profile | Cached org details, logo | Edit org, logo upload | Edit fields disabled + hint; "Save" queued | Sync edits |
| 49 org-settings | Cached settings, member list | Member invites, feature/permission writes, billing-linked toggles | Toggles disabled + hint "Internet required to change settings"; mode switch hint | Sync setting changes |

---

## Messaging (50-messages-hub, 51-chat-thread)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 50 messages-hub | Conversation list (3 lanes: DM / Applications / Marketplace) with last-message preview + last-synced unread count | Live unread accuracy, new conversations | Each row "Updated 3h ago"; unread badges may be inaccurate | Refresh confirms unread; new threads appear |
| 51 chat-thread | Full text message history; cached attachment links | Send message, typing/read receipts, **Schedule interview / Accept slot**, attachments upload | Composer disabled → "Internet required to send. You can draft offline." (draft saved); sent items show `.pending-clock` next to timestamp; Schedule/Accept queued | Queued messages auto-send **in order**; if thread archived server-side → "Conversation was archived. Your message was not sent. Undo?" |

---

## Feed (60-feed, 61-create-post)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 60 feed | Last 50 posts (text, author, trade/company tags, like/comment counts) | Comment threads, typing, sponsored/AI posts, new posts | Cards faded `.92`; Like/Comment/Share disabled → tap shows "Internet required to engage"; queued like → icon → `.pending-clock` + toast "will post when online. Undo" | Queued likes/comments sync; refresh fetches new posts; deleted-post conflict silently discards queued action |
| 61 create-post | Form draft (text, photo ref) | Photo upload, **Post** | "Draft saved locally"; photo input disabled + hint "Upload requires internet"; **Post** queued + Undo toast | Queued post sends; if image upload fails → "Image upload failed. Retry?" (post not orphaned) |

---

## Marketplace (70-marketplace, 71-listing-detail, 71a-listing-comments, 72-create-listing, 72a-my-listings)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 70 marketplace | Browsed listings (title, price `.tabnum`, seller, location, cached thumbs), saved listings (full) | New listings, live prices/availability, search/filter | "Listing from {date}"; search/filter disabled + hint "Search requires internet"; cards faded | Refresh fetches new listings |
| 71 listing-detail | Full cached listing + photos | Live sold/available status, **Message seller / Inquire** | "Message seller" disabled → "Internet required to contact seller"; or inquiry queued + toast "Your inquiry will send when online" | Auto-send queued inquiry; refresh checks if sold |
| 71a listing-comments | Cached comment thread | Post comment, live new comments | Comment input disabled + hint; existing comments `.is-stale` | Refresh comments; queued comment sends |
| 72 create-listing | Form + photos draft in local storage | Category/condition autocomplete, image upload, **Publish** | Photo upload disabled + hint; **Publish** disabled + hint; "Draft saved locally — N photos pending upload" | Prompt "Resume your equipment listing draft?" → upload pending photos → enable Publish |
| 72a my-listings | Cached own listings + statuses | Mark sold, edit, live view counts | Status `.is-stale`; mark-sold/edit queued with pending | Sync status changes |

---

## Billing (80-plans, 81-paywall, 82-billing-history, 83-payment-method)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 80 plans | Plan tiers + pricing (cached) | **Subscribe / upgrade / downgrade** (payment provider) | Plan cards render; CTA disabled + `.offline-hint` "Connect to manage your plan" | Re-enable CTAs |
| 81 paywall | Paywall messaging, locked-feature teaser | Purchase / start trial | "Unlock" disabled + hint | Re-enable upgrade |
| 82 billing-history | Cached invoices/receipts (money `.tabnum`) | Fetch latest invoices, download PDF | List `.is-stale` "Updated {date}"; download disabled + hint | Refresh invoices |
| 83 payment-method | Masked card on file (cached) | Add/update/remove card, validation | Fields disabled + hint "Internet required to update payment"; **Save** disabled | Re-enable card actions |

Billing is strictly online — no payment write is ever queued/optimistic; all are blocked with a clear inline reason (avoids charging on stale state).

---

## System (90-notifications, 91-settings, 91a-account, 92-offline-states, 93-push-priming)

| Screen | Cached / usable | Blocked | UI signal | Recovery |
|--------|-----------------|---------|-----------|----------|
| 90 notifications | Notification history (text, timestamp, type icon) | Real-time badges, **mark-as-read**, delivery status | Items "From {time synced}"; tab badges may be inaccurate; mark-as-read disabled + hint | Refresh fetches new notifications |
| 91 settings | All cached preference values; navigation | Preference writes, mode switch | Toggles disabled + hint "Internet required to update"; **mode switch** disabled + "Internet required to switch modes" | Auto-sync queued preference changes |
| 91a account | Cached account fields | Email/phone change, delete account, logout-everywhere | Edit disabled + hint; destructive actions disabled (no offline confirm) | Re-enable account actions |
| 92 offline-states | **Reference screen** — itself the canonical demo of `.banner--offline`, faded saved cards, "Application queued" disabled state, queued toast + Undo, and the `.empty` pattern | n/a (documentation surface) | All offline components shown together | n/a |
| 93 push-priming | Priming copy + value explanation (bilingual) | OS push permission grant (needs the moment to matter) | Priming renders; "Enable" still works (OS-level) but the value events it promises won't fire until online | Notifications begin once online |

---

### Consistency notes for auditors

- Only existing offline components are referenced: `.banner--offline`, `.offline-hint`, `.pending-clock`, `.is-stale`, `.synced`, `.toast`, `.empty`. No new components introduced.
- All money examples use `.tabnum`; trades content stays Montgomery AL / HVAC / Electrical with wages $16–$50/hr.
- Writes that change money or identity (billing 80–83, auth OTP, account 91a) are **blocked with inline reasons**, never queued. Content writes (apply, save, withdraw, message, like, post, listing, hire/reject, profile edit) are **queued + replayed** per SYS-02.
