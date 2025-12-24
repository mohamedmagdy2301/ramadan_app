# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ramadan App (Azkary) - A Flutter Islamic app providing Quran reading, prayer times, Azkar (daily supplications), Sabha (tasbeeh counter), Qibla compass, Hijri calendar, statistics tracking, and home screen widgets for prayer times.

**Package name:** `com.mohamedmagdy.azkar`

## Platform Configuration

| Platform | Version |
|----------|---------|
| Flutter | 3.38.x |
| Dart SDK | ^3.10.0 |
| Android compileSdk | 36 |
| Android minSdk | 24 |
| Android targetSdk | 35 |
| iOS deployment target | 13.0 |
| Kotlin | 2.1.0 |
| Android Gradle Plugin | 8.9.1 |
| Gradle | 8.12 |

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## Architecture

### State Management
- **flutter_bloc** (Cubit pattern) for state management
- Cubits located in `lib/features/*/presentation/view_model/`

### Dependency Injection
- **get_it** for service locator pattern
- Registration in `lib/core/di/injection_container.dart`
- Access via `sl<T>()` global instance

### Navigation
- **go_router** for declarative routing
- Routes defined in `lib/core/router/routes.dart`
- Router configuration in `lib/core/router/app_router.dart`
- Global navigator key: `AppRouter.navigatorKey`

### Core Structure
```
lib/
├── core/
│   ├── accessibility/      # Accessibility settings (font scaling)
│   ├── constants/          # Colors, images, strings, text styles
│   ├── di/                 # GetIt dependency injection setup
│   ├── extensions/         # Context, int, widget extensions
│   ├── local_storage/      # SharedPreferences wrapper
│   ├── network/            # API services (http/dio)
│   ├── notification_helper/# Local notifications (flutter_local_notifications)
│   ├── responsive/         # ResponsiveHelper for tablet/desktop support
│   ├── router/             # Go router setup
│   ├── theming/            # Light/dark theme configuration
│   └── utils/              # Helper functions and widgets
├── features/
│   ├── azkar/              # Daily supplications
│   ├── favorites/          # Favorite azkar management
│   ├── hijri_calendar/     # Islamic calendar
│   ├── home/               # Prayer times with location
│   ├── prayer_notifications/# Adhan notifications & settings
│   ├── qibla/              # Qibla compass direction
│   ├── quran/              # Quran reading (uses quran_library)
│   ├── sabha/              # Tasbeeh counter
│   ├── settings/           # App settings, theme picker
│   └── statistics/         # Usage statistics tracking
└── main.dart
```

### Key Dependencies
- **quran_library** - Quran reading functionality (initialized in main.dart)
- **adaptive_theme** - Light/dark theme switching with persistence
- **geolocator + geocoding** - Location for prayer times
- **flutter_local_notifications** - Scheduled azkar reminders
- **home_widget** - iOS/Android home screen widgets for prayer times
- **flutter_compass** - Qibla direction compass

### Prayer Times
- API: `https://api.aladhan.com/v1/timings/` (method=5, Egyptian General Authority of Survey)
- Location-based via Geolocator
- Auto-refreshes at midnight

### Localization
- Arabic only (ar_AE locale)
- Uses Cairo, Tajawal, Amiri, and Poppins fonts

### Home Widget
- Widget name: `TimePrayer`
- App Group ID: `group.timePrayer`
- Updates via `HomeWidgetHelper.updateNextPrayerWidget()`

### Responsive Design
- Breakpoints: mobile (<600), tablet (<900), desktop (>=900)
- Use `ResponsiveHelper` from `lib/core/responsive/responsive_helper.dart`
- Design size: 390x844 (iPhone 12 Pro)

### Context Extensions
Access theme colors via context extensions (`lib/core/extensions/context_extensions.dart`):
- `context.primaryColor` - Primary theme color
- `context.backgroundColor` - Scaffold background color
- `context.isDark` - Check if dark mode is active

## Testing Structure
Tests mirror the feature structure:
```
test/
├── core/           # Core utilities tests
├── features/       # Feature-specific tests
│   ├── azkar/
│   ├── favorites/
│   ├── hijri_calendar/
│   ├── home/
│   ├── prayer_notifications/
│   ├── qibla/
│   └── statistics/
└── widget_test.dart
```

## Feature Development Notes

When adding new features:
1. Write unit and integration tests before pushing
2. Update translation files if adding new strings
3. Follow existing Cubit pattern for state management
4. Use context extensions for theme colors (`context.primaryColor`, `context.backgroundColor`)
5. Register dependencies in `lib/core/di/injection_container.dart`
6. Add routes to `lib/core/router/routes.dart` and `lib/core/router/app_router.dart`
