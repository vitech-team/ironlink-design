# IronLink — Dialogs & Action Sheets

## Confirm apply to job [P1] (confirm)
- **Trigger:** User taps 'Send application' button on 42-apply-ai-draft
- **Content:** Title: Send your application?
Body: Your profile and cover message will be sent to Capitol Mechanical.
Buttons: Cancel · Send

## Confirm withdraw application [P1] (destructive)
- **Trigger:** User taps more menu on application in 43-my-applications (Interviewing/Applied state)
- **Content:** Title: Withdraw application?
Body: You won't be able to re-apply to this job. Conversation thread will remain visible.
Buttons: Keep application · Withdraw

## Confirm hire applicant [P1] (confirm)
- **Trigger:** Employer selects 'Hire' action on applicant in 45-applicants
- **Content:** Title: Hire Marcus Reed?
Body: This changes the application status to Hired and notifies the worker. The messaging thread stays open.
Buttons: Cancel · Hire

## Confirm reject applicant [P1] (destructive)
- **Trigger:** Employer selects 'Reject' action on applicant in 45-applicants
- **Content:** Title: Not interested in Marcus Reed?
Body: They'll be notified their application was not selected. You can still message them.
Buttons: Cancel · Not interested

## Confirm pause job listing [P1] (confirm)
- **Trigger:** Employer taps pause action on an active job
- **Content:** Title: Pause 'HVAC Service Tech'?
Body: New applications will stop, but you can accept pending offers. You can reopen anytime.
Buttons: Cancel · Pause

## Confirm close/fill job listing [P1] (confirm)
- **Trigger:** Employer taps close action on active job
- **Content:** Title: Mark 'HVAC Service Tech' as filled?
Body: The job will no longer appear in feeds or searches. You can still message applicants.
Buttons: Cancel · Mark filled

## Confirm delete job listing [P1] (destructive)
- **Trigger:** Employer taps delete on draft or active job
- **Content:** Title: Delete 'HVAC Service Tech'?
Body: This cannot be undone. All applicants will be notified the job is closed.
Buttons: Cancel · Delete

## Confirm publish job listing [P1] (confirm)
- **Trigger:** Employer taps 'Publish' on 44-post-job with wage range filled
- **Content:** Title: Publish 'HVAC Service Tech' to feed?
Body: Saves the job and shares it with 340 followers for 48 hours visibility.
Buttons: Publish quietly · Publish to feed

## Confirm mark equipment listing as sold [P1] (confirm)
- **Trigger:** Seller taps 'Mark sold' action on marketplace listing
- **Content:** Title: Mark '2018 Bobcat S650' as sold?
Body: The listing will be removed from search, but the message thread stays open for follow-up.
Buttons: Cancel · Mark sold

## Confirm delete equipment listing [P1] (destructive)
- **Trigger:** Seller taps delete on own marketplace listing
- **Content:** Title: Delete '2018 Bobcat S650'?
Body: This cannot be undone. Any open inquiries will be notified.
Buttons: Cancel · Delete

## Confirm mode switch [P1] (confirm)
- **Trigger:** User taps 'Switch to Employer' on 91-settings or equivalent
- **Content:** Title: Switch to Employer mode?
Body: Your profile, messages, and saved jobs stay in Worker mode. You'll see employer jobs, teams, and billing.
Buttons: Cancel · Switch

## Confirm logout [P1] (confirm)
- **Trigger:** User initiates logout from settings
- **Content:** Title: Sign out?
Body: You'll be logged out on this device. You can sign back in anytime.
Buttons: Cancel · Sign out

## Confirm delete account [P0] (destructive)
- **Trigger:** User taps 'Delete account' row in 91-settings
- **Content:** Title: Delete your account?
Body: This cannot be undone. All your data, messages, and listings will be permanently deleted.
Buttons: Cancel · Delete account

## Confirm cancel subscription [P1] (destructive)
- **Trigger:** User initiates cancel subscription from billing
- **Content:** Title: Cancel subscription?
Body: Your plan will end at the next billing date. You can reactivate anytime.
Buttons: Cancel · Stop subscription

## Confirm discard draft job [P1] (destructive)
- **Trigger:** User navigates away from 44-post-job with unsaved changes
- **Content:** Title: Discard changes?
Body: Your job draft will be lost.
Buttons: Keep editing · Discard

## Report post/comment/listing [P1] (action-sheet)
- **Trigger:** User taps report action on feed post or marketplace listing
- **Content:** Title: Report this post
Body: Help us keep IronLink safe. Select reason:
Buttons: Spam · Harassment · Inappropriate · Scam · Other

## Block user [P2] (action-sheet)
- **Trigger:** User taps more menu on conversation or profile
- **Content:** Title: Block this user?
Body: You won't see their posts, messages, or job listings. They won't know they're blocked.
Buttons: Cancel · Block

## Remove team member (admin only) [P1] (destructive)
- **Trigger:** Org admin taps remove on team member list
- **Content:** Title: Remove Stephanie Pruitt from Capitol Mechanical?
Body: They'll lose access to shared jobs and team messaging. Cannot be undone.
Buttons: Cancel · Remove

## OTP expired/resend [P1] (info)
- **Trigger:** User on 13-otp-verify, code expires or user requests resend
- **Content:** Title: Code expired
Body: We sent a new 6-digit code to +1 (334) 555-1234. Check your text messages.
Buttons: Got it · Resend via email

## Payment failed [P1] (info)
- **Trigger:** Subscription charge fails during renewal
- **Content:** Title: Payment failed
Body: We couldn't charge your card ending in 4242. Update your payment method to keep your plan active.
Buttons: Update payment · Try again
