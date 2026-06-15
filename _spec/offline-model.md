# IronLink — Offline / Caching Model

### IronLink Offline Model — Resilience per App Area

**Overall Signal:**
- **Top persistent banner** (dark, fixed): 'You're offline — showing cached data' with icon wifi-off. Dismissed only when reconnected.
- **Disabled/queued buttons** show inline reason: 'Internet required' or clock icon 'Queued' (for optimistic writes).
- **Toast notifications** confirm queued actions: 'Application will send when you reconnect' with 'Undo' link.
- **Last updated timestamp** shown on cached content: 'Updated 2 hours ago' (small, muted text).

---

#### **Feed (60-61)**
- **CACHED:** Last 50 posts loaded (text, author name, trade/company tags, like/comment counts).
- **NOT CACHED:** Real-time comment threads, live typing indicators, sponsored/AI-recommended posts, new posts since last sync.
- **UI Signal:** All cards render but slightly faded (opacity .92). 'Like', 'Comment', 'Share' buttons disabled; tapping shows inline toast: 'Internet required to engage.'
- **Queued actions:** User taps 'Like' or 'Comment' while offline → queued (optimistic UI: button highlights; icon changes to clock). Toast: 'Your like will post when online. Undo.'
- **Reconnect behavior:** Queued actions auto-sync. Refresh feed to fetch new posts since last cache. If conflict (post was deleted by author), silently discard queued like/comment.

---

#### **Jobs / Job Feed (40, 41)**
- **CACHED:** Saved jobs (full detail: title, wage, company, description, requirements). Browsed jobs from last session (summarized list only: title, company, wage, distance).
- **NOT CACHED:** Real-time matching score, job recommendations, new listings, filter results (trade-specific, location-specific).
- **UI Signal:**
  - Saved jobs tagged 'Saved' and shown under 'Saved · available offline' section (see 92-offline-states).
  - Job cards faded (.92 opacity) to signal they're cached.
  - 'Apply' button disabled; tapping shows: 'Internet required. Application queued.' with a clock icon.
- **Queued actions:** Applications are queued with a disabled state on the card: 'Application queued' (clock icon). Toast: 'Application will send when you reconnect. Undo.' Queued apps persist in localStorage; retry on reconnect.
- **Empty state offline:** If no saved jobs, show .empty block: 'No saved jobs offline. Save jobs to view them here.' with a 'Browse' button (disabled when offline).
- **Reconnect behavior:** Queued applications auto-send. Resume live job feed with refresh icon to refetch new listings.

---

#### **Job Detail (41)**
- **CACHED:** Full job card (title, wage, location, description, employer profile, requirements).
- **NOT CACHED:** Updated applicant count, employer response time, real-time job status (paused/filled).
- **UI Signal:** Job detail card has faint 'Last updated 1h ago' label. 'Apply' button disabled; shows 'Internet required' inline.
- **Queued actions:** Same as job feed — application queued with undo.
- **Reconnect:** Refresh to check if job is still active; if filled/paused, show banner: 'This job is no longer active.'

---

