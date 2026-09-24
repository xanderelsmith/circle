# ⭕ Circle

**"The social accountability partner that refuses to let you fail."**

Built for the **Build Something Real: The Serverpod Hackathon**.

---

## 🚀 The Vision
Standard habit trackers are too easy to ignore. WhatsApp groups meant for accountability get messy, and there’s no real penalty for slacking off. 

**Circle** is a dedicated productivity app built around strict social accountability. You don't just check a box; you prove it to your friends, climb the ranks, and if you miss your deadline, the app actively fights to keep you on track.

### 🌟 The Killer Feature: Escalation
Circle doesn't just send you a passive push notification. If your deadline is approaching, Circle escalates:
1. **Gentle:** Push notification ("30 minutes left").
2. **Persistent:** Automated system message sent to your Circle group chat ("Xander is running out of time!").
3. **Relentless:** The backend literally initiates a **phone call** to wake you up or force you to do your task.

---

## 🛠 Tech Stack
* **Backend:** Serverpod 4 (Dart)
* **Frontend:** Flutter
* **Database:** PostgreSQL (managed natively via Serverpod)
* **Animations:** Rive (Dynamic Mascot that changes color based on leaderboard rank)
* **Integrations:** Twilio (for Relentless Escalation Calls)

---

## 🏆 Why Serverpod? (Hackathon Alignment)
This app is designed to push the limits of Serverpod's real-time and background execution capabilities:
* **WebSockets / Real-Time:** The `Circle Chat` and `Reaction Verification` rely on Serverpod's seamless real-time data streaming to update the feed and leaderboards instantly without pull-to-refresh.
* **FutureCalls (Scheduled Tasks):** The core escalation mechanic uses Serverpod's `FutureCalls`. When a user sets a habit deadline, a FutureCall is scheduled on the server. If the user hasn't posted proof by the time the FutureCall executes, it triggers the phone call logic.

---

## 🏗 Core Database Schema (Serverpod)
The app is built on 5 core `.spy.yaml` schemas:
1. `User`: Tracks `streakCount`, `rankColor`, and `phoneNumber`.
2. `CircleGroup`: Tracks the group `dailyDeadline`.
3. `ProofPost`: Contains the `imageUrl` and `isVerified` status.
4. `Reaction`: Connects a `User` to a `ProofPost` for community verification.
5. `ChatMessage`: Powers the real-time chat, including `isBotMessage` for automated alerts.

---

## 📱 The MVP Flow (15 Screens)
To keep the scope realistic for the MVP, the app is stripped down to the most critical, high-impact screens:

1. **Onboarding & Auth:** Simple phone/email login.
2. **Home Dashboard:** The feed of friends posting their proofs with a big "✅ Verify" reaction button.
3. **Camera / Upload:** A frictionless, 1-tap camera view to snap proof and upload.
4. **Leaderboard & Stats:** A podium showing who is #1 in the Circle, plus a personal calendar heatmap.
5. **Circle Chat:** Group messaging infused with bot alerts.
6. **Habit Setup:** Set your deadline and choose your escalation level (Gentle, Persistent, Relentless).

---

## 💡 The Core User Journey
1. **Join Circle** → 2. **Create Habit** → 3. **Set Deadline** → 4. **Receive Reminders** → 5. **Snap Photo Proof** → 6. **Friends Verify ✅** → 7. **Streak & Leaderboard Updated 🔥**

*If step 5 is missed, the escalation protocol takes over.*