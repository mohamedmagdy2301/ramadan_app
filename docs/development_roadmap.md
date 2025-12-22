# خطة التطوير الشاملة - تطبيق أذكاري

## تاريخ الإنشاء: 2025-12-22

---

# المرحلة 1: الإصلاحات العاجلة (Critical Fixes) 🔴

## 1.1 إصلاح معالجة الأخطاء (Error Handling) ✅
- [x] إنشاء `core/error/exceptions.dart` - Custom Exceptions
- [x] إنشاء `core/error/failures.dart` - Failure classes
- [x] إنشاء `core/network/api_client.dart` - Dio singleton with error handling
- [x] إنشاء `core/network/network_info.dart` - Connectivity checker
- [x] إضافة Retry mechanism للـ API calls
- [x] **Tests:** 34 unit tests for error handling ✅

## 1.2 إصلاح خطأ التحقق من الوقت ✅
- [x] إنشاء `core/utils/functions/time_utils.dart` - Time utilities
- [x] إصلاح `azkar_notification_cubit.dart` - استخدام TimeUtils.isTimeInFuture
- [x] إضافة proper DateTime comparison
- [x] **Tests:** 23 unit tests for time validation ✅

## 1.3 إصلاح تسرب الذاكرة ✅
- [x] إنشاء Dio singleton في `core/network/api_client.dart`
- [x] إضافة Logging و Retry interceptors
- [ ] إصلاح StreamSubscription disposal (سيتم في مرحلة لاحقة)
- [x] **Tests:** Integration tests for resource cleanup

## 1.4 إضافة Caching لمواقيت الصلاة ✅
- [x] إنشاء `prayer_times_local_datasource.dart` - Local caching
- [x] إنشاء `prayer_times_remote_datasource.dart` - Remote API calls
- [x] إنشاء `prayer_times_repository.dart` - Repository with caching strategy
- [x] Cache prayer times locally (valid for 1 day)
- [x] Offline fallback with cached data
- [x] Location-based cache invalidation (>1km movement)
- [x] **Tests:** 23 unit tests for caching logic ✅

---

# المرحلة 2: إشعارات الصلاة (Prayer Notifications) 🔴

## 2.1 بنية الإشعارات ✅
- [x] إنشاء `PrayerNotificationService` - Service with singleton pattern
- [x] إنشاء `PrayerNotificationSettings` entity و `PrayerNotificationLocalDatasource`
- [x] إنشاء `PrayerNotificationCubit` لإدارة الحالة
- [x] جدولة إشعارات لكل صلاة يومياً
- [x] إشعار تنبيه قبل الصلاة (اختياري - 0/5/10/15 دقيقة)
- [x] **Tests:** 50 unit tests for notification scheduling ✅

## 2.2 إعدادات الإشعارات ✅
- [x] إضافة شاشة إعدادات إشعارات الصلاة
- [x] تفعيل/تعطيل لكل صلاة
- [x] اختيار وقت التنبيه المسبق (5/10/15 دقيقة)
- [x] **Tests:** 24 widget tests for settings UI ✅

## 2.3 صوت الأذان ✅
- [x] إضافة ملفات صوت الأذان
- [x] اختيار المؤذن
- [x] تشغيل الأذان مع الإشعار
- [x] **Tests:** 20 unit tests for AdhanSound and AdhanPlayerService ✅

---

# المرحلة 3: تحسين جودة الكود (Code Quality) ✅

## 3.1 إصلاح أسماء الملفات ✅
- [x] `prayper_times_cubit.dart` → `prayer_times_cubit.dart`
- [x] `ayah_modell.dart` → `ayah_model.dart`
- [x] `veiw/` → `view/` (في Sabha و Settings)
- [x] `Azkary_app.dart` → `azkary_app.dart`
- [x] `prayer_time_loaded_UI.dart` → `prayer_time_loaded_ui.dart`
- [x] `AyahModell` class → `AyahModel` class
- [x] **Tests:** All 175 tests passing ✅

## 3.2 Refactor Hardcoded Items ✅
- [x] إنشاء `storage_keys.dart` لمفاتيح SharedPreferences
- [x] إضافة constants للـ assets في `app_images.dart`
- [x] إضافة strings للـ dialogs في `app_strings.dart`
- [x] تحديث الملفات لاستخدام الـ constants
- [x] **Tests:** All 175 tests passing ✅

## 3.3 Dependency Injection ✅
- [x] إضافة GetIt package
- [x] إنشاء `core/di/injection_container.dart`
- [x] تسجيل SharedPreferences, Connectivity, Dio
- [x] تسجيل PrayerTimesRepository, PrayerNotificationLocalDatasource
- [x] تسجيل PrayerNotificationService, AdhanPlayerService
- [x] تسجيل PrayerTimesCubit, PrayerNotificationCubit
- [x] **Tests:** All 175 tests passing ✅

