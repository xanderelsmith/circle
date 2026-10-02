# Circle: Feature-First Clean Architecture Guide

This project follows a **Feature-First** structure combined with **Clean Architecture** principles, powered by **Riverpod** for state management and **Serverpod** for the backend.

Instead of grouping files by type (e.g., all models together, all screens together), we group files by **feature**. This makes the codebase scalable, easier to navigate, and prevents massive monolithic folders.

---

## 📂 Folder Structure

All Flutter code lives in `circle_flutter/lib/`. 

```text
lib/
 ├── core/                     # Shared app-wide code
 │    ├── theme/               # Colors, typography, gradients
 │    ├── constants/           # Hardcoded strings, API keys
 │    ├── widgets/             # Reusable global widgets (e.g., PrimaryButton)
 │    └── utils/               # Helper functions, formatters
 │
 ├── features/                 # The core of the app, separated by domain
 │    ├── home/                # Feature: The Masonry Feed
 │    ├── circles/             # Feature: My Circles & Invites
 │    ├── leaderboard/         # Feature: The global/circle rankings
 │    ├── profile/             # Feature: User dashboard & heatmaps
 │    └── chat/                # Feature: Circle group chat
 │
 └── main.dart                 # App entry point (ProviderScope & Routing)
```

---

## 🏗 Inside a Feature Folder

Every feature folder (e.g., `features/home/`) is divided into three layers following Clean Architecture:

```text
home/
 ├── data/                     # 1. DATA LAYER (External)
 │    ├── repositories/        # Talks to Serverpod client to fetch data
 │    └── models/              # Local data transformations (if needed)
 │
 ├── domain/                   # 2. DOMAIN LAYER (Business Logic)
 │    ├── entities/            # Core business objects
 │    └── providers/           # Riverpod state providers (e.g., feedProvider)
 │
 └── presentation/             # 3. PRESENTATION LAYER (UI)
      ├── screens/             # The main UI pages (e.g., home_screen.dart)
      └── widgets/             # Feature-specific widgets (e.g., proof_card.dart)
```

---

## 🌊 Riverpod Guidelines

We use **Riverpod 2.0+** (`@riverpod` code generation or standard `Notifier` / `FutureProvider`).

1. **Never pass state through constructors**: If a deep widget needs data, it should read it directly from a Provider using `ConsumerWidget` and `WidgetRef ref`.
2. **Keep UI dumb**: The Presentation layer should only display data. All complex logic (sorting, filtering, submitting to Serverpod) belongs in the Domain layer (`Notifier` methods).

---

## 🚀 Serverpod Integration

The backend generated code lives inside `circle_client`.
- When building a new feature, you will inject the singleton `client` (from `lib/client.dart`) into your Repository classes in the Data layer.
- **Example Flow**:
  1. User pulls down to refresh the `HomeScreen` (Presentation).
  2. The screen calls `ref.read(feedProvider.notifier).refresh()` (Domain).
  3. The provider calls `postRepository.fetchPosts()` (Data).
  4. The repository calls `client.proofPost.getPosts()` (Serverpod).
