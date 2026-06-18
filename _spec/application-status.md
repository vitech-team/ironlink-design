# IronLink — Application Status Model

How a job application's status changes as a result of **exact user actions** — which button, on which screen, by whom. Grounded in `user-flows-detailed.md` (JOB-08 apply, JOB-09 withdraw, JOB-11 worker outcome, JOB-13 job management, JOB-14 applicant management) and `user-capabilities.md` (Applying; Applicant Management; Communication).

Canonical states (one term per screen, used everywhere):

| Status | Tag style (design) | Meaning | Set by |
|--------|--------------------|---------|--------|
| **Applied** | `tag--info` | Application submitted, awaiting employer review | Worker (JOB-08) |
| **Shortlisted** | `tag--pos tag--dot` | Employer flagged the applicant (= favourite/star); also adds to talent pool | Employer (JOB-14) |
| **Interviewing** | `tag--warn tag--dot` | An interview slot has been proposed/accepted in the thread | Employer proposes, worker accepts (MSG / 51) |
| **Hired** | `tag--pos tag--dot` | Employer hired the applicant | Employer (JOB-14) |
| **Not selected** (Rejected) | `tag--neg tag--dot` | Employer rejected the applicant | Employer (JOB-14) |
| **Withdrawn** | muted / `tag` | Worker pulled their own application | Worker (JOB-09) |

Worker-facing copy uses **"Not selected"** for the rejected state (43-my-applications); the underlying record is `status=rejected`.

---

## State machine

```
                         applied
                            │
        ┌───────────────────┼──────────────────────┐
        │ (employer)        │ (employer)            │ (worker)
        ▼                   ▼                        ▼
   shortlisted ───► interview scheduled         withdrawn  (terminal)
        │                   │
        │ (employer)        │ (employer)
        └─────────┬─────────┘
                  ▼
          ┌───────┴────────┐
       hired            rejected
     (terminal)        (terminal*)
```

- **shortlisted** and **interview scheduled** are non-blocking intermediate states — an employer can hire/reject directly from `applied` without passing through them.
- *Terminal\* (rejected):* the application record is closed, but the **thread stays open and messageable** and **no re-apply is allowed** (see re-apply rule below).
- **withdrawn** is worker-initiated and only reachable from a non-terminal state (`applied` / `shortlisted` / `interviewing`), never after hire/reject.

---

## Transitions — trigger, screen, actor, result

