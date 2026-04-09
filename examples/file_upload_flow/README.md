# File Upload Flow

## Goal

Show how to structure file uploads with:

- progress updates
- loading state
- retry handling
- user-friendly failure states

## Why this matters

Uploads are common in real apps, but many examples skip progress, retry, and clear feedback.

## Included in this example

- upload progress state
- success and failure states
- retry action
- upload history

## Key files

- `lib/main.dart`
- `lib/application/upload_controller.dart`
- `lib/data/fake_upload_service.dart`