## 3.4 توحيد Navigation ✅
- [x] إضافة route للـ PrayerNotificationSettingsScreen
- [x] استخدام GoRouter context.push() للتنقل
- [x] دمج BlocProvider مع GoRouter
- [x] **Tests:** All 175 tests passing ✅

---

# المرحلة 4: Accessibility (إمكانية الوصول) 🟡

## 4.1 Semantics للعناصر الأساسية ✅
- [x] إضافة Semantics لأيقونات شريط التنقل السفلي
- [x] إضافة Semantics wrapper لعناصر الإعدادات
- [x] استخدام ExcludeSemantics لمنع التكرار
- [x] **Tests:** All 175 tests passing ✅

## 4.2 تحسين قابلية القراءة
- [ ] التحقق من contrast ratios
- [ ] إضافة خيار تكبير الخط
- [ ] دعم TalkBack/VoiceOver
- [ ] **Tests:** Visual regression tests

---

# المرحلة 5: ميزات جديدة (New Features) 🟢

## 5.1 بوصلة القبلة
- [ ] إنشاء `features/qibla/`
- [ ] استخدام Compass sensor
- [ ] حساب اتجاه القبلة
- [ ] UI للبوصلة
- [ ] **Tests:** Unit & Widget tests

## 5.2 التقويم الهجري
- [ ] إنشاء `features/hijri_calendar/`
- [ ] عرض التقويم الشهري
- [ ] عرض المناسبات الإسلامية
- [ ] **Tests:** Unit & Widget tests

## 5.3 المفضلة والمشاركة
- [ ] إضافة زر المفضلة للأذكار
- [ ] إضافة زر المشاركة
- [ ] حفظ المفضلة في SharedPreferences
- [ ] **Tests:** Unit & Widget tests

## 5.4 الإحصائيات
- [ ] تتبع الأذكار اليومية
- [ ] تتبع قراءة القرآن
- [ ] عرض الإحصائيات
- [ ] **Tests:** Unit tests

---

# المرحلة 6: Responsiveness والتابلت 🟢

## 6.1 دعم التابلت
- [ ] إضافة Tablet layouts
- [ ] استخدام LayoutBuilder
- [ ] تحسين الأحجام للشاشات الكبيرة
- [ ] **Tests:** Golden tests for different screen sizes

## 6.2 دعم Landscape
- [ ] إزالة قفل Portrait
- [ ] تصميم Landscape layouts
- [ ] **Tests:** Orientation tests

---

# المرحلة 7: الاختبارات الشاملة 🔵

## 7.1 Unit Tests
- [ ] Tests لجميع الـ Cubits
- [ ] Tests لجميع الـ Repositories
- [ ] Tests لجميع الـ Services
- [ ] Coverage target: 80%+

## 7.2 Widget Tests
- [ ] Tests لجميع الشاشات
- [ ] Tests للـ Custom Widgets
- [ ] Tests للـ Forms

## 7.3 Integration Tests
- [ ] End-to-end flows
- [ ] Navigation tests
- [ ] State persistence tests

---

# ترتيب التنفيذ

| الأسبوع | المهمة | الحالة |
|---------|--------|--------|
| 1 | المرحلة 1.1 - Error Handling | ✅ |
| 1 | المرحلة 1.2 - Time Validation Fix | ✅ |
| 1 | المرحلة 1.3 - Memory Leaks | ✅ |
| 1 | المرحلة 1.4 - Caching | ✅ |
| 2 | المرحلة 2.1 - Prayer Notifications | ✅ |
| 2 | المرحلة 2.2 - Notification Settings | ✅ |
| 2 | المرحلة 2.3 - Adhan Sound | ✅ |
| 3 | المرحلة 3 - Code Quality | ✅ |
| 5 | المرحلة 4 - Accessibility | 🔄 |
| 6-8 | المرحلة 5 - New Features | ⏳ |
| 9 | المرحلة 6 - Responsiveness | ⏳ |
| 10 | المرحلة 7 - Full Testing | ⏳ |

---

# Legend

| الرمز | المعنى |
|-------|--------|
| ⏳ | لم يبدأ |
| 🔄 | قيد التنفيذ |
| ✅ | مكتمل |
| ❌ | ملغي |
| 🔴 | أولوية عالية |
| 🟡 | أولوية متوسطة |
| 🟢 | أولوية منخفضة |
| 🔵 | اختبارات |
