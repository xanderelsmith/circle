# Circle Backend Documentation

This document serves as a guide for the frontend developers integrating the Serverpod backend into the Flutter app.

## 🚀 Setup & Running Locally

1. Ensure Docker Desktop is running (required for the PostgreSQL database).
2. Inside circle_server/, generate the client SDK:
   \\\ash
   serverpod generate
   \\\
3. Start the server and the database:
   \\\ash
   # From VS Code, you can run the "serverpod_start" task
   # Or via terminal:
   docker-compose up -d
   dart bin/main.dart --apply-migrations
   \\\

## 🔗 Endpoints

The endpoints are automatically generated in the circle_client package. You can access them in Flutter via the client singleton.

### 1. Circle Endpoint (\client.circle\)
* \getCircles()\: Fetches all circles.
* \createCircle(CircleGroup circle)\: Creates a new accountability circle.
* \createProofPost(ProofPost post)\: Uploads a proof post (habit completion).
* \getFeed(int circleId)\: Fetches the timeline/feed of proof posts for a specific circle.
* \erifyPost(int postId)\: Marks a friend's proof post as verified.

### 2. User Endpoint (\client.user\)
* \getOrCreateUser(String username, String phoneNumber)\: Syncs the user with our custom database table after they authenticate. Returns their rank and streak.
* \getLeaderboard()\: Fetches the top 50 users globally, sorted by streakCount in descending order.

### 3. Chat Endpoint (\client.chat\)
* \postMessage(ChatMessage message)\: Sends a message to a specific circle's chat room. Automatically broadcasts via WebSockets.
* \getMessages(int groupId)\: Fetches the message history for a circle.

## 🤖 Vapi & AGI Escalation

The defining feature of Circle is the AGI voice call escalation for missed habits.
* **Triggering a Call**: The backend contains a FutureCall named EscalationCall.
* **How it works**: When a user sets a habit deadline, schedule this FutureCall. If the user hasn't uploaded verified proof by the deadline, the EscalationCall fires, triggering a server-to-server POST request to Vapi's REST API.
* **The Call**: An AI Drill Sergeant (powered by GPT-4o-mini and ElevenLabs) will call the user's phone demanding accountability.
* *Note:* The Vapi private key in lib/src/future_calls/escalation_call.dart must be set before production.

## 🔒 Authentication
Authentication is handled via **Serverpod's official Auth module** (Email/Password & JWT). Use the serverpod_auth_idp_client package in Flutter to handle sign-ins. Once authenticated, pass the user's details to client.user.getOrCreateUser() to initialize their Circle profile, streak, and rank.
