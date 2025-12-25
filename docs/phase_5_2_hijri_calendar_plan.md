# Phase 5.2: Hijri Calendar Feature Plan

## Overview
إضافة ميزة التقويم الهجري لعرض التاريخ الهجري الحالي والمناسبات الإسلامية المهمة.

## Technical Requirements

### Dependencies
سنستخدم مكتبة `hijri_calendar` أو حساب التاريخ الهجري يدوياً.

لا نحتاج dependency جديدة - سنستخدم خوارزمية تحويل التاريخ المعروفة.

### Hijri Date Calculation
التحويل من الميلادي للهجري يتم باستخدام خوارزمية أم القرى.

## File Structure
```
lib/features/hijri_calendar/
├── data/
│   ├── hijri_date_converter.dart      # تحويل التاريخ
│   └── islamic_events.dart            # المناسبات الإسلامية
├── domain/
│   └── hijri_date.dart                # كيان التاريخ الهجري
├── presentation/
│   ├── view/
│   │   └── screens/
│   │       └── hijri_calendar_screen.dart
│   └── widgets/
│       ├── hijri_date_card.dart       # بطاقة عرض التاريخ
│       ├── islamic_event_tile.dart    # عنصر المناسبة
│       └── month_calendar_view.dart   # عرض الشهر
└── services/
    └── hijri_service.dart             # خدمة التقويم
```

## Implementation Steps

### Step 1: Create HijriDate Entity
- إنشاء كلاس للتاريخ الهجري (يوم، شهر، سنة)
- أسماء الأشهر الهجرية بالعربية
- أسماء الأيام بالعربية

### Step 2: Create HijriDateConverter
- خوارزمية تحويل من الميلادي للهجري
- خوارزمية تحويل من الهجري للميلادي

### Step 3: Create Islamic Events Data
- قائمة بالمناسبات الإسلامية المهمة
- تحديد تاريخ كل مناسبة بالهجري
- حساب عدد الأيام المتبقية لكل مناسبة

### Step 4: Create UI Components
- HijriDateCard لعرض التاريخ الحالي
- إضافة البطاقة للشاشة الرئيسية
- صفحة تفصيلية للتقويم (اختياري)

### Step 5: Add Navigation & Strings
- إضافة Route إذا لزم الأمر
- إضافة النصوص العربية

## Islamic Months (الأشهر الهجرية)
1. محرم
2. صفر
3. ربيع الأول
4. ربيع الثاني
5. جمادى الأولى
6. جمادى الآخرة
7. رجب
8. شعبان
9. رمضان
10. شوال
11. ذو القعدة
12. ذو الحجة

## Important Islamic Events
- 1 محرم: رأس السنة الهجرية
- 10 محرم: عاشوراء
- 12 ربيع الأول: المولد النبوي الشريف
- 27 رجب: الإسراء والمعراج
- 15 شعبان: ليلة النصف من شعبان
- 1 رمضان: بداية رمضان
- ليالي العشر الأواخر: ليلة القدر
- 1 شوال: عيد الفطر
- 9 ذو الحجة: يوم عرفة
- 10 ذو الحجة: عيد الأضحى

## UI Design

```
┌─────────────────────────────┐
│     التاريخ الهجري           │
├─────────────────────────────┤
│                             │
│    ┌─────────────────┐      │
│    │   15 رجب 1446   │      │
│    │   الثلاثاء       │      │
│    └─────────────────┘      │
│                             │
│  المناسبات القادمة:          │
│  ├─ الإسراء والمعراج (12 يوم) │
│  ├─ ليلة النصف من شعبان      │
│  └─ رمضان                   │
│                             │
└─────────────────────────────┘
```

## Testing Plan
1. Unit tests للـ HijriDateConverter
2. Widget tests للـ HijriDateCard
3. اختبار حساب المناسبات القادمة

## Post-Implementation
1. تشغيل جميع الاختبارات
2. التأكد من عدم وجود أخطاء
3. Commit و Push التغييرات
