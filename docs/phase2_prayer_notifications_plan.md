# خطة المرحلة 2: إشعارات الصلاة

## تاريخ الإنشاء: 2025-12-22

---

## نظرة عامة

هذه الخطة تغطي تنفيذ نظام إشعارات الصلاة الكامل، والذي يتضمن:
- خدمة إشعارات الصلاة
- شاشة إعدادات الإشعارات
- دعم صوت الأذان

---

## البنية الحالية المتاحة

### ما هو موجود:
1. **LocalNotificationService** - خدمة الإشعارات الأساسية
   - `lib/core/notification_helper/local_notification_manager.dart`
   - دعم Android و iOS
   - جدولة الإشعارات بالتوقيت المحلي

2. **AzkarNotificationCubit** - نمط موجود للإشعارات
   - `lib/features/azkar/presentation/view_model/notification_manager/`
   - يمكن استخدامه كمرجع

3. **Prayer Times Data** - بيانات مواقيت الصلاة
   - `PrayerTimesEntity` مع Fajr, Dhuhr, Asr, Maghrib, Isha
   - `PrayerTimesCubit` لجلب المواقيت من API

---

## المرحلة 2.1: بنية إشعارات الصلاة

### الملفات المطلوب إنشاؤها:

```
lib/features/prayer_notifications/
├── data/
│   ├── models/
│   │   └── prayer_notification_settings_model.dart
│   └── datasources/
│       └── prayer_notification_local_datasource.dart
├── domain/
│   └── entities/
│       └── prayer_notification_settings.dart
├── presentation/
│   └── cubit/
│       ├── prayer_notification_cubit.dart
│       └── prayer_notification_state.dart
└── prayer_notification_service.dart
```

### 1. Prayer Notification Settings Entity

```dart
class PrayerNotificationSettings {
  final bool fajrEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;
  final int preAlertMinutes; // 0, 5, 10, 15
  final bool soundEnabled;
  final String? selectedAdhan; // null = default sound
}
```

### 2. Prayer Notification Service

```dart
class PrayerNotificationService {
  // جدولة إشعار لصلاة معينة
  Future<void> schedulePrayerNotification({
    required String prayerName,
    required DateTime prayerTime,
    required int notificationId,
    bool withPreAlert = false,
    int preAlertMinutes = 0,
  });

  // جدولة جميع إشعارات اليوم
  Future<void> scheduleAllPrayerNotifications(PrayerTimesEntity prayerTimes);

  // إلغاء إشعار صلاة معينة
  Future<void> cancelPrayerNotification(String prayerName);

  // إلغاء جميع إشعارات الصلاة
  Future<void> cancelAllPrayerNotifications();
}
```

### 3. Prayer Notification Cubit

```dart
// States
abstract class PrayerNotificationState {}
class PrayerNotificationInitial extends PrayerNotificationState {}
class PrayerNotificationLoading extends PrayerNotificationState {}
class PrayerNotificationLoaded extends PrayerNotificationState {
  final PrayerNotificationSettings settings;
}
class PrayerNotificationError extends PrayerNotificationState {
  final String message;
}

// Cubit
class PrayerNotificationCubit extends Cubit<PrayerNotificationState> {
  // تحميل الإعدادات
  Future<void> loadSettings();

  // تحديث إعداد صلاة معينة
  Future<void> togglePrayerNotification(String prayerName, bool enabled);

  // تحديث وقت التنبيه المسبق
  Future<void> setPreAlertMinutes(int minutes);

  // جدولة الإشعارات
  Future<void> scheduleNotifications(PrayerTimesEntity prayerTimes);
}
```

---

## المرحلة 2.2: شاشة إعدادات الإشعارات

### التصميم:

```
┌─────────────────────────────────────┐
│     إعدادات إشعارات الصلاة         │
├─────────────────────────────────────┤
│                                     │
│  ☑️ الفجر         ───────── 🔔      │
│  ☑️ الظهر         ───────── 🔔      │
│  ☑️ العصر         ───────── 🔔      │
│  ☑️ المغرب        ───────── 🔔      │
│  ☑️ العشاء        ───────── 🔔      │
│                                     │
├─────────────────────────────────────┤
│  التنبيه المسبق                    │
│  ┌───┐ ┌───┐ ┌────┐ ┌────┐        │
│  │ 0 │ │ 5 │ │ 10 │ │ 15 │ دقيقة  │
│  └───┘ └───┘ └────┘ └────┘        │
│                                     │
├─────────────────────────────────────┤
│  صوت الأذان                        │
│  ☑️ تفعيل صوت الأذان               │
│  [ اختر المؤذن ▼ ]                 │
│                                     │
└─────────────────────────────────────┘
```

### Widgets المطلوبة:

1. **PrayerNotificationSettingsScreen** - الشاشة الرئيسية
2. **PrayerNotificationTile** - صف لكل صلاة
3. **PreAlertSelector** - اختيار وقت التنبيه المسبق
4. **AdhanSoundSelector** - اختيار صوت الأذان

---

## المرحلة 2.3: صوت الأذان

