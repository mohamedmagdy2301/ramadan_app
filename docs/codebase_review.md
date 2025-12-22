# تقرير مراجعة الكود الشامل - تطبيق أذكاري

## تاريخ المراجعة: 2025-12-22

---

## 1. المميزات الحالية ✅

### الشاشة الرئيسية (مواقيت الصلاة)
- ✅ عرض مواقيت الصلاة اليومية
- ✅ تحديد الموقع تلقائياً عبر GPS
- ✅ عد تنازلي للصلاة القادمة
- ✅ تحديث كل 30 ثانية
- ✅ عرض التاريخ الهجري والميلادي
- ✅ دعاء اليوم
- ✅ Home Widget للـ iOS

### الأذكار
- ✅ 8 أقسام (أذكار الصباح، المساء، التسبيحات، بعد الصلاة، النوم، الاستيقاظ، أدعية قرآنية، أدعية نبوية)
- ✅ عداد لكل ذكر مع إعادة تعيين يومية
- ✅ إشعارات مجدولة لكل قسم
- ✅ حفظ حالة العداد

### القرآن الكريم
- ✅ عرض السور والأجزاء
- ✅ البحث في الآيات
- ✅ العلامات المرجعية (Bookmarks)
- ✅ تشغيل صوتي للآيات
- ✅ اختيار القارئ (8 قراء)

### السبحة الإلكترونية
- ✅ 7 أنواع تسبيح
- ✅ عداد متحرك
- ✅ حفظ العد

### الإعدادات
- ✅ الوضع الداكن/الفاتح
- ✅ 7 ألوان للثيم
- ✅ حفظ التفضيلات

---

## 2. العيوب والمشاكل 🔴

### مشاكل حرجة

#### أ) معالجة الأخطاء
```dart
// lib/core/network/api_services.dart - لا يوجد try-catch
getApi({required String url}) async {
  http.Response response = await http.get(Uri.parse(url)); // بدون timeout
  if (response.statusCode == 200) {
    return json.decode(response.body); // قد يتعطل مع JSON غير صالح
  }
}
```

#### ب) خطأ في التحقق من الوقت
```dart
// lib/features/azkar/presentation/view_model/notification_manager/azkar_notification_cubit.dart:70-72
if (selectedTime!.hour >= DateTime.now().hour &&
    selectedTime!.minute > DateTime.now().minute) {
  // BUG: الساعة 14:45 ليست أكبر من 14:30 بهذا المنطق!
}
```
**الحل الصحيح:**
```dart
final now = DateTime.now();
final selected = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
if (selected.isAfter(now)) {
  // صحيح
}
```

#### ج) تسرب الذاكرة
- Dio instance يتم إنشاؤه مع كل طلب
- StreamSubscription لا يتم إلغاؤها دائماً

### مشاكل متوسطة

#### أ) أخطاء في أسماء الملفات
| الملف الحالي | الصحيح |
|-------------|--------|
| `prayper_times_cubit.dart` | `prayer_times_cubit.dart` |
| `ayah_modell.dart` | `ayah_model.dart` |
| `veiw/` folder | `view/` |

#### ب) كود مكرر (Hardcoded)
```dart
// lib/features/azkar/presentation/view/widgets/azkar_screen_body.dart
// 8 عناصر مكتوبة يدوياً بدلاً من ListView.builder
AzkarScreenBodyItem(azkarIndex: 0, cubit: AzkarNotificationCubit(azkarScreenBodyItemModel[0])),
AzkarScreenBodyItem(azkarIndex: 1, cubit: AzkarNotificationCubit(azkarScreenBodyItemModel[1])),
// ... x8
```

#### ج) لا يوجد Caching
- مواقيت الصلاة تُجلب من الـ API كل 30 ثانية
- لا يوجد حفظ محلي للبيانات عند فقدان الاتصال

---

## 3. الميزات الناقصة 📋

### ميزات أساسية مفقودة

| الميزة | الأولوية | الوصف |
|--------|----------|-------|
| إشعارات الصلاة | عالية جداً | لا توجد إشعارات لمواقيت الصلاة! |
| الأذان | عالية جداً | تشغيل الأذان عند دخول وقت الصلاة |
| القبلة | عالية | بوصلة اتجاه القبلة |
| التقويم الهجري | عالية | عرض التقويم الشهري |
| النسخ الاحتياطي | متوسطة | حفظ/استعادة البيانات |
| المشاركة | متوسطة | مشاركة الأذكار والآيات |
| المفضلة | متوسطة | حفظ الأذكار المفضلة |
| البحث في الأذكار | متوسطة | البحث عن ذكر معين |
| الإحصائيات | منخفضة | تتبع الأذكار والقراءة |
| تعدد اللغات | منخفضة | دعم الإنجليزية |

