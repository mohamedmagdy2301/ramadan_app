# Flutter Project Upgrade Plan

## Upgrade Completed: 2025-12-22

### Summary
Successfully upgraded the project from Flutter 3.7 to Flutter 3.38.4 (stable).

## Changes Made

### 1. pubspec.yaml
- Dart SDK: `^3.7.0` → `^3.10.0`
- home_widget: `^0.7.0+1` → `^0.8.1`
- flutter_lints: `^5.0.0` → `^6.0.0`
- Multiple dependencies auto-upgraded via `flutter pub upgrade --major-versions`

### 2. Android Configuration

**android/settings.gradle.kts:**
- Android Gradle Plugin: `8.7.0` → `8.9.1`
- Kotlin: `1.8.22` → `2.1.0`

**android/app/build.gradle.kts:**
- compileSdk: `flutter.compileSdkVersion` → `36`
- minSdk: `23` → `24`
- targetSdk: `flutter.targetSdkVersion` → `35`
- desugar_jdk_libs: `2.0.3` → `2.1.4`
- androidx.window: `1.0.0` → `1.3.0`
- Removed kotlin-stdlib-jdk8 (bundled with Kotlin 2.x)

**android/gradle/wrapper/gradle-wrapper.properties:**
- Gradle: `8.10.2` → `8.12`

**android/gradle.properties:**
- Removed deprecated `android.enableJetifier=true`
- Added `android.nonTransitiveRClass=true`
- Added `android.nonFinalResIds=true`

### 3. iOS Configuration

**ios/Podfile:**
- iOS deployment target: `12.0` → `13.0`

### 4. Breaking Changes Fixed

**flutter_local_notifications (v18 → v19):**
- `FlutterTimezone.getLocalTimezone()` now returns `TimezoneInfo` - access `.identifier`
- Removed `uiLocalNotificationDateInterpretation` parameter

**quran_library (v0.1.3 → v2.3.1):**
- `QuranLibrary().init()` → `QuranLibrary.init()` (static)
- `QuranLibrary().allJoz` → `QuranLibrary.allJoz` (static getter)
- `QuranLibrary().allHizb` → `QuranLibrary.allHizb` (static getter)
- `QuranLibrary().getAllSurahs()` → `QuranLibrary.getAllSurahs()` (static)
- `jumpToAyah(ayahModel)` → `jumpToAyah(surahNumber, ayahNumber)`
- `QuranLibraryScreen` requires `parentContext` parameter
- Removed `languageCode` and `onDefaultAyahLongPress` parameters
- Some properties like `surahNumber`, `arabicName` are now nullable

**Other deprecations fixed:**
- `activeColor` → `activeThumbColor` (Switch widget)
- `withOpacity()` → `withAlpha()` (Color)
- `@required` → `required` (Dart 2.12+)

## Post-Upgrade Verification
- ✅ flutter analyze: 36 info-level issues (lint suggestions only)
- ✅ flutter build apk --debug: Build successful
- ✅ flutter test: All tests passed
