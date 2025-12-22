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

## 2.1 بنية الإشعارات
- [ ] إنشاء `PrayerNotificationService`
- [ ] جدولة إشعارات لكل صلاة يومياً
- [ ] إشعار تنبيه قبل الصلاة (اختياري)
- [ ] **Tests:** Unit tests for notification scheduling

## 2.2 إعدادات الإشعارات
- [ ] إضافة شاشة إعدادات إشعارات الصلاة
- [ ] تفعيل/تعطيل لكل صلاة
- [ ] اختيار وقت التنبيه المسبق (5/10/15 دقيقة)
- [ ] **Tests:** Widget tests for settings UI

## 2.3 صوت الأذان
- [ ] إضافة ملفات صوت الأذان
- [ ] اختيار المؤذن
- [ ] تشغيل الأذان مع الإشعار
- [ ] **Tests:** Integration tests for audio playback

---

# المرحلة 3: تحسين جودة الكود (Code Quality) 🟡

## 3.1 إصلاح أسماء الملفات
- [ ] `prayper_times_cubit.dart` → `prayer_times_cubit.dart`
- [ ] `ayah_modell.dart` → `ayah_model.dart`
- [ ] `veiw/` → `view/` (في Sabha و Settings)
- [ ] `Azkary_app.dart` → `azkary_app.dart`
- [ ] **Tests:** Verify imports still work

## 3.2 Refactor Hardcoded Items
- [ ] تحويل `azkar_screen_body.dart` لاستخدام ListView.builder
- [ ] إزالة الكود المكرر
- [ ] **Tests:** Widget tests for dynamic list

## 3.3 Dependency Injection
- [ ] إضافة GetIt package
- [ ] إنشاء `core/di/injection_container.dart`
- [ ] تسجيل Services و Repositories
- [ ] **Tests:** Unit tests for DI setup

## 3.4 توحيد Navigation
- [ ] استخدام GoRouter فقط
- [ ] إزالة MaterialPageRoute المباشر
- [ ] إضافة جميع الـ routes
- [ ] **Tests:** Navigation tests

---

# المرحلة 4: Accessibility (إمكانية الوصول) 🟡

## 4.1 Semantics للعناصر الأساسية
- [ ] إضافة semanticLabel لجميع الأيقونات
- [ ] إضافة Semantics للأزرار التفاعلية
- [ ] إضافة Semantics لمواقيت الصلاة
- [ ] **Tests:** Accessibility tests

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
| 2 | المرحلة 2.1 - Prayer Notifications | ⏳ |
| 3 | المرحلة 2.2 - Notification Settings | ⏳ |
| 3 | المرحلة 2.3 - Adhan Sound | ⏳ |
| 4 | المرحلة 3 - Code Quality | ⏳ |
| 5 | المرحلة 4 - Accessibility | ⏳ |
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