### ميزات تقنية مفقودة

| الميزة | الأهمية |
|--------|---------|
| Offline Mode | عالية |
| Deep Linking | متوسطة |
| Unit Tests | عالية |
| Integration Tests | عالية |
| Error Logging (Crashlytics) | عالية |
| Analytics | متوسطة |
| Rate App Dialog | منخفضة |

---

## 4. الـ Responsiveness (التجاوب) 📱

### الوضع الحالي
- ✅ يستخدم `flutter_screenutil` للأبعاد
- ✅ `ScreenUtil.init()` بحجم تصميم 390x844
- ✅ استخدام `.w`, `.h`, `.sp`, `.r` للأبعاد

### المشاكل
| المشكلة | الملف |
|---------|-------|
| حجم ثابت لـ BottomNavBar (70.h) | `Azkary_app.dart:209` |
| لا يوجد دعم للـ Tablet | جميع الملفات |
| لا يوجد Landscape mode | مقفل في Portrait |
| بعض الأحجام ثابتة | متفرقة |

### التوصيات
```dart
// استخدام LayoutBuilder للتابلت
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return TabletLayout();
    }
    return MobileLayout();
  },
)
```

---

## 5. الـ Accessibility (إمكانية الوصول) ♿

### الوضع الحالي: ❌ لا يوجد!

**لم يتم العثور على أي من:**
- `Semantics` widget
- `semanticsLabel` property
- `ExcludeSemantics`
- `MergeSemantics`

### ما يجب إضافته

```dart
// مثال: زر التسبيح
Semantics(
  label: 'زر التسبيح، العدد الحالي $count',
  button: true,
  child: GestureDetector(
    onTap: _incrementCounter,
    child: CounterWidget(count: count),
  ),
)

// مثال: صورة
Image.asset(
  'assets/images/quran.png',
  semanticLabel: 'أيقونة القرآن الكريم',
)

// مثال: وقت الصلاة
Semantics(
  label: 'صلاة الفجر الساعة 5:30 صباحاً',
  child: PrayerTimeRow(name: 'الفجر', time: '5:30'),
)
```

### قائمة التحسينات المطلوبة
1. إضافة `semanticLabel` لجميع الأيقونات والصور
2. إضافة `Semantics` للأزرار التفاعلية
3. دعم قارئ الشاشة (TalkBack/VoiceOver)
4. تحسين التباين للنصوص
5. دعم تكبير الخط

---

## 6. نظام الإشعارات 🔔

### الوضع الحالي

#### إشعارات الأذكار ✅
```dart
// LocalNotificationService - يعمل
showDailyScheduledNotification(
  id: azkarId,
  title: 'أذكار الصباح',
  body: 'موعد أذكار الصباح',
  hour: 6,
  minute: 0,
);
```

#### إشعارات الصلاة ❌ غير موجودة!
**هذه مشكلة كبيرة** - التطبيق يعرض مواقيت الصلاة لكن لا يُرسل إشعارات!

### المشاكل في النظام الحالي

1. **خطأ في التحقق من الوقت** (سبق شرحه)
2. **لا يوجد إشعار قبل الصلاة** (تنبيه مسبق)
3. **لا يوجد صوت أذان**
4. **لا يوجد إشعار مستمر (Foreground Service)**
5. **لا يعمل عند إغلاق التطبيق بالكامل**

### البنية المقترحة للإشعارات

```dart
class NotificationService {
  // إشعارات الصلاة
  Future<void> schedulePrayerNotifications(List<PrayerTime> times) async {
    for (var prayer in times) {
      // إشعار وقت الصلاة
      await scheduleNotification(
        id: prayer.id,
        title: 'حان وقت صلاة ${prayer.name}',
        scheduledTime: prayer.time,
        sound: 'adhan.mp3',
      );

      // إشعار تنبيه قبل 15 دقيقة (اختياري)
      if (settings.preNotificationEnabled) {
        await scheduleNotification(
          id: prayer.id + 100,
          title: 'تبقى 15 دقيقة على صلاة ${prayer.name}',
          scheduledTime: prayer.time.subtract(Duration(minutes: 15)),
        );
      }
    }
  }

  // إشعارات الأذكار (موجودة)
  Future<void> scheduleAzkarNotification(...) { ... }
}
```

