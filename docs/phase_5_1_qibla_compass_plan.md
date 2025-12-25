# Phase 5.1: Qibla Compass Feature Plan

## Overview
إضافة ميزة بوصلة القبلة للتطبيق لمساعدة المستخدمين في تحديد اتجاه القبلة للصلاة.

## Technical Requirements

### Dependencies Required
```yaml
flutter_compass: ^0.8.0  # للوصول لبوصلة الجهاز
geolocator: ^11.0.0      # للحصول على موقع المستخدم
permission_handler: ^11.3.0  # لإدارة صلاحيات الموقع والبوصلة
```

### Qibla Calculation Formula
اتجاه القبلة يُحسب باستخدام المعادلة التالية:
```
Qibla Direction = atan2(
  sin(meccaLongitude - userLongitude),
  cos(userLatitude) * tan(meccaLatitude) - sin(userLatitude) * cos(meccaLongitude - userLongitude)
)
```

حيث:
- إحداثيات الكعبة: Latitude = 21.4225°, Longitude = 39.8262°

## File Structure
```
lib/features/qibla/
├── data/
│   └── qibla_calculator.dart          # حساب اتجاه القبلة
├── presentation/
│   ├── view/
│   │   └── screens/
│   │       └── qibla_screen.dart      # شاشة البوصلة الرئيسية
│   └── widgets/
│       ├── compass_widget.dart        # ويدجت البوصلة
│       ├── qibla_indicator.dart       # مؤشر اتجاه القبلة
│       └── location_permission_widget.dart  # طلب الصلاحيات
└── services/
    └── location_service.dart          # خدمة الموقع
```

## Implementation Steps

### Step 1: Add Dependencies
- إضافة flutter_compass للـ pubspec.yaml
- إضافة geolocator للحصول على الموقع
- إضافة permission_handler لإدارة الصلاحيات

### Step 2: Platform Configuration
**Android (android/app/src/main/AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج إلى موقعك لتحديد اتجاه القبلة</string>
```

### Step 3: Create Qibla Calculator
- إنشاء كلاس لحساب اتجاه القبلة بناءً على موقع المستخدم
- استخدام إحداثيات الكعبة الثابتة

### Step 4: Create Location Service
- الحصول على موقع المستخدم الحالي
- التعامل مع حالات رفض الصلاحيات
- معالجة الأخطاء

### Step 5: Create Compass Widget
- رسم بوصلة متحركة
- عرض الاتجاهات الأربعة (شمال، جنوب، شرق، غرب)
- تحريك البوصلة بناءً على اتجاه الجهاز

### Step 6: Create Qibla Screen
- عرض البوصلة مع مؤشر القبلة
- عرض المسافة إلى مكة المكرمة
- عرض زاوية القبلة بالدرجات

### Step 7: Add Navigation
- إضافة Route للشاشة
- إضافة زر للوصول من الشاشة الرئيسية

### Step 8: Add Strings
- إضافة النصوص العربية المطلوبة

## UI Design

```
┌─────────────────────────────┐
│        بوصلة القبلة          │
├─────────────────────────────┤
│                             │
│      ┌─────────────┐        │
│      │      N      │        │
│      │   ╱     ╲   │        │
│      │  W   🕋   E │        │  ← مؤشر الكعبة
│      │   ╲     ╱   │        │
│      │      S      │        │
│      └─────────────┘        │
│                             │
│   اتجاه القبلة: 135°        │
│   المسافة: 2500 كم          │
│                             │
└─────────────────────────────┘
```

## Testing Plan
1. Unit tests للـ QiblaCalculator
2. Widget tests للـ CompassWidget
3. Integration tests للشاشة الكاملة

## Post-Implementation
1. تشغيل جميع الاختبارات
2. التأكد من عدم وجود أخطاء تحليلية
3. Commit و Push التغييرات
