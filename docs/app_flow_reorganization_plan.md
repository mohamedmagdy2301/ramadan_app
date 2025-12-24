# App Flow Reorganization & Smart Notification System Plan

## Overview

This plan outlines the reorganization of the Ramadan App (Azkary) to improve user experience and implement a smart notification system that automatically schedules prayer notifications and azkar reminders.

---

## Part 1: App Flow Reorganization

### Current State Issues

1. **Hidden Features**: Qibla compass, Statistics, Favorites are buried in Settings
2. **Manual Navigation**: Users must navigate through multiple screens to access common features
3. **No Quick Access**: No quick access widgets on the Home screen
4. **Hijri Calendar**: Not prominently displayed
5. **Prayer Notifications**: Require manual scheduling

### Proposed Changes

#### 1.1 Enhanced Home Screen

**Add Quick Access Section:**
- Hijri date display prominently at the top
- Quick access buttons/cards for:
  - Qibla Direction (compass icon)
  - Favorites (heart icon)
  - Statistics (chart icon)
  - Azkar Reminders (bell icon)

**Layout:**
```
┌─────────────────────────────────────┐
│  التاريخ الهجري: ٥ رجب ١٤٤٧          │
│  الخميس ٢٥ ديسمبر ٢٠٢٥              │
├─────────────────────────────────────┤
│        📍 Cairo, Egypt              │
│                                     │
│    ┌──────────────────────────┐     │
│    │     الصلاة القادمة      │     │
│    │        العشاء           │     │
│    │       18:25             │     │
│    └──────────────────────────┘     │
│                                     │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐│
│  │ قبلة │ │مفضلة │ │إحصاء │ │تذكير ││
│  └──────┘ └──────┘ └──────┘ └──────┘│
│                                     │
│        أوقات الصلاة اليوم           │
│    ┌─────────────────────────┐      │
│    │ الفجر    │    05:17     │      │
│    │ الشروق   │    06:50     │      │
│    │ الظهر    │    11:56     │      │
│    │ العصر    │    14:43     │      │
│    │ المغرب   │    17:02     │      │
│    │ العشاء   │    18:25     │      │
│    └─────────────────────────┘      │
└─────────────────────────────────────┘
```

#### 1.2 Improved Settings Screen

**Reorganize into Categories:**
1. **Appearance Section**
   - Theme Mode (Light/Dark)
   - Theme Color
   - Font Size

2. **Notifications Section**
   - Prayer Notifications (with toggle + settings)
   - Azkar Reminders (with toggle + settings)

3. **Data Section**
   - Favorites
   - Statistics
   - Clear Data

4. **About Section**
   - App Info
   - Rate App
   - Share App

#### 1.3 Bottom Navigation Optimization

Keep current 5 tabs but ensure all main features are accessible:
- Azkar (with category filters)
- Home (with quick access widgets)
- Quran
- Sabha
- Settings (reorganized)

---

## Part 2: Smart Notification System

### Current State Issues

1. Prayer notifications require manual scheduling via Settings
2. Notifications don't auto-update when prayer times change
3. No azkar reminder feature
4. Location changes don't trigger notification updates

### Proposed Smart Notification System

#### 2.1 Auto-Schedule Prayer Notifications

**Implementation Flow:**

```
User enables prayer notification
    ↓
System fetches current prayer times (from PrayerTimesCubit)
    ↓
Automatically schedules notifications for each enabled prayer
    ↓
Stores notification settings in SharedPreferences
    ↓
Listen for prayer time changes (location/date change)
    ↓
Auto-update notifications when times change
```

**Key Components:**

1. **PrayerNotificationService** (New)
   - `scheduleAllPrayerNotifications(PrayerTimesModel times)`
   - `updatePrayerNotifications(PrayerTimesModel newTimes)`
   - `cancelPrayerNotification(String prayer)`
   - `togglePrayerNotification(String prayer, bool enabled)`
   - `setPreAlertTime(int minutes)`
   - `getScheduledNotifications()`

2. **Integration with PrayerTimesCubit**
   - Listen to state changes
   - When new times are fetched, auto-update notifications
   - Handle midnight refresh

3. **Persistence**
   - Save enabled/disabled state per prayer
   - Save pre-alert time preference
   - Save sound preferences

