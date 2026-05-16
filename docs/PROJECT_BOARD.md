# Project Board

Use a single GitHub project board for the portfolio roadmap.

## Columns
- Backlog
- Ready
- In Progress
- Review
- Done

## Milestones
- M0 Foundation
- M1 Auth + Profile
- M2 Core Messaging
- M3 Groups + Media
- M4 Notifications + Polish
- M5 Portfolio Release

## Labels
- story
- feature
- bug
- docs
- ci
- architecture
- test
- firebase
- swiftdata
- ui

## Solo Contributor Flow
1. Convert the next roadmap item into a story issue.
2. Split the story into feature tickets that fit in one or two focused sessions.
3. Create a branch from `main` using `feature/<ticket-short-name>`.
4. Open a PR early, keep it small, and wait for CI before merge.
5. Move the ticket to Done only after implementation, tests, and docs are complete.