#### **Applications / Pipeline (43)**
- **CACHED:** Application list (company, role, status, last message preview, timestamp). Application thread history (messages, attachments).
- **NOT CACHED:** Real-time status updates (e.g., employer just marked as 'Hired'), unread message badges, typing indicators.
- **UI Signal:**
  - Application cards show last-synced timestamp: 'Last updated 6h ago' (muted).
  - 'Withdraw' button disabled offline; shows inline 'Internet required.'
  - Message badges may be stale (users won't know if new messages arrived while offline).
- **Queued actions:** User taps 'Withdraw' while offline → queued with undo toast.
- **Reconnect behavior:** Auto-sync queued withdrawals. Refresh list to fetch latest application statuses and new messages. If app status changed server-side (e.g., rejected), show banner: 'This application was updated to Not selected.'

---

#### **Messaging / Conversations (50, 51)**
- **CACHED:** Conversation list (name, last message preview, unread count from last sync). Full message history for each conversation (text only; attachments are links to cached URLs if downloaded).
- **NOT CACHED:** Unread badges (become stale), typing indicators, read receipts, real-time message delivery.
- **UI Signal:**
  - Conversation list shows 'Updated 3h ago' on each row (muted). Unread badges may be inaccurate; refresh to confirm.
  - Message input box disabled; tapping shows: 'Internet required to send. You can draft offline.' with a textarea placeholder 'Draft your message here.' Draft is saved to localStorage.
  - Sent messages in history marked with a small pending icon (clock) next to timestamp.
- **Queued actions:**
  - User types message and tries to send → message queued (shown in thread with a pending icon, not sent yet).
  - Toast: 'Message queued — will send when you're online. Undo.'
  - All queued messages persist in localStorage per conversation ID.
- **Reconnect behavior:**
  - All queued messages auto-send in order.
  - Refresh conversation to fetch any new messages from other party.
  - If queued message conflicts (e.g., conversation was archived server-side), show warning: 'Conversation was archived. Your message was not sent. Undo?'

---

#### **Pay Analytics / Trends (30)**
- **CACHED:** Last-fetched pay data for user's trade, location, and experience level (p10, p25, p50, p75, p90, trend direction). Charts stored as SVG or simple data arrays.
- **NOT CACHED:** Real-time updates to rates, regional trends, new skill-based rate tiers.
- **UI Signal:**
  - All data labeled 'Data from [date last updated — e.g. 3 days ago]' (small, muted).
  - No refresh button shown offline (or disabled).
  - Tabs/filters disabled if they require new data fetch (e.g., switching to a different trade).
- **Reconnect behavior:** Refresh data; if rates have changed significantly (>5%), show info banner: 'Pay rates updated for your area.' Re-render charts.

---

#### **Marketplace Browse & Detail (70, 71)**
- **CACHED:** Browsed listings (title, price, seller name, location, thumbnail image URLs — if cached in browser image cache). Saved/bookmarked listings (full detail).
- **NOT CACHED:** New listings, real-time seller availability, updated prices on live listings, search results.
- **UI Signal:**
  - 'Message seller' button disabled offline; shows 'Internet required to contact seller.'
  - Listing cards show 'Listing from [date]' (muted).
  - Search/filter inputs disabled if they require a server fetch; show inline: 'Search requires internet.'
- **Queued actions:** User taps 'Inquire' or 'Message seller' while offline → inquiry queued with toast: 'Your inquiry will send when online.' (Cannot queue messages to seller; must send when connected.)
- **Reconnect behavior:** Auto-send queued inquiries. Refresh listing detail to check if sold or still available.

---

#### **Marketplace Create Listing (72-create-listing, implied)**
- **CACHED:** Form state (title, description, photos, price) — saved as a draft in localStorage.
- **NOT CACHED:** Category/condition autocomplete, image upload.
- **UI Signal:**
  - Photo upload disabled; shows 'Internet required to upload photos.'
  - 'Publish' button disabled; shows 'Internet required to publish.'
  - Draft status: 'Draft saved locally — 4 photos pending upload.'
- **Queued actions:** Draft and form state persist in localStorage. User can resume editing when reconnected.
- **Reconnect behavior:** On reconnect, prompt: 'Resume your equipment listing draft?' If yes, show upload flow for pending photos, then enable 'Publish' button.

---

#### **Notifications (90)**
- **CACHED:** Notification history (text, timestamp, type icon).
- **NOT CACHED:** Real-time notification badges, push delivery status.
- **UI Signal:**
  - All notifications marked 'Cached' or 'From [time last synced]' (muted).
  - Notification badges in tab bar may be inaccurate; refresh to confirm.
  - Mark-as-read action disabled; shows inline 'Internet required.'
- **Reconnect behavior:** Refresh notification list to fetch any new notifications that arrived while offline.

---

#### **Profile & Settings (20, 21, 91)**
- **CACHED:** User's profile fields (name, trades, location, experience entries, certifications, profile photo).
- **NOT CACHED:** Real-time profile completeness score, employer visibility flags, background check status.
- **UI Signal:**
  - Edit fields disabled offline; show inline: 'Internet required to update profile.'
  - Profile photo upload disabled; show hint: 'Reconnect to upload a new photo.'
  - Mode switch disabled; shows 'Internet required to switch modes.'
- **Queued actions:** User edits a field and tries to save → queued in localStorage. Toast: 'Changes queued — will sync when online. Undo.' Save button shows pending state (disabled, clock icon).
- **Reconnect behavior:** Auto-sync queued profile updates. If conflict (another device updated the same field), show warning: 'Profile was updated elsewhere. Discard local changes?' and show both versions.

---

#### **Create Post (61, implied)**
- **CACHED:** Form state (text, photo attachment reference).
- **NOT CACHED:** Photo upload, submission to feed.
- **UI Signal:**
  - 'Post' button disabled; shows 'Internet required to post.'
  - Photo attachment input disabled; shows 'Upload requires internet.'
  - Draft auto-saved to localStorage: 'Draft saved locally.'
- **Queued actions:** User composes post, taps 'Post' while offline → queued with undo toast.
- **Reconnect behavior:** Auto-send queued posts. If image upload fails on reconnect, show error: 'Image upload failed. Retry?' (do not orphan the post).

---

#### **Create Job Listing (44, employer)**
- **CACHED:** Form state (title, trade, wage range, description, requirements, toggles).
- **NOT CACHED:** Wage realism check (AI banner with suggested range), form submission.
- **UI Signal:**
  - 'Publish' button disabled; shows 'Internet required to publish.'
  - Draft auto-saved: 'Draft saved locally.'
- **Queued actions:** User taps 'Publish' while offline → queued with undo toast.
- **Reconnect behavior:** Auto-sync queued job publish. Show wage realism check banner on reconnect if wage falls below p25.

---

### Summary of Cache Strategy

| **Area** | **What's Cached** | **What's NOT** | **Key Signal** |
|----------|-------------------|----------------|----------------|
| Feed | Last 50 posts (text, counts) | Comments, sponsored, live posts | Banner 'offline'; disabled engagements; queued likes/comments |
| Jobs | Saved jobs (full), browsed list (summary) | Recommendations, new listings, scores | Faded cards; 'Internet required'; queued applies |
| Messages | Thread history (text), list (preview) | Typing, unread accuracy, read receipts | Cached timestamp; pending sent messages; queued sends |
| Pay analytics | Last-fetched rates & trends | Real-time updates, new skill tiers | 'Data from [date]'; no refresh offline |
| Marketplace | Browsed/saved listings (detail+thumb) | New listings, prices, live availability | 'Internet required' for contact; queued inquiries |
| Profile | User identity, experience, photo | Completeness score, visibility, BGC status | Edit disabled; queued profile updates |
| Notifications | History | Real-time badges | Stale badge counts; 'Cached' label |

### Guidelines for Implementation

1. **Persistent offline banner** at top of every screen: dark background, wifi-off icon, 'You're offline — showing cached data.'
2. **Disabled buttons** show reason inline (13px, muted): 'Internet required' or 'Application queued' (with clock icon).
3. **Queued actions** appear in UI with a pending/clock state; toast confirms 'will send when online' + undo link.
4. **Timestamps** on cached data: 'Updated 2h ago' (small, faint text).
5. **Empty states offline** (e.g., no saved jobs) direct user to take action on reconnect: 'Save jobs to use offline.'
6. **No hard blocks:** User can always navigate, read, and draft offline. Sending/publishing is queued, not blocked.
7. **Graceful reconnect:** Auto-sync queued actions on network restoration. Refresh lists to fetch new server data.
8. **Conflict resolution:** If server state conflicts with queued action (e.g., job filled, post deleted), show warning and offer undo before syncing.