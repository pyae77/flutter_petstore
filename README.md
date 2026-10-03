# Pet Store App

A Flutter mobile app for a pet store experience with onboarding, login, registration, home screen, and admin features.

## Features

- Onboarding flow
- User login and registration
- Pet store home screen
- Order management
- Profile screen
- Admin management screen
- Dependency injection with GetIt
- Routing with GoRouter
- State management with Flutter BLoC

## Project Structure

- `lib/core` – app-wide config, routing, services, theme, utilities
- `lib/data` – data sources, models, repositories
- `lib/domain` – entities and use cases
- `lib/presentation` – screens, widgets, and BLoC logic

## Tech Stack

- Flutter
- Dart
- Flutter BLoC
- GoRouter
- GetIt
- Dio
- Hive
- Flutter Secure Storage

## Getting Started

1. Install Flutter SDK.
2. Clone the project.
3. Run:

```bash
flutter pub get
flutter run
```

## Notes

This project follows a layered architecture and is designed for clean separation of concerns between UI, business logic, and data access.
