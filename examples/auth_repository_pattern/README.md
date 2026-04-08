# Authentication Repository Pattern

## Goal

Show a clean separation between:

- UI
- auth state
- repository logic
- token persistence

## Why this matters

Authentication is usually one of the first places Flutter apps become tightly coupled. This pattern keeps widgets thin and auth behavior reusable.

## Planned focus

- sign in state flow
- repository abstraction
- loading and error states
- token storage boundary

## Starter files

- `lib/domain/auth_session.dart`
- `lib/application/auth_controller.dart`