| # | From → To | Trigger (exact action) | Screen | Actor | Result / side effects |
|---|-----------|------------------------|--------|-------|------------------------|
| T1 | (none) → **applied** | Tap **Send application** on the AI-draft apply sheet (the edited draft becomes the thread's opening message) | 42-apply-ai-draft (from 41-job-detail Apply) | Worker | Creates `applications` record (UNIQUE job_id+worker_id) + opens a job-application thread; M9 `job_applied`; employer gets push + in-app "New applicant for {Job}". Worker sees in-app confirmation. JOB-08 |
| T2 | applied → **shortlisted** | Tap the **star** in the applicant-detail appbar (toggles the `Shortlisted` flag) | 46-applicant-detail | Employer | Sets the shortlist flag; **also adds/updates the worker in the org talent pool** (47). Worker not necessarily notified (assumed in-app only). Reversible by toggling the star off (back to applied). JOB-14 |
| T3 | applied / shortlisted → **interview scheduled** (Interviewing) | Employer taps **Schedule interview** in the thread, proposes a slot; worker taps **Accept** on the proposal bubble | 51-chat-thread | Employer proposes, **worker accepts** | Confirmed slot; application shows **Interviewing** (`tag--warn`) in the worker pipeline (43). See "Schedule action" section below. |
| T4 | applied / shortlisted / interviewing → **Hired** | Tap **Hire** (primary yellow) on the pinned action bar → confirm dialog (98) | 46-applicant-detail | Employer | `applications.status = hired`; M9 `application_status_changed`; worker gets **push + in-app + email "You're hired for {Job}!"** (JOB-11, cannot be disabled). Worker pipeline card flips to **Hired** (`tag--pos`) with "Message employer to confirm start date" shortcut. Multiple hires per job are allowed (each application independent). After hiring, employer is prompted "Close this job?" (JOB-13). JOB-14 |
| T5 | applied / shortlisted / interviewing → **Rejected** ("Not selected") | Tap **Reject** (danger ghost) on the pinned action bar → confirm dialog (98) | 46-applicant-detail | Employer | `applications.status = rejected`; M9 event; worker gets in-app (+ optional push) "Update on your {Job} application," phrased supportively. Worker pipeline card flips to **Not selected** (`tag--neg`) with a **"See 5 similar jobs"** re-engagement shortcut (43). Employer prompted "Keep in talent pool for future roles." Thread remains open. JOB-11 |
| T6 | applied / shortlisted / interviewing → **Withdrawn** | Tap **Withdraw** in the application detail / thread context menu → confirmation explaining the thread stays open and re-apply is blocked | 43-my-applications → application detail (and thread context menu, assumed) | Worker | `applications.status = withdrawn`; compensating M9 event; **thread persists**; employer may be notified (assumed in-app only). The job's Apply button stays "Applied/Withdrawn" — no re-apply. After withdrawing, worker offered "Browse other {trade} jobs." JOB-09 |

---

## Worker withdraw (JOB-09 / 43)

- **Where:** My Applications (43) → open the application → **Withdraw**; also from the job-application thread context menu (assumed).
- **Precondition:** application is in a non-terminal state (`applied` / `shortlisted` / `interviewing`). If the application is already **Hired** or **Not selected**, Withdraw is **hidden/disabled** with an explanation.
- **Confirmation:** dialog states (a) the conversation thread stays open, and (b) the worker **cannot re-apply** to the same job.
- **Result:** `status=withdrawn`, thread preserved, no re-apply path. On the job detail the Apply button shows "Applied/Withdrawn," never reverting to a fresh "Apply."
- **Offline:** withdrawal is queued with an optimistic "Withdrawn (pending sync)" state and an Undo toast (SYS-02); replays idempotently on reconnect.

## Re-apply-after-reject rule

A worker **cannot apply to the same job twice** (DB-enforced UNIQUE `job_id + worker_id`). If a prior application was **rejected** (or withdrawn):

- The existing application record and its **thread remain open and messageable** — closed applications stay visible in history (capabilities §Applying, §Communication).
- On the job detail (41), the **Apply button is replaced by "View your application"**, which deep-links to the existing thread / status (JOB-10) rather than creating a new application.
- There is **no "re-apply" affordance** anywhere; the worker continues the conversation in the existing thread.

---

## ITEM 5 — The "Schedule" action in the application thread (51)

**What it is.** "Schedule interview" is a quick action pinned in the context banner of a job-application thread (51-chat-thread), directly beside "View job." It lets the **employer propose a specific interview date/time tied to that application** — it is *not* a generic calendar invite and *not* a separate full-screen picker; the proposal is created and answered inline in the thread.

**Who initiates.** The **employer** (any org member who can act on the application). The worker does not see a "Schedule interview" button to initiate; the action is employer-driven, consistent with the thread's "Invite to interview / Request availability / Send location" employer quick-replies.

**How the worker responds.** The proposed slot appears as a message in the thread (a proposal bubble showing the date/time). The worker responds **inside the thread** by **Accept** or **Decline**:

- **Accept** → the slot is confirmed; the linked application moves to **Interviewing** (`tag--warn tag--dot`), visible in the worker's pipeline (43) and the employer's applicant view.
- **Decline** (or "propose another time") → no status change; the thread continues so the employer can propose a new slot.

**Resulting status change.** A confirmed (accepted) interview proposal sets the application to **interview scheduled / Interviewing**. This is an intermediate state — the employer still finishes the loop with **Hire** or **Reject** on 46-applicant-detail (T4 / T5). These accept/reject/withdraw actions are executed via M1 (the application domain), not by the messaging system itself — messaging only surfaces the controls (capabilities §Communication).

**Offline.** The thread is readable offline; tapping Schedule / Accept while offline queues the action with a pending state and sends on reconnect (SYS-02 / offline-model "Messaging").
