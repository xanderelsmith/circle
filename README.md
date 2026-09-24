# circle


Based on the concept, Circle would likely need these screens. I’d structure them around the core loop: create/join a Circle → set a habit → get reminded → submit proof → friends react → leaderboard/streak → escalation if you miss it.

1. Onboarding & Account
Splash Screen
Circle logo
Tagline: “The social accountability partner that refuses to let you fail.”
Welcome / Onboarding
How Circle works
“Prove it”
“Compete”
“Stay accountable”
Sign Up
Email/phone
Google/Apple sign-in
Login
Profile Setup
Name
Profile photo
Username
Notification & Call Permission
Push notifications
Phone-call accountability permission
Explanation of why Circle needs them
2. Home / Main App

Home Dashboard

Probably the most important screen.

Could show:

Today's habits
Progress: 3/5 completed
Current streak
Upcoming deadlines
Friends' recent activity
“Submit Proof” CTA
Warning when you're falling behind

Example:

🔥 12 Day Streak
2 habits left today

🏃 Run — 6:00 PM
📚 Read 20 pages — 9:00 PM

[Submit Proof]

Activity / Feed
Friends' proof posts
Photos
Habit completed
Streak achieved
Reactions/comments
“🔥 Emmanuel completed his run”
3. Circle Screens
My Circles
List of groups
Circle name
Members
Active challenges
Your position
Create a Circle
Circle name
Description
Icon
Privacy
Invite friends
Join Circle
Invite code/link
Search/invite friends
Circle Overview

This could be the main social screen:

Circle name
Members
Current challenge
Leaderboard preview
Recent activity
Chat preview
Circle Members
Profiles
Current streaks
Consistency
Rank
Circle Settings
Rename
Members
Rules
Notification settings
Accountability settings
Leave Circle
4. Habit / Goal Screens
My Habits
Create Habit
Habit name
Description
Frequency
Days
Deadline
Proof requirement
Reminder time

Example:

Run 5km

Every Monday, Wednesday & Friday
Deadline: 7:00 PM
Proof: 📸 Required

Habit Details
Current streak
Completion history
Calendar
Success rate
Proof history
Deadline
Edit Habit
Daily Habit Check-In
Habit you're supposed to complete
Countdown
“I'm doing it” state
Submit proof
5. Proof System

This is one of Circle's biggest differentiators.

Submit Proof

Camera interface:

📸 Prove you did it

[ Camera ]

Take Photo

Proof Preview
Captured image
Caption
Habit being verified
Post to Circle
Proof Post
Photo
Habit
Timestamp
Streak
Reactions
Comments
Proof History
Previous submissions
Calendar
Photos
Proof Verification

Potentially:

Community verification
AI-assisted verification
“Looks valid”
Flag proof
6. Leaderboard / Gamification
Leaderboard

Probably another major screen.

🏆 CIRCLE LEADERBOARD

🥇 Sarah — 24 days
🥈 David — 21 days
🥉 Emmanuel — 18 days
4. John — 12 days

Could have:

Current streak
Weekly consistency
Monthly consistency
XP/points
Rank changes
My Ranking
Current position
Progress toward next rank
Streak
Points earned/lost
Achievements
7-day streak
30-day streak
First proof
Perfect week
Comeback
Top 3
7. Chat
Circle Chat
Messages
Photos
Reactions
Mentions
Reply
Chat Media
Shared photos/videos
Proof posts
Member Profile
Profile photo
Bio
Habits
Streak
Achievements
Recent proof
8. Accountability / Escalation

This is where Circle becomes different from a normal habit tracker.

Accountability Settings

User could choose:

How hard should Circle push you?

🟢 Gentle
🟡 Persistent
🔴 Relentless

Then configure:

Reminder notification
Warning
Final reminder
Phone call
Friend notification
Reminder Screen

⚠️ You're running out of time

You haven't submitted proof for
Today's 5km Run

43 minutes remaining

[Submit Proof]

Escalation / Missed Habit

🚨 You missed your deadline

Your Circle knows.

🔥 14 day streak → BROKEN

[Get Back on Track]

Accountability Call Screen

If Circle literally calls:

📞 Circle Accountability

“You said you were going to run today.”

[I'm doing it]

[I need to skip today]

Missed Habit / Recovery
What happened?
Skip legitimately
Resume streak
Make-up challenge
Notify Circle
9. Notifications
Notifications Center

Examples:

🔥 David beat your streak
📸 Sarah submitted proof
💬 John mentioned you
⚠️ Your habit is due in 30 minutes
🏆 You moved to #2
Notification Preferences
10. Search & Social
Search
Friends
Circles
Usernames
Friend Requests / Invites
Invite Friends
Share link
WhatsApp
Contacts
11. Profile
My Profile

Emmanuel
🔥 18 day streak

Consistency: 87%

🏆 4 achievements

Circles:

Flutter Builders
Fitness Bros
Edit Profile
Statistics
Total habits completed
Longest streak
Completion rate
Proof submitted
Missed habits
12. Settings
Settings
Account & Security
Privacy
Notification Settings
Call/Accountability Settings
Blocked Users
Help & Support
About Circle
Delete Account
If you're building the MVP

You don't need all 52 screens initially.

I'd reduce Circle to around 15 core screens:

SPLASH
  ↓
ONBOARDING
  ↓
AUTH
  ↓
HOME
 ├── My Habits
 │    ├── Create Habit
 │    ├── Habit Details
 │    └── Submit Proof
 │
 ├── CIRCLE
 │    ├── Circle Feed
 │    ├── Leaderboard
 │    └── Circle Chat
 │
 ├── NOTIFICATIONS
 │
 └── PROFILE
      └── Settings

And the core user journey becomes:

Create/Join Circle
       ↓
Create Habit
       ↓
Set Deadline
       ↓
Reminder
       ↓
"PROVE IT"
       ↓
Take Photo
       ↓
Post Proof
       ↓
Friends React
       ↓
Streak Updated
       ↓
Leaderboard Updated
       ↓
      🔥

The killer UX moment is probably not the leaderboard itself. It's the transition from:

“You haven't done it yet.”

→ “30 minutes left.”

→ “Circle is calling you.”

→ “PROVE IT.”

That gives the app a much stronger identity than simply being another habit tracker.

For your Flutter/Rive style, I’d also consider making streaks, rank movement, missed-habit warnings, and the accountability call highly animated rather than making every screen visually complex.

Which direction should I map next: MVP 15 screens, full UI/UX flow, or Flutter screen architecture?

create the social screen , minimalistic as well as beautiful
Edit
Today 5:57 PM
create the screen thta has heatmaps, make it gamified ui
Edit
now create another notable screen in the app
Edit
what about the sceeen that shows the circle you have joied
Edit
You’re out of image creations for now. Start a free Plus trial to continue, or wait for more tomorrow at 5:57 PM.
Try Plus free