#### 2.2 Azkar Reminder System (New Feature)

**Features:**
1. Morning Azkar reminder (custom time, default: after Fajr)
2. Evening Azkar reminder (custom time, default: after Asr)
3. Custom interval reminders (every X hours)
4. Prayer-linked reminders (after each prayer)

**Implementation:**

```dart
class AzkarReminderSettings {
  bool morningReminderEnabled;
  TimeOfDay morningReminderTime;
  bool eveningReminderEnabled;
  TimeOfDay eveningReminderTime;
  bool afterPrayerReminderEnabled;
  int customIntervalHours; // 0 = disabled
}
```

**Reminder Types:**
1. **أذكار الصباح** (Morning Azkar) - Scheduled after Fajr
2. **أذكار المساء** (Evening Azkar) - Scheduled after Asr
3. **تذكير بالاستغفار** (Istighfar Reminder) - Every few hours
4. **تذكير بعد الصلاة** (Post-Prayer Reminder) - After each prayer

#### 2.3 Notification Manager Enhancement

**File: `lib/core/notification_helper/smart_notification_manager.dart`**

```dart
class SmartNotificationManager {
  // Prayer Notifications
  Future<void> schedulePrayerNotifications(PrayerTimesModel times);
  Future<void> updatePrayerNotifications(PrayerTimesModel times);
  Future<void> cancelPrayerNotification(PrayerType type);

  // Azkar Reminders
  Future<void> scheduleAzkarReminder(AzkarReminderType type, TimeOfDay time);
  Future<void> cancelAzkarReminder(AzkarReminderType type);

  // Utility
  Future<List<PendingNotification>> getScheduledNotifications();
  Future<void> cancelAllNotifications();

  // Auto-scheduling
  void listenToPrayerTimeChanges(PrayerTimesCubit cubit);
}
```

---

## Part 3: Implementation Steps

### Phase 1: Notification System Enhancement

1. **Create SmartNotificationManager**
   - Wrapper around LocalNotificationService
   - Handles prayer and azkar notifications
   - Auto-scheduling logic

2. **Enhance PrayerNotificationCubit**
   - Add auto-scheduling on enable
   - Listen to prayer time changes
   - Handle notification updates

3. **Create AzkarReminderCubit**
   - Manage azkar reminder settings
   - Schedule/cancel reminders
   - Persist settings

4. **Integration**
   - Connect SmartNotificationManager to PrayerTimesCubit
   - Add listener in main.dart for automatic updates
   - Handle app lifecycle (resume, background)

### Phase 2: Home Screen Enhancement

1. **Add Hijri Date Widget**
   - Use HijriDateConverter
   - Display prominently at top

2. **Add Quick Access Buttons**
   - 4 circular buttons below prayer info
   - Qibla, Favorites, Statistics, Reminders

3. **Prayer Time Cards Enhancement**
   - Add notification toggle per prayer
   - Show notification status icon

### Phase 3: Settings Reorganization

1. **Create SettingsCategory Widget**
   - Reusable section widget
   - Icon, title, child items

2. **Reorganize Settings**
   - Group related items
   - Add azkar reminder settings section
   - Add prayer notification quick toggle

---

## Part 4: Technical Details

### 4.1 New Files to Create

```
lib/
├── core/
│   └── notification_helper/
│       ├── smart_notification_manager.dart      # New
│       ├── prayer_notification_service.dart     # New
│       └── azkar_reminder_service.dart          # New
│
└── features/
    ├── azkar_reminders/                         # New Feature
    │   ├── data/
    │   │   └── models/azkar_reminder_model.dart
    │   └── presentation/
    │       ├── cubit/azkar_reminder_cubit.dart
    │       └── screens/azkar_reminder_settings_screen.dart
    │
    └── home/
        └── presentation/
            └── view/
                └── widgets/
                    ├── hijri_date_widget.dart   # New
                    └── quick_access_buttons.dart # New
```

### 4.2 Files to Modify

```
lib/
├── main.dart                                    # Add notification listener
├── features/
│   ├── home/
│   │   └── presentation/
│   │       ├── view/screens/home_screen.dart    # Add widgets
│   │       └── view_model/prayer_times_cubit.dart # Add notification integration
│   │
│   ├── settings/
│   │   └── presentation/
│   │       └── view/screens/settings_screen.dart # Reorganize
│   │
│   └── prayer_notifications/
│       └── presentation/
│           └── cubit/prayer_notification_cubit.dart # Auto-scheduling
```

