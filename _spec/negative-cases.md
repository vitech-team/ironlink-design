# IronLink — Negative / Edge UI States

## Image/photo failed to load [P1]
- **Where:** Profile photos (avatars, org logos), job listing images, feed post images, marketplace equipment photos
- **Behavior:** Show a dimmed/muted placeholder icon (cloud outline, camera, or building icon) in the same dimensions as the intended image. If user taps it, show an inline error message: 'Image failed to load' with a 'Retry' button. On retry, either reload or show a file picker (on marketplace listings, allow re-upload). Do not block the screen.

## Missing profile photo [P1]
- **Where:** Worker profile screens (20, 21), employer org profile, any user avatar in messages/conversations
- **Behavior:** Use system-generated avatar (initials on colored background using avatar--sm/lg classes). Show a camera icon overlay with a subtle 'Add photo' hint. Tap opens camera or photo library. On 20-21 profile screens, show an empty-state card: 'Profile photo' with a primary 'Upload photo' button and a secondary 'Skip' link.

## Photo upload failed [P1]
- **Where:** Profile photo upload (20-21), marketplace listing photos (72-create-listing, implied), message attachments
- **Behavior:** Show an error banner: 'Upload failed — check file size/type' with a 'Retry' button. Keep the file input/camera picker accessible. Prevent form submission (Publish button stays disabled) until upload succeeds. For marketplace, allow multiple attempts; show queued/pending states for each photo.

## Form validation: wage range missing [P1]
- **Where:** 44-post-job (employer job composer)
- **Behavior:** Inline error on wage field: 'Wage range is required to publish'. Color field border danger-red. Keep 'Publish' button visually disabled (btn--disabled) and aria-disabled. Show hint: 'Enter min and max hourly rate'. If user tries to click Publish, show toast: 'Complete required fields before publishing.'

## Form validation: job title missing [P1]
- **Where:** 44-post-job
- **Behavior:** Same as wage: inline error, danger-red border, disabled Publish button. Hint: 'Job title is required (e.g. HVAC Service Technician)'.

## Wrong/expired OTP [P1]
- **Where:** 13-otp-verify (OTP input screen)
- **Behavior:** After user submits 6 digits and taps Submit: if wrong, show error banner below the OTP cells: 'Incorrect code. You have 2 attempts left.' Clear the input. If all attempts exhausted, show: 'Too many attempts. Resend a new code.' with a 'Resend' button that re-triggers SMS/email. If code expired (typically 10 min), show: 'Code expired. We sent a new one to +1-334-555-1234.'

## Empty search results [P1]
- **Where:** 40-job-feed (with active search filter), 70-marketplace (with search/filter), 50-messages (search conversations)
- **Behavior:** Swap the list for an .empty block: icon (search or bookmark), heading 'No jobs found', description 'Try different keywords, location, or trade.' Primary button 'Clear filters' or 'Browse all jobs'. On job feed, show chips for active filters (trade, location, wage) with X to remove each.

## Expired session / force logout [P1]
- **Where:** Any screen after token expires (e.g., user left app idle for 7 days)
- **Behavior:** Intercept at navigation boundary: show a modal/fullscreen alert: 'Session expired. Please sign in again.' with a single 'Sign in' button. Clear app state, redirect to 12-phone-entry login screen. Do not leave user in an in-between state. Preserve any unsaved draft data (e.g., job post draft) to sessionStorage/localStorage so user can resume editing after re-auth.

## Payment declined / card error [P1]
- **Where:** Subscription upgrade flow (80-plans → Stripe checkout)
- **Behavior:** Stripe shows the error inline in the hosted checkout page (e.g., 'Your card was declined'). If user returns to app after error, show a banner on 80-plans: 'Your upgrade didn't go through. Your payment method may have expired.' with a button 'Try again' that re-opens checkout. Allow retry up to 3 times before suggesting account support.

## Content moderation: post/listing flagged or blocked [P2]
- **Where:** Feed (60), marketplace (70-71), after user publishes
- **Behavior:** If content is auto-flagged or flagged by users: show a banner on the post card: 'This post is under review' (warning-tint background). If content is removed/blocked: show an empty-state card where the post was: 'This post was removed for violating community guidelines.' Link to 'Learn more' (help docs). Messages to poster: 'Your post was removed for X reason. Contact support for review.' Keep app accessible; do not hard-block the screen.

## No internet / connection lost [P1]
- **Where:** Any screen with data loading (feed, jobs list, messages, marketplace)
- **Behavior:** Show persistent dark banner at top: 'You're offline — showing cached data' (banner--offline). If user tries to perform an action that requires internet (apply, post, send message), disable the action button and show inline text: 'Internet required' or queue the action as described in offline model. See 92-offline-states for reference implementation.

## Slow network / timeout [P2]
- **Where:** Data-heavy screens (feed load, applicant list, message sync)
- **Behavior:** Show a spinner or skeleton loader while fetching. If fetch takes >5 sec, show an inline info banner: 'Still loading...' with a 'Retry' button. If timeout occurs (>15 sec), show an error state: 'Loading failed. Check your connection.' with 'Retry' button. Always provide a way out (back button, navigate away).

## Applicant/job listing deleted mid-conversation [P2]
- **Where:** User in 51-chat-thread tied to a deleted job or with a deleted applicant
- **Behavior:** Keep the thread open and readable. Show an info banner at top: 'This job is no longer active. You can still message.' or 'This candidate is no longer available.' Mark the context header (job card) as faded/muted. Messaging stays functional. Do not delete the thread.

## Applicant re-applies after rejection [P1]
- **Where:** Worker tries to apply to a job they were already rejected from (capability JOB-11)
- **Behavior:** Instead of creating a new application, open the existing thread: 'You already applied to this job on [date]. Re-open your conversation?' with a button 'View conversation'. Show a banner in thread: 'Your previous application was not selected. You can still reach out.' Do not allow duplicate applications.