### ملفات الصوت:
```
assets/audio/
├── adhan_makkah.mp3      (~3 دقائق)
├── adhan_madinah.mp3     (~3 دقائق)
├── adhan_alaqsa.mp3      (~3 دقائق)
└── adhan_fajr.mp3        (أذان الفجر المميز)
```

### التنفيذ:
1. استخدام `audioplayers` package لتشغيل الصوت
2. تشغيل الأذان مع الإشعار (Foreground Service لـ Android)
3. دعم إيقاف الصوت من الإشعار

---

## Notification IDs

لتجنب التعارض مع إشعارات الأذكار الموجودة:

| الصلاة | Notification ID | Pre-Alert ID |
|--------|-----------------|--------------|
| الفجر | 1001 | 2001 |
| الظهر | 1002 | 2002 |
| العصر | 1003 | 2003 |
| المغرب | 1004 | 2004 |
| العشاء | 1005 | 2005 |

---

## SharedPreferences Keys

```dart
class PrayerNotificationKeys {
  static const String fajrEnabled = 'prayer_notification_fajr';
  static const String dhuhrEnabled = 'prayer_notification_dhuhr';
  static const String asrEnabled = 'prayer_notification_asr';
  static const String maghribEnabled = 'prayer_notification_maghrib';
  static const String ishaEnabled = 'prayer_notification_isha';
  static const String preAlertMinutes = 'prayer_notification_pre_alert';
  static const String soundEnabled = 'prayer_notification_sound';
  static const String selectedAdhan = 'prayer_notification_adhan';
}
```

---

## التكامل مع النظام الحالي

### 1. التكامل مع PrayerTimesCubit:
```dart
// في PrayerTimesCubit عند جلب مواقيت جديدة:
void _onPrayerTimesLoaded(PrayerTimesEntity prayerTimes) {
  // جدولة الإشعارات
  prayerNotificationCubit.scheduleNotifications(prayerTimes);
}
```

### 2. التكامل مع Settings Screen:
```dart
// إضافة قسم إشعارات الصلاة في شاشة الإعدادات
ListTile(
  leading: Icon(Icons.notifications_active),
  title: Text('إشعارات الصلاة'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () => Navigator.push(
    context,
    PrayerNotificationSettingsScreen.route(),
  ),
)
```

### 3. التكامل في main.dart:
```dart
void main() async {
  // ... existing initialization

  // Initialize prayer notifications
  await PrayerNotificationService.initialize();

  // Schedule notifications on app start
  final prayerTimes = await getCachedPrayerTimes();
  if (prayerTimes != null) {
    await PrayerNotificationService.scheduleNotifications(prayerTimes);
  }
}
```

---

## الاختبارات المطلوبة

### Unit Tests:
1. `prayer_notification_service_test.dart`
   - اختبار جدولة الإشعارات
   - اختبار إلغاء الإشعارات
   - اختبار التنبيه المسبق

2. `prayer_notification_cubit_test.dart`
   - اختبار تحميل الإعدادات
   - اختبار تغيير الإعدادات
   - اختبار حفظ الإعدادات

3. `prayer_notification_datasource_test.dart`
   - اختبار حفظ/قراءة الإعدادات

### Widget Tests:
1. `prayer_notification_settings_screen_test.dart`
   - اختبار عرض الإعدادات
   - اختبار التفاعل مع switches
   - اختبار اختيار وقت التنبيه

---

## خطوات التنفيذ

### الأسبوع 1: المرحلة 2.1
1. ✅ إنشاء هيكل المجلدات
2. ⏳ إنشاء Prayer Notification Settings Entity/Model
3. ⏳ إنشاء Prayer Notification Local Datasource
4. ⏳ إنشاء Prayer Notification Service
5. ⏳ إنشاء Prayer Notification Cubit
6. ⏳ كتابة Unit Tests

### الأسبوع 2: المرحلة 2.2
1. ⏳ إنشاء Prayer Notification Settings Screen
2. ⏳ إنشاء Prayer Notification Tile Widget
3. ⏳ إنشاء Pre-Alert Selector Widget
4. ⏳ التكامل مع Settings Screen
5. ⏳ كتابة Widget Tests

### الأسبوع 3: المرحلة 2.3
1. ⏳ إضافة ملفات صوت الأذان
2. ⏳ إنشاء Adhan Player Service
3. ⏳ إنشاء Adhan Sound Selector Widget
4. ⏳ التكامل مع الإشعارات
5. ⏳ كتابة Integration Tests

---

## الملاحظات الهامة

1. **Android Background Restrictions**: يجب التعامل مع قيود الخلفية في Android 12+
2. **iOS Background Audio**: يحتاج تفعيل Background Modes في Xcode
3. **Timezone Handling**: استخدام `flutter_timezone` للتعامل مع التوقيت المحلي
4. **Battery Optimization**: تنبيه المستخدم لإضافة التطبيق للاستثناءات

---

## Legend

| الرمز | المعنى |
|-------|--------|
| ✅ | مكتمل |
| ⏳ | لم يبدأ |
| 🔄 | قيد التنفيذ |
