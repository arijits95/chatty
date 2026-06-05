# Chatty Roadmap

Chatty is a native SwiftUI portfolio chat app. The v1 release uses Firebase first while preserving a backend boundary that can later point to a custom service.

## M0 Foundation
- GitHub issue templates, PR checklist, labels, milestones, and project-board guidance.
- GitHub Actions CI for app build and unit tests.
- Development, demo, and production environment model.
- Dependency injection root with configurable backend implementations.
- Prototype cleanup for chat list ordering, dates, empty states, and starter-view noise.
- Baseline tests for domain and presentation behavior.

## M1 Auth + Profile
- Firebase SDK and app configuration.
- Phone OTP sign-in flow using Firebase test phone numbers, reCAPTCHA fallback, and demo auth for Firebase-free previews/screenshots.
- Session persistence and auth routing.
- Profile setup, avatar upload, remote profile storage, and local cache.

## M2 Core Messaging
- Repository-backed chat list with pagination, unread counts, search, and offline states.
- Direct chat detail screen with text messaging, optimistic send, real-time updates, read states, and retry.
- User search and deterministic direct-chat creation.

## M3 Groups + Media
- Group creation, membership management, group info, and leave flow.
- Image, video, and file messages with upload progress, previews, cache metadata, and share/open actions.

## M4 Notifications + Polish
- FCM registration, token storage, payload contract, message notification trigger, and deep linking where APNs credentials are available.
- Typing indicators, presence, pinned/muted/archived states, settings, dark mode, accessibility, launch screen, and app icon.
- CI hardening with stable destinations and optional UI smoke tests.

## M5 Portfolio Release
- Architecture and data-flow diagrams.
- Screenshots/GIFs for key flows.
- Firebase setup guide with safe config handling.
- Test plan, limitations, future roadmap, and `v1.0-portfolio` release tag.

## Post-v1
- Status/stories.
- Audio/video calls.
- Production APNs setup for Firebase phone auth silent verification and message push notifications.
- True end-to-end encryption.
- Communities/channels.
- Multi-device sync.
- Custom backend adapter.
