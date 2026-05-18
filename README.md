# Chatty

Chatty is a native SwiftUI portfolio chat application. The project is intentionally built as a learning system: every feature should demonstrate clean architecture, testable boundaries, and a practical path from prototype to a real Firebase-backed product.

## Product Goal

The first portfolio release will deliver the core experience expected from a modern chat app:

- Phone OTP authentication and profile setup.
- Real-time one-to-one messaging.
- Group chats.
- Media and file attachments.
- Message delivery/read states.
- Offline local cache.
- Push notifications.
- Search, settings, and polished empty/loading/error states.

Calls, status/stories, true end-to-end encryption, communities, and multi-device sync are planned post-v1 features.

## Architecture

Chatty follows a Clean Architecture shape:

```text
SwiftUI Presentation
        |
Domain Use Cases
        |
Repository Protocols
        |
Local Data Sources + Remote Data Sources
```

The app now has an explicit dependency root in `AppDependencies`. Development and demo builds use a demo repository, while production is reserved for Firebase. Firebase-specific SDK types must stay inside Data/Infrastructure implementations and should not leak into Domain or Presentation.

## Environments

The app supports three environment names:

- `development`
- `demo`
- `production`

If no environment is provided, Chatty defaults to `demo`. The current M0 implementation maps `development` and `demo` to the demo backend and reserves `production` for the Firebase adapter.

## Continuous Integration

GitHub Actions runs the iOS CI workflow on pull requests and pushes to `main`.

Local equivalent:

```sh
SIMULATOR_NAME="$(xcrun simctl list devices available | sed -n 's/.*\(iPhone [^()]*\) (.*/\1/p' | head -n 1 | xargs)"
xcodebuild test \
  -project Chatty.xcodeproj \
  -scheme Chatty \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" \
  -skip-testing:ChattyUITests \
  CODE_SIGNING_ALLOWED=NO
```

UI tests are intentionally excluded from the first CI pass. They will be added after the M4 CI hardening ticket stabilizes simulator destinations and smoke flows.

## Development Workflow

- Use GitHub issues for stories and feature tickets.
- Keep feature branches short-lived and focused.
- Open a PR for every meaningful change.
- Merge only after the CI build/test check passes.
- Update docs when setup, behavior, or architecture changes.

See:

- [Roadmap](docs/ROADMAP.md)
- [Project Board](docs/PROJECT_BOARD.md)
- [Branch Protection](docs/BRANCH_PROTECTION.md)

## Firebase Setup

Chatty uses Firebase for production authentication and later real-time messaging/storage.

1. Create a Firebase project.
2. Add an iOS app using this bundle id: `com.epam.Chatty`.
3. Download `GoogleService-Info.plist`.
4. Place it at:

   `Chatty/GoogleService-Info.plist`

5. Do not commit this file. It is ignored by `.gitignore`.

## Current Status

M0 Foundation is in progress:

- CI workflow added.
- Issue and PR templates added.
- Roadmap and branch protection docs added.
- Demo backend boundary added.
- Chat list prototype moved toward production-ready loading, empty, and ordering behavior.
