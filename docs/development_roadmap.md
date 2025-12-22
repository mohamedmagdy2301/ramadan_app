# خطة التطوير الشاملة - تطبيق أذكاري

## تاريخ الإنشاء: 2025-12-22
## آخر تحديث: 2025-12-22

---

# المرحلة 1: الإصلاحات العاجلة (Critical Fixes) ✅

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

# المرحلة 2: إشعارات الصلاة (Prayer Notifications) ✅

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
- [x] **Tests:** All tests passing ✅

## 3.2 Refactor Hardcoded Items ✅
- [x] إنشاء `storage_keys.dart` لمفاتيح SharedPreferences
- [x] إضافة constants للـ assets في `app_images.dart`
- [x] إضافة strings للـ dialogs في `app_strings.dart`
- [x] تحديث الملفات لاستخدام الـ constants
- [x] **Tests:** All tests passing ✅

## 3.3 Dependency Injection ✅
- [x] إضافة GetIt package
- [x] إنشاء `core/di/injection_container.dart`
- [x] تسجيل SharedPreferences, Connectivity, Dio
- [x] تسجيل PrayerTimesRepository, PrayerNotificationLocalDatasource
- [x] تسجيل PrayerNotificationService, AdhanPlayerService
- [x] تسجيل PrayerTimesCubit, PrayerNotificationCubit
- [x] **Tests:** All tests passing ✅

## 3.4 توحيد Navigation ✅
- [x] إضافة route للـ PrayerNotificationSettingsScreen
- [x] استخدام GoRouter context.push() للتنقل
- [x] دمج BlocProvider مع GoRouter
- [x] **Tests:** All tests passing ✅

---

# المرحلة 4: Accessibility (إمكانية الوصول) ✅

## 4.1 Semantics للعناصر الأساسية ✅
- [x] إضافة Semantics لأيقونات شريط التنقل السفلي
- [x] إضافة Semantics wrapper لعناصر الإعدادات
- [x] استخدام ExcludeSemantics لمنع التكرار
- [x] **Tests:** All tests passing ✅

## 4.2 تحسين قابلية القراءة ✅
- [x] إنشاء `core/accessibility/accessibility_settings.dart`
- [x] إضافة خيار تكبير الخط (صغير/عادي/كبير/كبير جداً)
- [x] إنشاء `font_size_selector.dart` widget
- [x] دمج مع الإعدادات
- [x] **Tests:** All tests passing ✅

---

# المرحلة 5: ميزات جديدة (New Features) ✅

## 5.1 بوصلة القبلة ✅
- [x] إنشاء `features/qibla/`
- [x] إنشاء `qibla_calculator.dart` - حساب اتجاه القبلة
- [x] إنشاء `location_service.dart` - خدمة الموقع
- [x] إنشاء `compass_widget.dart` - UI البوصلة
- [x] إنشاء `qibla_screen.dart` - شاشة القبلة
- [x] إضافة كارت القبلة في الصفحة الرئيسية
- [x] **Tests:** Unit tests for QiblaCalculator ✅

## 5.2 التقويم الهجري ✅
- [x] إنشاء `features/hijri_calendar/`
- [x] إنشاء `hijri_date.dart` - entity للتاريخ الهجري
- [x] إنشاء `hijri_date_converter.dart` - تحويل التواريخ
- [x] إنشاء `islamic_events.dart` - المناسبات الإسلامية
- [x] إنشاء `hijri_date_card.dart` - كارت التاريخ
- [x] **Tests:** Unit tests for date conversion ✅

## 5.3 المفضلة ✅
- [x] إنشاء `features/favorites/`
- [x] إنشاء `favorite_type.dart` و `favorite_item.dart` entities
- [x] إنشاء `favorites_local_datasource.dart` - حفظ المفضلة
- [x] إنشاء `favorites_cubit.dart` - إدارة الحالة
- [x] إنشاء `favorites_screen.dart` - شاشة المفضلة
- [x] إنشاء `favorite_button.dart` - زر الإضافة للمفضلة
- [x] **Tests:** Unit & Widget tests ✅

## 5.4 الإحصائيات ✅
- [x] إنشاء `features/statistics/`
- [x] إنشاء `daily_stats.dart` و `stats_summary.dart` entities
- [x] إنشاء `statistics_local_datasource.dart` - حفظ الإحصائيات
- [x] إنشاء `statistics_cubit.dart` - إدارة الحالة
- [x] إنشاء `statistics_screen.dart` - شاشة الإحصائيات
- [x] إنشاء widgets (StatCard, StreakCard, EmptyStatsWidget)
- [x] تتبع الأذكار والقرآن والتسبيحات
- [x] حساب السلسلة (Streak) والانتظام
- [x] **Tests:** 21 unit tests ✅

---

# المرحلة 6: Responsiveness والتابلت ✅

## 6.1 دعم التابلت ✅
- [x] إنشاء `core/responsive/screen_type.dart`
- [x] إنشاء `core/responsive/responsive_helper.dart`
- [x] إنشاء `core/responsive/responsive_layout.dart`
- [x] إضافة ResponsiveContainer و ResponsiveGrid widgets
- [x] **Tests:** Widget tests for responsive layouts ✅

## 6.2 دعم Landscape
- [ ] إزالة قفل Portrait (اختياري - حسب الحاجة)
- [ ] تصميم Landscape layouts

---

# المرحلة 7: الاختبارات الشاملة ✅

## 7.1 Unit Tests ✅
- [x] Tests لجميع الـ Cubits
- [x] Tests لجميع الـ Repositories
- [x] Tests لجميع الـ Services
- [x] **إجمالي: 247 اختبار ناجح**

## 7.2 Widget Tests ✅
- [x] Tests للـ Custom Widgets
- [x] Tests للـ Settings UI
- [x] Tests للـ Prayer Notifications UI

## 7.3 Integration Tests
- [ ] End-to-end flows (اختياري)
- [ ] Navigation tests (اختياري)

---

# ملخص الإنجازات

| المرحلة | الحالة | عدد الاختبارات |
|---------|--------|---------------|
| المرحلة 1 - الإصلاحات العاجلة | ✅ مكتمل | 80+ |
| المرحلة 2 - إشعارات الصلاة | ✅ مكتمل | 94 |
| المرحلة 3 - جودة الكود | ✅ مكتمل | - |
| المرحلة 4 - إمكانية الوصول | ✅ مكتمل | - |
| المرحلة 5 - ميزات جديدة | ✅ مكتمل | 40+ |
| المرحلة 6 - Responsiveness | ✅ مكتمل | 10+ |
| المرحلة 7 - الاختبارات | ✅ مكتمل | **247 إجمالي** |

---

# Legend

| الرمز | المعنى |
|-------|--------|
| ⏳ | لم يبدأ |
| 🔄 | قيد التنفيذ |
| ✅ | مكتمل |
| ❌ | ملغي |

---

## التطبيق جاهز للنشر! 🎉

جميع الميزات الأساسية مكتملة ومختبرة:
- ✅ مواقيت الصلاة مع Caching
- ✅ إشعارات الصلاة مع الأذان
- ✅ الأذكار والأدعية
- ✅ القرآن الكريم
- ✅ السبحة الإلكترونية
- ✅ بوصلة القبلة
- ✅ التقويم الهجري
- ✅ المفضلة
- ✅ الإحصائيات
- ✅ دعم الوضع الداكن/الفاتح
- ✅ تخصيص الألوان
- ✅ تخصيص حجم الخط
- ✅ دعم التابلت