---

## 7. الإعدادات والتفضيلات ⚙️

### الموجود حالياً
| الإعداد | الحالة |
|---------|--------|
| الوضع الداكن/الفاتح | ✅ |
| لون الثيم | ✅ |
| إشعارات الأذكار | ✅ |

### المفقود
| الإعداد | الأولوية |
|---------|----------|
| إشعارات الصلاة | عالية جداً |
| اختيار صوت الأذان | عالية |
| التنبيه قبل الصلاة | عالية |
| اختيار طريقة الحساب | عالية |
| اختيار المذهب | متوسطة |
| حجم الخط | متوسطة |
| اختيار القارئ الافتراضي | متوسطة |
| إعادة تعيين العدادات | منخفضة |
| النسخ الاحتياطي | منخفضة |

---

## 8. هيكلة الكود 🏗️

### الإيجابيات
- ✅ Feature-based architecture
- ✅ استخدام Cubit pattern
- ✅ فصل الـ Data/Domain/Presentation
- ✅ Context extensions للثيم
- ✅ Constants منظمة

### السلبيات
- ❌ لا يوجد Dependency Injection
- ❌ لا يوجد Repository pattern صحيح (Dio inside Cubit)
- ❌ خلط أنماط Navigation (GoRouter + PersistentNavBar + MaterialPageRoute)
- ❌ لا يوجد Error Handling موحد
- ❌ لا يوجد Caching Layer

### الهيكل المقترح

```
lib/
├── core/
│   ├── di/                    # Dependency Injection (GetIt)
│   ├── error/                 # Custom Exceptions & Failures
│   ├── network/
│   │   ├── api_client.dart    # Dio singleton
│   │   └── network_info.dart  # Connectivity
│   └── ...
├── features/
│   ├── prayer_times/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── prayer_remote_datasource.dart
│   │   │   │   └── prayer_local_datasource.dart  # Caching
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/    # Abstract
│   │   │   └── usecases/
│   │   └── presentation/
│   └── ...
```

---

## 9. الأداء 🚀

### مشاكل الأداء الحالية

1. **API Calls زائدة**
   - جلب مواقيت الصلاة كل 30 ثانية (غير ضروري)
   - يجب جلبها مرة واحدة يومياً

2. **Memory Usage**
   - 5 شاشات محفوظة في الذاكرة دائماً
   - لا يوجد dispose صحيح للـ Controllers

3. **SharedPreferences**
   - قراءة متزامنة في constructors
   - يجب أن تكون async

### التوصيات
```dart
// Cache prayer times locally
class PrayerTimesCache {
  static const _key = 'cached_prayer_times';
  static const _dateKey = 'cache_date';

  Future<PrayerTimes?> getCached() async {
    final date = prefs.getString(_dateKey);
    if (date == DateTime.now().toDateString()) {
      return PrayerTimes.fromJson(prefs.getString(_key));
    }
    return null; // Fetch new
  }
}
```

---

## 10. خطة التطوير المقترحة 📅

### المرحلة 1: الإصلاحات العاجلة
1. إضافة إشعارات الصلاة
2. إصلاح خطأ التحقق من الوقت
3. إضافة Error Handling
4. Cache مواقيت الصلاة

### المرحلة 2: التحسينات
1. بوصلة القبلة
2. التقويم الهجري
3. تحسين الـ Accessibility
4. إضافة Unit Tests

### المرحلة 3: الميزات الجديدة
1. صوت الأذان
2. المفضلة والمشاركة
3. الإحصائيات
4. النسخ الاحتياطي

---

## 11. ملخص التقييم

| المعيار | التقييم | ملاحظات |
|---------|---------|---------|
| الوظائف الأساسية | 7/10 | تعمل لكن تنقصها إشعارات الصلاة |
| جودة الكود | 6/10 | بنية جيدة لكن أخطاء متعددة |
| الأداء | 5/10 | API calls زائدة، لا caching |
| UI/UX | 8/10 | تصميم جميل ومتناسق |
| Responsiveness | 6/10 | يعمل على الموبايل فقط |
| Accessibility | 2/10 | شبه معدوم |
| الإشعارات | 5/10 | الأذكار فقط، الصلاة مفقودة |
| الاختبارات | 0/10 | لا يوجد |

**التقييم العام: 5.5/10**

التطبيق لديه أساس جيد وتصميم جميل، لكنه يحتاج تحسينات جوهرية خاصة في إشعارات الصلاة والـ Accessibility والاختبارات.
