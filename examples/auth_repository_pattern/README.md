# Authentication Repository Pattern

## Goal

Show a clean separation between:

- UI
- auth state
- repository logic
- token persistence

## Why this matters

Authentication is usually one of the first places Flutter apps become tightly coupled. This pattern keeps widgets thin and auth behavior reusable.

## Included in this example

- sign in state flow
- repository abstraction
- loading and error states
- token storage boundary

## Key files

- `lib/main.dart`
- `lib/application/auth_controller.dart`
- `lib/data/auth_repository.dart`
- `lib/data/token_store.dart`