### 4.3 Notification IDs Scheme

```dart
// Prayer Notifications: 1000-1099
const int FAJR_NOTIFICATION_ID = 1000;
const int SUNRISE_NOTIFICATION_ID = 1001;
const int DHUHR_NOTIFICATION_ID = 1002;
const int ASR_NOTIFICATION_ID = 1003;
const int MAGHRIB_NOTIFICATION_ID = 1004;
const int ISHA_NOTIFICATION_ID = 1005;

// Azkar Reminders: 2000-2099
const int MORNING_AZKAR_ID = 2000;
const int EVENING_AZKAR_ID = 2001;
const int ISTIGHFAR_REMINDER_ID = 2002;
const int POST_PRAYER_REMINDER_BASE = 2010; // +0-4 for each prayer

// Custom User Azkar: 3000+
const int CUSTOM_AZKAR_BASE = 3000;
```

### 4.4 Smart Scheduling Logic

```dart
void onPrayerTimesUpdated(PrayerTimesModel newTimes) async {
  final settings = await getNotificationSettings();

  for (final prayer in PrayerType.values) {
    if (settings.isEnabled(prayer)) {
      final prayerTime = newTimes.getTime(prayer);
      final notificationTime = prayerTime.subtract(
        Duration(minutes: settings.preAlertMinutes),
      );

      if (notificationTime.isAfter(DateTime.now())) {
        await scheduleNotification(
          id: prayer.notificationId,
          title: 'حان وقت ${prayer.arabicName}',
          body: 'صلى على الوقت - ${_formatTime(prayerTime)}',
          scheduledTime: notificationTime,
          sound: settings.sound,
        );
      }
    }
  }
}
```

---

## Part 5: User Experience Flow

### 5.1 First-Time User

1. App opens to Home screen (Prayer Times)
2. User sees Hijri date and prayer times
3. Quick access buttons visible
4. Tapping bell icon → Notification settings
5. User enables prayer notifications → Auto-scheduled immediately
6. User can enable azkar reminders from same screen

### 5.2 Returning User

1. App resumes, checks for prayer time updates
2. If location changed → Fetch new times → Update notifications
3. If date changed (midnight) → Fetch new times → Update notifications
4. User continues using app normally

### 5.3 Notification Tap Actions

| Notification Type | Action |
|-------------------|--------|
| Prayer Time | Open Home screen, highlight current prayer |
| Morning Azkar | Open Azkar screen, filter morning |
| Evening Azkar | Open Azkar screen, filter evening |
| Custom Azkar | Open specific Azkar details |

---

## Part 6: Testing Plan

### 6.1 Unit Tests

1. SmartNotificationManager
   - scheduleNotification
   - cancelNotification
   - getScheduledNotifications

2. PrayerNotificationService
   - Auto-schedule logic
   - Time calculation
   - Settings persistence

3. AzkarReminderService
   - Reminder scheduling
   - Settings persistence

### 6.2 Integration Tests

1. Notification scheduling on enable
2. Notification update on time change
3. Notification cancellation
4. Settings persistence

### 6.3 Widget Tests

1. Quick access buttons
2. Hijri date widget
3. Settings organization

---

## Implementation Order

1. **Phase 1**: Smart Notification System (Priority: High)
   - SmartNotificationManager
   - Auto-scheduling in PrayerNotificationCubit
   - Integration with PrayerTimesCubit

2. **Phase 2**: Home Screen Enhancement (Priority: Medium)
   - Hijri date widget
   - Quick access buttons
   - Prayer card notification toggles

3. **Phase 3**: Azkar Reminders (Priority: Medium)
   - AzkarReminderCubit
   - Reminder settings screen
   - Integration with notification system

4. **Phase 4**: Settings Reorganization (Priority: Low)
   - Category grouping
   - Visual improvements

---

## Notes

- All notifications use Arabic text
- Sound options for Adhan and general reminders
- Respect system notification settings
- Handle timezone changes gracefully
- Battery optimization considerations
